param 
(
    [string]$zimoryConfigurationFile,#This is the Plugconfiguration file that comes from CIC
    [string]$zimoryOnBoardingConfigurationFile,#Contains static information about the environment, domain name, local admin password etc.
    [string]$SkipEarlyStepsForDebugging,
    [string]$isDSIInstall,
    [string]$onlyProcessSizingAndNotInstall,
    [string]$ignoreSizingOutputNamesAndImportServerNamesAndIPs,
    [string]$smallPreSizeDBsForDevInstalls,
    [string]$onlyFullyProcessXMLButNoScriptExecution,
    [string]$onlyGetAsFarAsCopyingSPAndSQLHotfixes,
    [string]$OnlyGetAsFasAsRunningStartupScripts,
    [string]$SkipXMLCreation = "False",
    [int]$amsSessionID
)


$useNewPlugs = $false
$currentVersion = "3.5.2"
[int]$numCurrentVersion = $currentVersion.Replace(".", "")

#Execute 2 commands which will ensure scripts run smoothly.
Set-ExecutionPolicy Bypass -Force
Get-PSSession | Remove-PSSession

net use * /delete /y
net stop dnscache
net start dnscache
net use * /delete /y

# Configure all the file locations.
#Get current script location.
$getCurrentScriptLocation = Get-Location

#################################################################################################
#Static Configuration information - locations of xml,xsl files
#################################################################################################
$xmlMergedConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\SQL\MergedTransformed_" + $currentVersion + "_SQL_JD.xml")#This is the XML file which will be used by the scripted install. Its content will change over the Steps below (it will be merged and then later transformed to meet the XML schema needed by the scripts).
$xmlFinalTempConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\SQL\FinalStage1Output_" + $currentVersion + "_SQL_JD.xml")#This is the XML file which will be used by the scripted install.
$xmlCustomerEnvironmentTempConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\SQL\MergedCustomerEnvironmentTransformed_" + $currentVersion + "_SQL_JD.xml")#This is the XML file which holds several settings which are specific to the customer/environment (farm number, deployment sever name, media server name, search proxy).
$xmlCustomerOnboardingTempConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\SQL\MergedCustomerOnBoardingTransformed_" + $currentVersion + "_SQL_JD.xml")#New for 3.1.0 - An extra transform is needed to mix the Customer Service Data with the OnBoarding data.
$xmlFinalConfigFileNoPath = "Final_" + $currentVersion + "_SQL_JD_BaseService.xml"#Name of the final xml file that is used for the installation
$xmlFinalConfigFile = $($getCurrentScriptLocation.Path + "\" + $xmlFinalConfigFileNoPath)#Path of the final xml file that is used for the installation
$xmlFinalConfigFileHANoPath = "Final_" + $currentVersion + "_SQL_JD_BaseService_HA.xml"#Name of the final xml file that is used for the installation, used with HA installations
$xmlFinalConfigFileHA = $($getCurrentScriptLocation.Path + "\" + $xmlFinalConfigFileHANoPath)#Path of the final xml file that is used for the installation, used with HA installations
$xmlFinalConfigFileNoPathWithExtensionsForBinaryInstall = "Final_" + $currentVersion + "_SQL_JD_BaseServiceAndAllExtensions_BinariesOnly.xml"# used to install SP Binaries to the Base Servers and All extensions.
$xmlFinalConfigFileWithExtensionsForBinaryInstall  = $($getCurrentScriptLocation.Path + "\" + $xmlFinalConfigFileNoPathWithExtensionsForBinaryInstall)# used to install SP Binaries to the Base Servers and All extensions.
$xsltEnvironmentAndZimory = $($getCurrentScriptLocation.Path + "\SQL_CustomerAndEnvironment_Zimory_Transform.xsl")
$xsltZimoryAndStatic = $($getCurrentScriptLocation.Path + "\Service Executors\XSLT\SAO_SQL_Static_Zimory_Transform.xslt")
$xsltStage1 = $($getCurrentScriptLocation.Path + "\Service Executors\XSLT\SQLConfigurationTransformStage1.xsl")#This file from the Original SP installation added content DBs to the final XML, it now does nothing
$xsltStage2 = $($getCurrentScriptLocation.Path + "\Service Executors\XSLT\SQLfarmconfigurationtransformstage2.xsl")
#################################################################################################
#End - Static Configuration information 
#################################################################################################

#################################################################################################
#Dynamic Configuration information - configuration information loaded by ES_CustomerAndEnvironment_Zimory_Transform.xsl
#################################################################################################
#Copy the SP and SQL Scripts from the Media Server.
[xml]$environmentConfig = Get-Content $xsltEnvironmentAndZimory
$htmlStatusFile = ($environmentConfig.SelectSingleNode("//htmlstatuspage")).InnerText
$htmlAdminPageFile = ($environmentConfig.SelectSingleNode("//htmladminpage")).InnerText
$htmlUpdateFile = ($environmentConfig.SelectSingleNode("//htmlupdatefile")).InnerText
$spMediaLocation = ($environmentConfig.SelectSingleNode("//spscriptlocation")).InnerText#This get overwritten later
$sqlMediaLocation = ($environmentConfig.SelectSingleNode("//sqlscriptlocation")).InnerText#This is not used anywhere in this file TODO: remove
# [TB] 3.1.5 - support copying all media locally
$localMediaLocation = ($environmentConfig.SelectSingleNode("//localmediapath")).InnerText
#New for 3.0.0 - in a dev environment if we use VMWare Workstation 8+, we can reset the VMs etc. Requires hard coding of the batch files.
$ngVMServer = ($environmentConfig.SelectSingleNode("//dev_vmrun_server_ip")).InnerText
#New for 3.0.0 - Get Deploy Server and Media Server UserName.
$deployServerUserName = ($environmentConfig.SelectSingleNode("//deploymentserverusername")).InnerText       
$deployServerPassword = ($environmentConfig.SelectSingleNode("//deploymentserverpassword")).InnerText       
$mediaServerUserName = ($environmentConfig.SelectSingleNode("//mediaserverusername")).InnerText       
$mediaServerPassword = ($environmentConfig.SelectSingleNode("//mediaserverpassword")).InnerText       
#New for 3.0.0 - Pick up value from XML to determine if we pre-install the binaries for the Base and the HA Extension.
$preInstallSPBinariesForAllExtensions = ($environmentConfig.SelectSingleNode("//preinstallspbinariesforhainbaseprovisioning")).InnerText
#################################################################################################
#End - Dynamic Configuration information  
#################################################################################################

#New for 3.1.0 - have seperate import servers folders for 2008 and 2012.
$oSVersion = "2008"
$is2012Install = ($environmentConfig.SelectSingleNode("//isWin2012")).InnerText   
if ($is2012Install -eq "True")
{
    $oSVersion = "2012"
}   
#New for 3.0.0 + - a File to import sevrer names. updated for 3.1.0 to include OS version in folder path.
$xmlServerImportFile = $($getCurrentScriptLocation.Path + "\Server Import XML\" + $oSVersion + "\es_base_servers_import.xml")
$xmlHAServerImportFile = $($getCurrentScriptLocation.Path + "\Server Import XML\" + $oSVersion + "\es_ha_servers_import.xml")


. ".\Common\TSPInstallerLogging.ps1"
. ".\Common\TSCommonFunctions.ps1"
. ".\Common\JSONFunctions.ps1"


#Reset the error/warning counters. These are not used in this release but may be used in future for finer grained reporting.
$LASTEXITCODE = 0
$errCount = 0
$warningCount = 0

#Configure logging
$currentDate = Get-Date -format "yyyy-MMM-d-HH-mm-ss"
LogStartTracing $("c:\v3_ServiceExecutorBaseES" + $currentDate.ToString() + ".txt") $htmlUpdateFile $htmlAdminPageFile $htmlStatusFile

logStatusMessageToHTML "Installing the Base Service" "[SQL BASE]" $amsEnabled
writeStatusPageUpdate "1" $amsEnabled

if ($SkipEarlyStepsForDebugging -eq $false)
{
#STEP 1 - Process XML (merge Zimory configuration with our static XML structure)
    LogStep "Merge customer specific metadata with our static XML"    
    try
    {   if ($SkipXMLCreation -eq "False")
        { 
            mergeCustomerAndEnvironmentConfiguration $xsltZimoryAndStatic $xsltEnvironmentAndZimory $zimoryConfigurationFile $xmlMergedConfigFile $xmlCustomerEnvironmentTempConfigFile $xmlCustomerOnboardingTempConfigFile $zimoryOnBoardingConfigurationFile #Merge the XML from Zimory with our raw XML. There are 2 transforms being done in here.
        }
    }
    catch
    {
        LogRuntimeError "Error occurred getting Zimory Configuration or during merging Customer metadata with our Static/Environment Metadata. Stop Installation" $_
        exit 1;
    }
#END STEP 0 - Process XML    
    
#STEP 2 - Sizing Calculator
    LogStep "Sizing Calculator" 
    try
    {
	   if ($SkipXMLCreation -eq "False")#we are not skipping creating the xml
		{     
		   processSizingSQLv2 $xmlMergedConfigFile #Calculate the number of servers etc and then write directly back to the XML.                
		}	       
    }
    catch
    {
        LogRuntimeError "Error occurred during sizing calculator. Stop Installation" $_
        exit 1;
    }
#END STEP 2 - Sizing Calculator  

#STEP 3 - Perform XSLT Transform
    LogStep "Transform XML" 
    try
    {   
        if ($SkipXMLCreation -eq "False")
        {     
            transformXMLToFinalSchema $xsltStage1 $xsltStage2 $xmlMergedConfigFile $xmlFinalTempConfigFile $xmlFinalConfigFile #perform XSLT transform (which contains logic) to the final XML schema.
            
			
            #New for 3.4.0 + - Do the HA sizing too.
            [xml]$xmlFinalConfigFileHATEMP = Get-Content $xmlFinalConfigFile -Encoding UTF8 
            if (($xmlFinalConfigFileHATEMP.Configuration.Install.IsHAInstall -eq "True") )
            {
                logStatusMessageToHTML "HA Configuration XML will be Processed" "[SQL BASE]" $amsEnabled    
                $xmlFinalConfigFileHATEMP.Save($xmlFinalConfigFileHA)       
				processSizingSQLv2Extension $xmlFinalConfigFile $xmlFinalConfigFileHA -hA $true -qpsMultiplier 0

                #New for 3.4.0 - Make some dynamic setting of Always On values possible.
                updateSQLHAConfigWithDynamicValuesIfNeeded $xmlFinalConfigFileHA -hA $true       
                updateSQLAliasesWithShareValues $xmlFinalConfigFileHA -hA $true       
                updateSQLAliasesToReflectNewDBServers_ES_HA $xmlFinalConfigFileHA -hA $true                                       

                updateSQLAliasesForAlwaysOn_NewALwaysOnElementsOnly $xmlFinalConfigFileHA
                    
                [xml]$xmlFinalConfigFileHATEMP2 = Get-Content $xmlFinalConfigFileHA -Encoding UTF8 
                $xmlFinalConfigFileHATEMP2.Save($xmlFinalConfigFile)
            }

        }
        logStatusMessageToHTML "Base Configuration XML Processed" "[SQL BASE]" $amsEnabled        
    }
    catch
    {
        LogRuntimeError "Error occurred during XSLT Transform. Stop Installation" $_
        exit 1;
    }
#END STEP 3 - XSLT Transform

#STEP 4 - Provision Deployments made up with:Stage 1 - Provision the deployment and Stage 2 - initial Startup script configuration.
    #New for 2.7.1+ - Add the optional to only run the Sizing Calculator. I may remove this for future releases. Is purely to test Sizing Calculator in isolation.
    if ($onlyProcessSizingAndNotInstall -eq "True")
    {
        [xml]$processedFinalXML = Get-Content $xmlFinalConfigFile -Encoding UTF8
        $userCount = $processedFinalXML.Configuration.Install.Sizing.AmountOfUsers
        $indexItemCount = $processedFinalXML.Configuration.Install.Sizing.AmountIndexedItems        
        $newConfigName = $xmlFinalConfigFile.Replace(".xml", $("__SIZINGTEST__UC-" + $userCount + "__IC-" + $indexItemCount + ".xml"))
        $processedFinalXML.Save($newConfigName)
    }
    else
    {        
            LogStep "Provision Deployment(s)"   
            #Stage 1 - Provision the deployment(s) and wait for the deployment to be RUNNING.
				try
				{   
					logStatusMessageToHTML "About to provision the VMs" "[SQL BASE]" $amsEnabled
					configureLocalHostFileZimoryServer $xmlFinalConfigFile #In DSI we need a host entry to access Zimory API. This will add the host entry if its defined in the XML.
					#Simple test for post CEBIT work - check is version 2.7.X or higher.   
					if ($numCurrentVersion -gt 269)
					{
						if ($ignoreSizingOutputNamesAndImportServerNamesAndIPs -eq $false)
						{
							if ($SkipXMLCreation -eq "False")
							{
								provisionDeploymentsSQLv2 $xmlFinalConfigFile $getCurrentScriptLocation #Use Zimory API to create deployments and update the XML with the new IP addresses of these VMs. This function will not return until the deployment has started - which could be a LONG delay - 1 to 2 hours etc. 
							}
						}
						else
						{
							
							#Base Service, update IP Addresses
                            #Not needed for SQL Deployements
							updateIPAddressesForImportedServers $xmlFinalConfigFile
							if ($isDSIInstall -eq $true)
							{
								loginfo  "Is DII Install, and we have set to Import Server. Servers must be Domain Joined already."
								logStatusMessageToHTML "Is DII Install, and we have set to Import Server. Servers must be Domain Joined already." "[SQL BASE]" $amsEnabled                            
				  #              updateDomainJoinedFlagOnDeploymentsv3 $xmlFinalConfigFile $xmlFinalConfigFile
							}

                            #Not needed for SQL Deployements
							if ($isDSIInstall -eq $false)
							{
								#Reset the VMs - this is experimental and doesnt work well. Only for Base Service.
								logStatusMessageToHTML "Test Install - Reset the VMs" "[SQL BASE]" $amsEnabled
								if ($preInstallSPBinariesForAllExtensions -eq $false)
								{
			   #                     executeResetBaseServiceVMsNGEnvironment $ngVMServer $getCurrentScriptLocation
								}
							}
							
							#New functionality - run through the Service Extensions Sizing
							if ($preInstallSPBinariesForAllExtensions -eq $true)
							{
								if ($isDSIInstall -eq $false)
								{
									executeResetBaseServiceAndExtensionsVMsNGEnvironment $ngVMServer $getCurrentScriptLocation
								}
								logStatusMessageToHTML "Also Process Extension Binaries." "[SQL BASE]" $amsEnabled
								[xml]$baseConfig = Get-Content $xmlFinalConfigFile -Encoding UTF8
								$baseConfig.Save($xmlFinalConfigFileWithExtensionsForBinaryInstall)
								processSizingESv2Extension $xmlFinalConfigFile $xmlFinalConfigFileWithExtensionsForBinaryInstall -hA $true -qpsMultiplier 0
								importServersAndReplaceSizingCalculatorOutputExtension -importServersXML $xmlHAServerImportFile -configXML $xmlFinalConfigFileWithExtensionsForBinaryInstall
								updateIPAddressesForImportedServers $xmlFinalConfigFileWithExtensionsForBinaryInstall
								
								$xmlFinalConfigFile = $xmlFinalConfigFileWithExtensionsForBinaryInstall
								$xmlFinalConfigFileNoPath = $xmlFinalConfigFileNoPathWithExtensionsForBinaryInstall
							}  
						}										
					}
					else
					{
						#Delete soon - legacy to support the CEBIT (single server only) scripted installs.
						provisionDeployments $xmlFinalConfigFile $getCurrentScriptLocation #Use Zimory API to create deployments and update the XML with the new IP addresses of these VMs. This function will not return until the deployment has started - which could be a LONG delay - 1 to 2 hours etc. 
					}

					#New for 3.0.1 - Stop Install at this point if argument says so.
					if ($onlyFullyProcessXMLButNoScriptExecution -eq $true)
					{
						logStatusMessageToHTML "Finished Early Due to 'onlyFullyProcessXMLButNoScriptExecution' flag" "[SQL BASE]" $amsEnabled
						LogEndServiceExecutionTracing
						return 0
					}
					configureLocalHostFile $xmlFinalConfigFile #To ensure that we only interact with the correct servers, we will modify the local host file. We need this because we are provisioning multiple VMs with identical Windows Computer names.
					logStatusMessageToHTML "Virtual Machines provisioned" "[SQL BASE]" $amsEnabled
				}
				catch
				{
					LogRuntimeError "[SQL BASE] Error occurred during provisioning Deployments via Zimory API. Stop Installation" $_
					exit 1;
				}
            #End Stage 1


            #Stage 2 - now the deployment(s) are running, perform the initial Startup script configuration.
				try
				{                 
					#STEP 4.1 - Startup Scripts
					logStatusMessageToHTML "Running Startup Scripts"  "[SQL BASE]" $amsEnabled   
					
					net use * /delete /y
					net stop dnscache
					net start dnscache
					net use * /delete /y

					#copySQLStartupScriptsToServer $xmlFinalConfigFile $getCurrentScriptLocation
					#copySQLHotfixesToSQLServers -xmlConfigFile $xmlFinalConfigFile -getCurrentScriptLocation $getCurrentScriptLocation

					#New for 3.0.1 - Stop Install at this point if argument says so.
					if ($onlyGetAsFarAsCopyingSPAndSQLHotfixes -eq $true)
					{
						logStatusMessageToHTML "Finished Early Due to 'onlyGetAsFarAsCopyingSPAndSQLHotfixes' flag" "[SQL BASE]" $amsEnabled
						LogEndServiceExecutionTracing
						return 0
					}

					#executeFireWallDisableScriptOnDeploymentsv4 $xmlFinalConfigFile $getCurrentScriptLocation #turn off the firewall.        
					#executeUACDisableScriptOnDeploymentsv3_AUTOREBOOT_v4 $xmlFinalConfigFile $getCurrentScriptLocation #disable UAC. For dev, this will trigger a reboot.									   

					net use * /delete /y
					net stop dnscache
					net start dnscache
					net use * /delete /y
					
					#executeInstallSQLPreInstallHotfixesOnDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #Install .NET 4 and PowerShell 3 on the SQL Server. We need this for some of our scripting.

					net use * /delete /y  
					
					#executeEnableRDPScriptOnDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #Enable RDP
					
					checkAllServersHaveRebooted $xmlFinalConfigFile #Check the Servers can be pinged
		  
                    #Not needed for SQL Deployements
					if ($ignoreSizingOutputNamesAndImportServerNamesAndIPs -eq $false)
					{
						LogInfo "We are not importing servers, so set the Computer Names"
						executeRenameHostsScriptOnDeployments_AUTOREBOOTv4 $xmlFinalConfigFile $getCurrentScriptLocation #run script which sets the computer names of each deployment. This will trigger a reboot.
						checkAllServersHaveRebooted $xmlFinalConfigFile                
						#waitForPSRemotingToBeAvailable $xmlFinalConfigFile #ensure that all the servers are available via PS Remoting.  
						#New for 2.7.2 - Configure Local Disks
						executeConfigureLocalDisksScriptOnDeploymentsv4 $xmlFinalConfigFile $getCurrentScriptLocation #run script which sets up the local disks (formats them and mounts them. etc)
					}
					else
					{
						LogInfo "We are importing servers, so dont set the Computer Names"   
					}
					net use * /delete /y
					 net use * /delete /y
					net stop dnscache
					net start dnscache
					net use * /delete /y

					checkAllServersHaveRebooted $xmlFinalConfigFile #Check the Servers can be pinged

					#New for 3.1.8 + - Tidy up the C drive post deployment.
					tidyUpCDriveStartUpScriptOutput $xmlFinalConfigFile $getCurrentScriptLocation #rmeove temp files from c. copy to e                      

					logStatusMessageToHTML "Reboot all Servers"  "[SQL BASE]" $amsEnabled   
					LogInfo "Reboot all Servers prior to main install"
					RestartAll-AllSPServersLocalAdminAccount-WaitWMI $xmlFinalConfigFile                
				}
				catch
				{
					LogRuntimeError "[SQL BASE] Error occurred during provisioning Deployments via Zimory API or performing initial configuration (computer name, local disks etc). Stop Installation" $_
					exit;
				}
				#New for 3.0.1 - Stop Install at this point if argument says so.
				if ($OnlyGetAsFasAsRunningStartupScripts -eq $true)
				{
					logStatusMessageToHTML "Finished Early Due to 'OnlyGetAsFasAsRunningStartupScripts' flag" "[SQL BASE]" $amsEnabled
					LogEndServiceExecutionTracing
					return 0
				}
			#End Stage 2
        }
    }
#END STEP 4 - Provision Deployments 
    
#STEP 5 - Start Script Execution - made up of: Copy Media, Stage 2 Save Final XML
    #New for 2.7.1 - Add the optional to only run the Sizing Calculator. I may remove this for future releases.
    if ($onlyProcessSizingAndNotInstall -eq "False")#we are doing the install and not just sizing
    {    
		#Stage 1 Copy Media
			net use * /delete /y
			net stop dnscache
			net start dnscache
			net use * /delete /y

			if ($preInstallSPBinariesForAllExtensions -eq $true)
			{
				$xmlFinalConfigFile = $xmlFinalConfigFileWithExtensionsForBinaryInstall
				$xmlFinalConfigFileNoPath = $xmlFinalConfigFileNoPathWithExtensionsForBinaryInstall            
			}

			#New for v3 - Copy all packages (and XML) to all Servers   
			[xml]$configForCopy = Get-Content $xmlFinalConfigFile  -Encoding UTF8 
			$spMediaLocation = $("\\" + $configForCopy.Configuration.Install.MediaServer + "\MediaShare\SP Scripts v3")

			configureLocalHostFile $xmlFinalConfigFile #To ensure that we only interact with the correct servers, we will modify the local host file. We need this because we are provisioning multiple VMs with identical Windows Computer names.
				   
			#copyCommonPackageToServers $($xmlFinalConfigFile) $getCurrentScriptLocation $spMediaLocation        
			#copyAllScriptPackagesToServers $xmlFinalConfigFile $getCurrentScriptLocation $spMediaLocation
			#copyConfigurationXMLToEachServer $xmlFinalConfigFile $getCurrentScriptLocation          
	   	   
			# [TB] 3.1.5 - copy all media to each server (if required)
			if ($localMediaLocation -ne $null -and $localMediaLocation -ne "")
			{
				#copyMediaToEachServer $xmlFinalConfigFile
			}							
		#End Stage 1 Copy Media
				
        [xml]$xmlFinalConfigFileDOM = Get-Content $xmlFinalConfigFile -Encoding UTF8 
        #Now that the Deployments are provisioned, start executing the scripts.
        LogStep "Start script execution against the Deployment(s)"    
        try
        {                                         
            #Stage 2 Save Final XML
				LogStep "Copy XML Config file to the SP Scripts sub folder."
				saveFinalXML -xMLConfigFile $xmlFinalConfigFile -configName $xmlFinalConfigFileNoPath -newPath  $($getCurrentScriptLocation.Path + "\Configuration Management\Installations Configuration XML\")    
				writeStatusPageUpdate "2" $amsEnabled
			#END Stage 2 Save Final XML
          
			#Stage 3 Configure DC & Accounts
				if ($ignoreSizingOutputNamesAndImportServerNamesAndIPs -eq $false)
				{                             
					LogStep "Configure Domain Settings"
					LogInfo "Calling .\Packages\Domain Configuration\Manager_ConfigureDCAndAccounts.ps1; All"
					#Update the log file prefix
					$stepLogFilePrefix = "Manager_ConfigureDCAndAcounts"
					$stepLocalLogFilePrefix = "Local_ConfigureDCAndAcounts" 
					[datetime] $startOperationTime =  get-date        
                   # powershell.exe -noprofile -file "Packages\Domain Configuration\Manager_ConfigureDCAndAccounts.ps1" $xmlFinalConfigFileNoPath "All" #| Out-Null
					LogInfo $((processExitCode $LASTEXITCODE "Configure DC") +  " (Exit Code: " + $LASTEXITCODE + ")")
					$LASTEXITCODE = 0                         
				}
			#End Stage 3 Configure DC & Accounts
			
            #Stage 4 Install SQL
				LogStep "Installing SQL Server 2012"
				LogInfo "Calling Packages\SQL Binaries\Manager_InstallSQLBinaries.ps1"
				$currentSessionDetailID = logStatusMessageToHTML "Installing SQL Server" "[SQL BASE]" $amsEnabled
				#Update the log file prefix
				$stepLogFilePrefix = "Manager_InstallSQLBinaries"
				$stepLocalLogFilePrefix = "Local_InstallSQLBinaries" 
				[datetime] $startOperationTime = get-date       
                #powershell.exe -noprofile -file "Packages\SQL Binaries\Manager_InstallSQLBinaries.ps1" $xmlFinalConfigFileNoPath "False" #| Out-Null
				LogInfo $((processExitCode $LASTEXITCODE "Install SQL") +  " (Exit Code: " + $LASTEXITCODE + ")")
				
				LogInfo "This is a test (non DSI) install. Only sleep for 1 minutes"
				Sleep (60)
				LogInfo "Sleep complete" 
					
				$LASTEXITCODE = 0
			#END Stage 4 Install SQL
           
            #Stage 5 - Create additional data drives if needed.
				LogStep "Configuring 2nd Data Drive Folders"
				LogInfo "Calling ConfigureSQLForES.ps1; CreateDataDriveFoldersOnly"
				$currentSessionDetailID = logStatusMessageToHTML "SQL Create 2nd Drive Folders (1 of 1)" "[SQL BASE]" $amsEnabled
				#Update the log file prefix
				$stepLogFilePrefix = "Manager_ConfigureSQL"  
				$stepLocalLogFilePrefix = "Local_ConfigureSQL" 
				[datetime] $startOperationTime = get-date                 
				#powershell.exe -noprofile -file "Packages\Configure SQL\Manager_ConfigureSQL.ps1"  $xmlFinalConfigFileNoPath $smallPreSizeDBsForDevInstalls "CreateDataDriveFoldersOnly" #| Out-Null
				LogInfo $((processExitCode $LASTEXITCODE "Create 2nd Disk Folders") +  " (Exit Code: " + $LASTEXITCODE + ")")
				$LASTEXITCODE = 0                
            #Stage 5 - Create additional data drives if needed.

            #Stage 6 - Configure Model DB
				LogStep "Configuring SQL Model DB"
				LogInfo "Calling ConfigureSQLForES.ps1; ModelDBOnly"
				$currentSessionDetailID = logStatusMessageToHTML "SQL Model DB changes (1 of 1)" "[SQL BASE]" $amsEnabled
				#Update the log file prefix
				$stepLogFilePrefix = "Manager_ConfigureSQLForES"  
				$stepLocalLogFilePrefix = "Local_ConfigureSQLForES" 
				[datetime] $startOperationTime = get-date                 
				#powershell.exe -noprofile -file "Packages\Configure SQL\Manager_ConfigureSQL.ps1"  $xmlFinalConfigFileNoPath $smallPreSizeDBsForDevInstalls "ModelDBOnly" #| Out-Null
				LogInfo $((processExitCode $LASTEXITCODE "Starting SQL Model DB changes") +  " (Exit Code: " + $LASTEXITCODE + ")")
				$LASTEXITCODE = 0
            #END Stage 6 - Configure Model DB
             
           
			if (($xmlFinalConfigFileDOM.Configuration.Install.IsHAInstall -eq "True")  -or ($xmlFinalConfigFileDOM.Configuration.Install.IsHAInstall -eq "TRUE") -or ($xmlFinalConfigFileDOM.Configuration.Install.IsHAInstall -eq "true"))
			{
				#NOT NEEDED FOR SQL ONLY INSTALLATIONS
				#STEP 5.5 - Upgarde editions of SQL Server to Enterprise.
				LogStep "Installing SQL Server 2012"
				LogInfo "Calling .\InstallSQLBinaries.ps1;"
				$currentSessionDetailID = logStatusMessageToHTML "Upgrade Editions SQL Server" "[HA]" $amsEnabled
				$stepLogFilePrefix = "Manager_InstallSQLBinaries"   
				$stepLocalLogFilePrefix = "Local_InstallSQLBinaries" 
				[datetime] $startOperationTime =  get-date   
			    #powershell.exe -noprofile -file "Packages\SQL Binaries\Manager_InstallSQLBinaries.ps1" $xmlFinalConfigFileNoPath "True" #| Out-Null
				LogInfo $((processExitCode $LASTEXITCODE "Install SQL") +  " (Exit Code: " + $LASTEXITCODE + ")")
			   
				$LASTEXITCODE = 0

			}

            #Stage 7 Configuring SQL Maintainence
				LogStep "Configuring SQL Maintainence"
				LogInfo "Calling ConfigureSQLForES.ps1; SQLMaintainencePlan"
				$currentSessionDetailID = logStatusMessageToHTML "SQL DB Modifications (Stage 1 of 1)" "[SQL BASE]" $amsEnabled
				#Update the log file prefix
				$stepLogFilePrefix = "Manager_ConfigureSQL"
				$stepLocalLogFilePrefix = "Local_ConfigureSQL" 
				[datetime] $startOperationTime =  get-date
				#powershell.exe -noprofile -file "Packages\Configure SQL\Manager_ConfigureSQL.ps1"  $xmlFinalConfigFileNoPath $smallPreSizeDBsForDevInstalls "SQLMaintainencePlan" #| Out-Null            
				LogInfo $((processExitCode $LASTEXITCODE "SQL DB changes") +  " (Exit Code: " + $LASTEXITCODE + ")")
				$LASTEXITCODE = 0
            #END Stage 7 - Configuring SQL DBs for a SP Install

			#Stage 8 configure Always-on Groups
			if (($xmlFinalConfigFileDOM.Configuration.Install.IsHAInstall -eq "True")  -or ($xmlFinalConfigFileDOM.Configuration.Install.IsHAInstall -eq "TRUE") -or ($xmlFinalConfigFileDOM.Configuration.Install.IsHAInstall -eq "true"))
			{

					#STEP 8.1 - Configure Always On Availability Groups - Step 1 the Shares, which updates the XML. 
						LogStep "Configuring Always On Availability Groups"
						LogInfo "Calling ConfigureAlwaysOn.ps1; ConfigureAlwaysOn"
						$stepLogFilePrefix = "Manager_ConfigureAlwaysOn" 
						$stepLocalLogFilePrefix = "Local_ConfigureAlwaysOn" 
						[datetime] $startOperationTime =  get-date 
						logStatusMessageToHTML "Configuring SQL Always On (Stage 1 of 2)" "[HA]" $amsEnabled
						#powershell.exe -noprofile -file "Packages\Ext High Availability\Manager_ConfigureAlwaysOnSQL.ps1" $xmlFinalConfigFileNoPath "SharesOnly"        
						LogInfo $((processExitCode $LASTEXITCODE "SQL Always On") +  " (Exit Code: " + $LASTEXITCODE + ")")
						$LASTEXITCODE = 0
					#END STEP 8.1 - Configure Always On Availability Groups - Step 1 the Shares, which updates the XML. 

					#STEP 8.2 - Configure Always On Availability Groups - Step 2 Clustering And AlwaysOn, which updates the XML. 
						LogStep "Configuring Always On Availability Groups"
						LogInfo "Calling ConfigureAlwaysOn.ps1; ConfigureAlwaysOn"
						$stepLogFilePrefix = "Manager_ConfigureAlwaysOn"  
						$stepLocalLogFilePrefix = "Local_ConfigureAlwaysOn" 
						[datetime] $startOperationTime =  get-date
						logStatusMessageToHTML "Configuring SQL Always On (Stage 2 of 2)" "[HA]" $amsEnabled
						#powershell.exe -noprofile -file "Packages\Ext High Availability\Manager_ConfigureAlwaysOnSQL.ps1" $xmlFinalConfigFileNoPath "ClusteringAndAlwaysOnOnly"        
						LogInfo $((processExitCode $LASTEXITCODE "SQL Always On") +  " (Exit Code: " + $LASTEXITCODE + ")")
						$LASTEXITCODE = 0
						
					#END STEP 8.2 - Configure Always On Availability Groups - Step 2 Clustering And AlwaysOn, which updates the XML. 

                    #NOT NEEDED FOR SQL ONLY INSTALLATIONS
					#STEP 8.3 - Update SQL Aliases on each SP Server - 
						LogStep "Configuring SharePoint local SQL Aliases for HA"
						LogInfo "Calling CreateFarmAndInititalConfigCombined.ps1; CreateSQLAliasesOnly"
						$currentSessionDetailID = logStatusMessageToHTML "SharePoint Install (SQL Aliases)" "[HA]" $amsEnabled
						#Update the log file prefix
						$stepLogFilePrefix = "Manager_CreateFarmAndInitialConfig"
						$stepLocalLogFilePrefix = "Local_CreateFarmAndInitialConfig" 
						[datetime] $startOperationTime =  get-date
						#powershell.exe -noprofile -file "Packages\Create Farm\Manager_CreateFarmAndInititalConfigCombined.ps1"  $xmlFinalConfigFileNoPath "CreateSQLAliasesOnlyHA" #| Out-Null
						LogInfo $((processExitCode $LASTEXITCODE "Create Farm And Initial Settings") +  " (Exit Code: " + $LASTEXITCODE + ")")
						$LASTEXITCODE = 0
						
					#END STEP 8.3 - Update SQL Aliases on each SP Server
                

				

                #NEW STEPS FOR 01/01/2015
                     #Stage 8.4 - Add always on automation
				        LogStep "Configuring Always On Availability Groups Automation"
				        LogInfo "Calling ConfigureSQL.ps1; ConfigureAlwaysOnAutomation"
				        $currentSessionDetailID = logStatusMessageToHTML "Configuring SQL Always On Automation" "[HA]" $amsEnabled
				        #Update the log file prefix
				        $stepLogFilePrefix = "Manager_ConfigureSQL"
				        $stepLocalLogFilePrefix = "Local_ConfigureSQL" 
				        [datetime] $startOperationTime =  get-date
				        powershell.exe -noprofile -file "Packages\Configure SQL\Manager_ConfigureSQL.ps1"  $xmlFinalConfigFileNoPath $smallPreSizeDBsForDevInstalls "SQLAlwaysOnAutomation" #| Out-Null            
				        LogInfo $((processExitCode $LASTEXITCODE "Always On Availability Groups Automation") +  " (Exit Code: " + $LASTEXITCODE + ")")
			            $LASTEXITCODE = 0
           
                    #END Stage 8.4 - Add always on automation
                #NEW STEPS FOR 01/01/2015				

			}
			#End Stage 8 configure Alwayson Groups

			#NEW STEPS FOR 01/01/2015
                     #Stage 8.4 - Add DBCreators
				        LogStep "Adding Admins to DBcreator Role"
				        LogInfo "Calling ConfigureSQL.ps1; AssignDBCreators"
				        $currentSessionDetailID = logStatusMessageToHTML "DBCreators" "[HA]" $amsEnabled
				        #Update the log file prefix
				        $stepLogFilePrefix = "Manager_ConfigureSQL"
				        $stepLocalLogFilePrefix = "Local_ConfigureSQL" 
				        [datetime] $startOperationTime =  get-date
				        powershell.exe -noprofile -file "Packages\Configure SQL\Manager_ConfigureSQL.ps1"  $xmlFinalConfigFileNoPath $smallPreSizeDBsForDevInstalls "AssignDBCreators" #| Out-Null            
				        LogInfo $((processExitCode $LASTEXITCODE "AssignDBCreators") +  " (Exit Code: " + $LASTEXITCODE + ")")
			            $LASTEXITCODE = 0
           
                    #END Stage 8.4 - Add DBCreators
                #NEW STEPS FOR 01/01/2015

            #Stage 9.0 - Configure all other DBs - Move Certain DBs
				LogStep "Start Agent Service Again"
				LogInfo "Calling ConfigureSQLForES.ps1; SQLIntegrationServicesServiceStart"
				$currentSessionDetailID = logStatusMessageToHTML "Start Agent Service" "[SQL BASE]" $amsEnabled
				#Update the log file prefix
				$stepLogFilePrefix = "Manager_ConfigureSQLForES"
				$stepLocalLogFilePrefix = "Local_ConfigureSQLForES" 
				[datetime] $startOperationTime =  get-date
				powershell.exe -noprofile -file "Packages\Configure SQL\Manager_ConfigureSQL.ps1"  $xmlFinalConfigFileNoPath $smallPreSizeDBsForDevInstalls "SQLMaintainencePlanAgentServiceStart" #| Out-Null            
				LogInfo $((processExitCode $LASTEXITCODE "Start Agent Service") +  " (Exit Code: " + $LASTEXITCODE + ")")
			    $LASTEXITCODE = 0
           
            #END Stage 9.0 - Configure all other DBs - Move Certain DBs
           
			#Configure-Firewall -XMLConfigPath $config -BuildAccount $BuildAccountCredentials  	   
				        
            #Get the Admin Page contents and write to the HTML page.
            LogInfo "Getting Admin Page contents"
            $adminPageContents = buildAdminPageContentsESSP $xmlFinalConfigFile
            LogInfo $("Admin Page Contents: " + $adminPageContents)
            clearDownAdminPageHTMLFile
            writeAdminPage $adminPageContents
            writeStatusPageUpdate "3" $amsEnabled

        }
        catch
        {
            LogRuntimeError "Error occurred during script execution to deployment(s). Stop Installation" $_
            logStatusMessageToHTML "ERROR: Install has failed" "[SQL BASE]" $amsEnabled
            writeStatusPageUpdate "4" $amsEnabled            

           exit 1;
        }

    }

#END STEP 5 - Start Script Execution
######################################################################  FINISHED   #############################################################
#Finish the logging.
logStatusMessageToHTML "Finished" "[SQL BASE]" $amsEnabled
LogEndServiceExecutionTracing
######################################################################  FINISHED   #############################################################

