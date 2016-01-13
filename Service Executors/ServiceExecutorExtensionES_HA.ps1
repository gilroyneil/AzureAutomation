param 
(    
    [string]$SkipEarlyStepsForDebugging,
    [string]$isDSIInstall,
    [string]$onlyProcessSizingAndNotInstall,
    [string]$plugName,
    [string]$ignoreSizingOutputNamesAndImportServerNamesAndIPs,
    [string]$smallPreSizeDBsForDevInstalls,
    [int]$amsSessionID 
)

$useNewPlugs = $false
$currentVersion = "3.4.0"
#Note - new for 3.0.3. This allows us to add a extension on top of a older version of the scripts. I would like to extend this and make it a version range. TODO - improve in 3.0.3 or 3.0.4.
$previousVersionToUpgradeFrom = "3.0.4"
[int]$numCurrentVersion = $currentVersion.Replace(".", "")
[int]$numPreviousMinorVersion = $previousVersionToUpgradeFrom.Replace(".", "")


#Execute 2 commands which will ensure scripts run smoothly.
Set-ExecutionPolicy Bypass -Force
Get-PSSession | Remove-PSSession

net use * /delete /y
net stop dnscache
net start dnscache
net use * /delete /y

#################################################################################################
# Configure all the file locations.
#Get current script location.
$getCurrentScriptLocation = Get-Location
#This is the static XML file which contains static configuration but no customer specific values. Its not in the final schema - its a very flat XML strucutre.
$staticXmlConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\RawStatic_" + $currentVersion + "_ES_JD.xml")
#This is the XML file which will be used by the scripted install. Its content will change over the Steps below (it will be merged and then later transformed to meet the XML schema needed by the scripts).
$xmlMergedConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\HA\MergedTransformed_" + $currentVersion + "_ES_JD.xml")
#This is the XML file which will be used by the scripted install.
$xmlFinalTempConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\HA\FinalStage1Output_" + $currentVersion + "_ES_JD.xml")
#This is the XML file which holds several settings which are specific to the customer/environment (farm number, deployment sever name, media server name, search proxy).
$xmlFinalTempConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\ES\FinalStage1Output_" + $currentVersion + "_ES_JD.xml")
#This is the XML file which holds several settings which are specific to the customer/environment (farm number, deployment sever name, media server name, search proxy).
$xmlCustomerEnvironmentTempConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\HA\MergedCustomerEnvironmentTransformed_" + $currentVersion + "_ES_JD.xml")

#New for 2.7.1+ - a XML file to store the topology.
#For 3.0.3 changes, see later in this file - basically we may wish to apply HA on top of a older release. Allow for 1 minor release backwards only.
$xmlCurrentTopologyConfigFileNoPath = "Final_" + $currentVersion + "_ES_JD_CurrentTopology.xml"
$xmlCurrentTopologyConfigFile = $($getCurrentScriptLocation.Path + "\Configuration Management\Installations Configuration XML\" + $xmlCurrentTopologyConfigFileNoPath)
$xmlCurrentTopologyPrevMinorVersionConfigFileNoPath = "Final_" + $previousVersion + "_ES_JD_CurrentTopology.xml"
$xmlCurrentTopologyPrevMinorVersionConfigFile = $($getCurrentScriptLocation.Path + "\Configuration Management\Installations Configuration XML\" + $xmlCurrentTopologyPrevMinorVersionConfigFileNoPath)




#These next 2 entries are the name of the final XML files which are created in steps 1 - 4
$xmlFinalConfigFileNoPath = "Final_" + $currentVersion + "_ES_JD_Extension_HA.xml"
$xmlFinalConfigFile = $($getCurrentScriptLocation.Path + "\" + $xmlFinalConfigFileNoPath)

$xsltEnvironmentAndZimory = $($getCurrentScriptLocation.Path + "\ES_CustomerAndEnvironment_Zimory_Transform.xsl")
if ($isDSIInstall -eq $false){$xsltEnvironmentAndZimory = $($getCurrentScriptLocation.Path + "\ES_CustomerAndEnvironment_Zimory_Transform_NON_TSYS.xsl")}

#New IF statement to support new plugs.
if ($useNewPlugs -eq $true)
{
    $xsltZimoryAndStatic = $($getCurrentScriptLocation.Path + "\Service Executors\XSLT\SAO_ES_Static_Zimory_Transform_newplug.xslt")
}
else
{
    $xsltZimoryAndStatic = $($getCurrentScriptLocation.Path + "\Service Executors\XSLT\SAO_ES_Static_Zimory_Transform.xslt")
}

$xsltStage1 = $($getCurrentScriptLocation.Path + "\Service Executors\XSLT\DSCFarmConfigurationTransformStage1.xsl")
$xsltStage2 = $($getCurrentScriptLocation.Path + "\Service Executors\XSLT\DSCFarmConfigurationTransformStage2.xsl")

#################################################################################################

#Copy the SP and SQL Scripts from the Media Server.
[xml]$environmentConfig = Get-Content $xsltEnvironmentAndZimory
$htmlStatusFile = ($environmentConfig.SelectSingleNode("//htmlstatuspage")).InnerText
$htmlAdminPageFile = ($environmentConfig.SelectSingleNode("//htmladminpage")).InnerText
$htmlFrontPageFile = ($environmentConfig.SelectSingleNode("//frontadminpage")).InnerText

$htmlUpdateFile = ($environmentConfig.SelectSingleNode("//htmlupdatefile")).InnerText
$mediaServer = ($environmentConfig.SelectSingleNode("//mediaserver")).InnerText
$spMediaLocation = ($environmentConfig.SelectSingleNode("//spscriptlocation")).InnerText
$sqlMediaLocation = ($environmentConfig.SelectSingleNode("//sqlscriptlocation")).InnerText

#################################################################################################
#New for 2.8.1+ - AMS integration
$amsUrl = ($environmentConfig.SelectSingleNode("//jsonurl")).InnerText
$amsProxy = ($environmentConfig.SelectSingleNode("//proxy")).InnerText
$amsAppKey = ($environmentConfig.SelectSingleNode("//applicationkey")).InnerText
$amsSessionTable = ($environmentConfig.SelectSingleNode("//sessiontable")).InnerText
$amsSessionDetailTable = ($environmentConfig.SelectSingleNode("//sessiondetailtable")).InnerText
$amsRegistrationsTable = ($environmentConfig.SelectSingleNode("//registrationstable")).InnerText
$amsSessionDetailServerTable = ($environmentConfig.SelectSingleNode("//sessiondetailservertable")).InnerText
$amsCustomerTable = ($environmentConfig.SelectSingleNode("//customertable")).InnerText

#################################################################################################
#New for 3.0.0 - in a dev environment if we use VMWare Workstation 8+, we can reset the VMs etc. Requires hard coding of the batch files.
$ngVMServer = ($environmentConfig.SelectSingleNode("//dev_vmrun_server_ip")).InnerText


#################################################################################################
#New for 3.0.0 - Get Deploy Server and Media Server UserName.
$deployServerUserName = ($environmentConfig.SelectSingleNode("//deploymentserverusername")).InnerText       
$deployServerPassword = ($environmentConfig.SelectSingleNode("//deploymentserverpassword")).InnerText       
$mediaServerUserName = ($environmentConfig.SelectSingleNode("//mediaserverusername")).InnerText       
$mediaServerPassword = ($environmentConfig.SelectSingleNode("//mediaserverpassword")).InnerText       
#################################################################################################

#New for 3.1.0 - have seperate import servers folders for 2008 and 2012.
$oSVersion = "2008"
$is2012Install = ($environmentConfig.SelectSingleNode("//isWin2012")).InnerText   
if ($is2012Install -eq "True")
{
    $oSVersion = "2012"
}   
#New for 3.0.0 + - a File to import sevrer names. updated for 3.1.0 to include OS version in folder path.
$xmlServerImportFile = $($getCurrentScriptLocation.Path + "\Server Import XML\" + $oSVersion + "\es_ha_servers_import.xml")

#################################################################################################
#New for 3.0.0 - Pick up value from XML to determine if we pre-install the binaries for the Base and the HA Extension.
$preInstallSPBinariesForAllExtensions = ($environmentConfig.SelectSingleNode("//preinstallspbinariesforhainbaseprovisioning")).InnerText

#################################################################################################
#New for 3.0.3 - Pick up value from XML to determine if we should create all the cluster elements in script or if we should assume that the cluster/AD/DNS are already pre-created
$createAllClusterElements = ($environmentConfig.SelectSingleNode("//createAllClusterElements")).InnerText

#################################################################################################


. ".\Common\TSPInstallerLogging.ps1"
. ".\Common\TSCommonFunctions.ps1"
. ".\Common\JSONFunctions.ps1"

#################################################################################################
# Configure AMS Logging if setup in config
if (($amsUrl -ne "") -and ($amsSessionID -ne 0))
{
    $amsEnabled = $true
    Configure-AzureMobileServiceConfig $amsUrl $amsAppKey $amsSessionTable $amsSessionDetailTable $amsRegistrationsTable $amsCustomerTable $amsSessionDetailServerTable $amsProxy
    loadAMSSesion $amsSessionID
    #Update-SessionVersion $amsSessionID $currentVersion
}
else
{
    $amsEnabled = $false
}
#################################################################################################


#Reset the error/warning counters. These are not used in this release but may be used in future for finer grained reporting.
$LASTEXITCODE = 0
$errCount = 0
$warningCount = 0

#Configure logging
$currentDate = Get-Date -format "yyyy-MMM-d-HH-mm-ss"
LogStartTracing $("c:\ServiceExecutorESExtensionHA" + $currentDate.ToString() + ".txt") $htmlUpdateFile $htmlAdminPageFile $htmlStatusFile

logStatusMessageToHTML "Configuring the Service Extension" "[HA]" $amsEnabled
writeStatusPageUpdate "1" $amsEnabled

if ($SkipEarlyStepsForDebugging -eq $false)
{
    #STEP 1 - Perform XSLT Transform
    LogStep "Transform XML" 
    try
    {   
        #If it doesnt exist, get the previous version.
        If (!(Test-Path "$xmlCurrentTopologyConfigFile"))
        {
            [xml]$xmlFinalConfigFileTEMP = Get-Content $xmlCurrentTopologyPrevMinorVersionConfigFile -Encoding UTF8                                   
        }
        else
        {
            [xml]$xmlFinalConfigFileTEMP = Get-Content $xmlCurrentTopologyConfigFile -Encoding UTF8   
        }
        
        $xmlFinalConfigFileTEMP.Save($xmlFinalConfigFile)

        If (!(Test-Path "$xmlCurrentTopologyConfigFile"))
        {
            insertNewVersionElementsIntoXML  $xmlFinalConfigFile $numPreviousMinorVersion $numCurrentVersion $isDSIInstall $getCurrentScriptLocation              
            $xmlCurrentTopologyConfigFile = $xmlCurrentTopologyPrevMinorVersionConfigFile
            $xmlCurrentTopologyConfigFileNoPath = $xmlCurrentTopologyPrevMinorVersionConfigFileNoPath                       
        }
        logStatusMessageToHTML "Configuration XML Processed" "[HA]" $amsEnabled
    }
    catch
    {
        LogRuntimeError "Error occurred during loading the Current Topology. Stop Installation" $_
        exit 1;
    }
    #END STEP 1 - Transform


#################################################################################################   
    #STEP 2 - Check if the Farm has already got this extension installed or has reached the limit of installs for this extension.
    LogStep "Check that the Farm should have this extension installed" 
    try
    {          
        $plugData = getPlugXMLIfAlreadyInstalled -plugName $plugName -rawXMLConfigFile $xmlFinalConfigFile
        $plugData = $null
        if ($plugData -ne $null)
        {
            logStatusMessageToHTML "The High Availability Extension has already been applied to the Farm. This Extention can only be applied once." "[HA]" $amsEnabled
            loginfo "[HA] The High Availability Extension has already been applied to the Farm. This Extention can only be applied once."
            throw "The High Availability Extension has already been applied to the Farm. This Extention can only be applied once."
        }
    }
    catch
    {
        LogRuntimeError "Error occurred during checking if the Extension should be applied to the farm. Stop Installation" $_
        exit 1;
    }
    #END STEP 2 - Check if the Farm has already got this extension installed or has reached the limit of installs for this extension.

    
#################################################################################################   
    #STEP 3 - Sizing Calculator (for Extensions we copy from the Base XML rather than recalculate).
    LogStep "Sizing Calculator" 
    try
    {   
        extensionBackupServersFromCurrentTopologyXML $xmlCurrentTopologyConfigFile $xmlFinalConfigFile #Backup the <Servers> Element        
        extensionBackupCurrentSearchTopologyXML $xmlCurrentTopologyConfigFile $xmlFinalConfigFile #Backup the <EnterpriseSearchApplication> Element
        extensionBackupAliasesFromCurrentTopologyXML $xmlCurrentTopologyConfigFile $xmlFinalConfigFile #Backup the <Aliases> Element        
        processSizingESv2Extension $xmlCurrentTopologyConfigFile $xmlFinalConfigFile -hA $true -qpsMultiplier 0

        if ($onlyProcessSizingAndNotInstall -eq "True")
        {
            [xml]$processedFinalXML = Get-Content $xmlFinalConfigFile -Encoding UTF8
            $userCount = $processedFinalXML.Configuration.Install.Sizing.AmountOfUsers
            $indexItemCount = $processedFinalXML.Configuration.Install.Sizing.AmountIndexedItems        
            $newConfigName = $xmlFinalConfigFile.Replace(".xml", $("__SIZINGTEST__UC_SIZING_CALC_NAMES_-" + $userCount + "__IC-" + $indexItemCount + ".xml"))
            $processedFinalXML.Save($newConfigName)
        }

        #New for 3.0.0 - If we are ignoring Sizing Output and using pre-defined server names, make the subsitituons now.
        if ($ignoreSizingOutputNamesAndImportServerNamesAndIPs -eq $true)
        {
            loginfo "We will import Servers from a XML file"
            logStatusMessageToHTML "Import Existing Servers into Configuration XML" "[HA]" $amsEnabled 
            #If the setting is configured, backup the output from the Search Topology and then use the server names from the XML file in the same folder as this script. This needs to be named "base_servers_import.xml"
            backupServersFromSizingCalaculatorOutputXMLExtension -rawCurrentTopologyXMLConfigFile $xmlFinalConfigFile -rawXMLConfigFile $xmlFinalConfigFile $plugName
            importServersAndReplaceSizingCalculatorOutputExtension -importServersXML $xmlServerImportFile -configXML $xmlFinalConfigFile
            updateIPAddressesForImportedServers $xmlFinalConfigFile
            loginfo "Imported"
        }

        updateSQLAliasesWithShareValues $xmlFinalConfigFile -hA $true       
        updateSQLAliasesToReflectNewDBServers_ES_HA $xmlFinalConfigFile -hA $true       
        reworkSearchTopology $xmlCurrentTopologyConfigFile $xmlFinalConfigFile -hA $true
        changeProvisionPropertyOfServiceApps $xmlFinalConfigFile -hA $true        
        
        logStatusMessageToHTML "Sizing XML copied from Base Service XML" "[HA]" $amsEnabled
    }
    catch
    {
        LogRuntimeError "Error occurred during sizing calculator. Stop Installation" $_
        exit 1;
    }
    #END STEP 3 - Sizing Calculator  


#################################################################################################
    #New for 2.7.1 - Add the optional to only run the Sizing Calculator.
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

        #STEP 4 - Provision Deployments
        LogStep "Ensure that the Deployment(s) are available"
    
        #Stage 1 - Provision the deployment(s) and wait for the deployment to be RUNNING.
        try
        {   
            logStatusMessageToHTML "About to provision the new VMs for the Extension" "[HA]" $amsEnabled
            configureLocalHostFileZimoryServer $xmlFinalConfigFile #In DSI we need a host entry to access Zimory API. This will add the host entry if its defined in the XML.
            #Simple test for post CEBIT work - check is version 2.7.X or higher.   
            if ($numCurrentVersion -gt 269)
            {
                #This is the new code which should be used.
                if ($ignoreSizingOutputNamesAndImportServerNamesAndIPs -eq $false)
                {
                    provisionDeploymentsv2 $xmlFinalConfigFile $getCurrentScriptLocation #Use Zimory API to create deployments and update the XML with the new IP addresses of these VMs. This function will not return until the deployment has started - which could be a LONG delay - 1 to 2 hours etc. 
                }
                else
                {
                    #updateIPAddressesForImportedServers $xmlFinalConfigFile
                    if ($isDSIInstall -eq $false)
                    {
                        if ($preInstallSPBinariesForAllExtensions -eq $false)
                        {
                            #Reset the VMs - this is experimental and doesnt work well. Only for Base Service.
                            logStatusMessageToHTML "Test Install - Reset the VMs" "[HA]" $amsEnabled
                            loginfo "Reset the VMs for HA"
                            executeResetExtServiceVMsNGEnvironment $ngVMServer $getCurrentScriptLocation
                        }
                        else
                        {
                            logStatusMessageToHTML "Test Install - Dont reset VMs as already installed to in Base Service" "[HA]" $amsEnabled
                            loginfo "Reset the VMs for HA"
                        }
                    }
                }
            }
            else
            {
                provisionDeployments $xmlFinalConfigFile $getCurrentScriptLocation #Use Zimory API to create deployments and update the XML with the new IP addresses of these VMs. This function will not return until the deployment has started - which could be a LONG delay - 1 to 2 hours etc. 
            }
            configureLocalHostFile $xmlFinalConfigFile #To ensure that we only interact with the correct servers, we will modify the local host file. We need this because we are provisioning multiple VMs with identical Windows Computer names.
            logStatusMessageToHTML "Virtual Machines provisioned" "[HA]" $amsEnabled
        }
        catch
        {
            LogRuntimeError "[HA] Error occurred during ensuring that the Deployments are available and contactable. Stop Installation" $_
            exit 1;
        }
    
        
        try
        {   
            #################################################################################################
            #Stage 2 - now the deployment(s) are running, perform the initial Startup script configuration.
             if ($preInstallSPBinariesForAllExtensions -eq $false)
             {
                    logStatusMessageToHTML "Running Startup Scripts"             "[HA]" $amsEnabled
                    #New for 3.0.1+ - Copy the Hotfixes from the media server so that we dont need them always with the scripts.
                    copySPHotfixesToSPServers -xmlConfigFile $xmlFinalConfigFile -getCurrentScriptLocation $getCurrentScriptLocation
                    copySQLHotfixesToSQLServers -xmlConfigFile $xmlFinalConfigFile -getCurrentScriptLocation $getCurrentScriptLocation

                            
                    if ($isDSIInstall -eq $false)
                    {
                        net use * /delete /y
                        net stop dnscache
                        net start dnscache
                        net use * /delete /y
                        executeUACDisableScriptOnDeploymentsv3_DEVINSTALLONLY $xmlFinalConfigFile $getCurrentScriptLocation #disable UAC. For dev, this will trigger a reboot.
                        executeConfigureLocalDisksScriptOnDeployments  $xmlFinalConfigFile $getCurrentScriptLocation #run script which sets up the local disks (formats them and mounts them. etc)
                        net use * /delete /y
                    }
                    else
                    {
                        #TODO for 3.0.2+ - this doesnt work Access is Denied. Need to use Local Admin which we cannot use for Shell...
                        #executeUACDisableScriptOnDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #disable UAC

                    }
                    executeFireWallDisableScriptOnDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #turn off the firewall. This will trigger a reboot.    
                    executeInstallSPPreInstallHotfixesOnDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #Install the hotfixes which MS desribe need to be present before a SP install - see http://technet.microsoft.com/en-us/library/cc262485.aspx
                    executeInstallSQLPreInstallHotfixesOnDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #Install .NET 4 and PowerShell 3 on the SQL Server. We need this for some of our scripting.
                       
                    #if ($isDSIInstall -eq $false)
                    #{
                        executeEnableRDPScriptOnDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #Enable RDP
                    #}       
                    checkAllServersHaveRebooted $xmlFinalConfigFile #Check the Servers can be pinged

                    #startWinRMServiceAllServers $xmlFinalConfigFile $getCurrentScriptLocation #Start WINRM       
                    if ($ignoreSizingOutputNamesAndImportServerNamesAndIPs -eq $false)
                    {
                        LogInfo "We are not importing servers, so set the Computer Names"
                        executeStatupScriptOnDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #run script which sets the computer names of each deployment. This will trigger a reboot.
                        checkAllServersHaveRebooted $xmlFinalConfigFile                
                        #waitForPSRemotingToBeAvailable $xmlFinalConfigFile #ensure that all the servers are available via PS Remoting.  
                        #New for 2.7.2 - Configure Local Disks
                        executeConfigureLocalDisksScriptOnDeployments $xmlFinalConfigFile $getCurrentScriptLocation #run script which sets up the local disks (formats them and mounts them. etc)
                    }
                    else
                    {
                        LogInfo "We are importing servers, so dont set the Computer Names"   
                    }
                    executeConfigureEnvironmetnVariablesScriptOnDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #run script which sets the environment variables to help keep binaries off of C Drive.
            }  
            else
            {
                loginfo "No need to run all startup scripts as already done in Base Service - just disable firwalls and perform a reboot"
                logStatusMessageToHTML "No need to run all startup scripts as already done in Base Service - just disable firwalls and perform a reboot" "[HA]" $amsEnabled
                updateSPBinariesInstalledOnDeploymentsv3 $xmlFinalConfigFile $xmlFinalConfigFile
                executeFireWallDisableScriptOnDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #turn off the firewall.  
            } 
            
            RestartAll-NonProcessedSPServersBuildAccount $xmlFinalConfigFile
            checkAllServersHaveRebooted $xmlFinalConfigFile #Check the Servers can be pinged

            #updateStartupScriptsRunAttributeOnDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #Now update the flag which says that the StartUp Scripts have executed successfully and we wont re-run.
            
            #################################################################################################
        }
        catch
        {
            LogRuntimeError "[HA] Error occurred during provisioning Deployments via Zimory API. Stop Installation" $_
            exit;
        }
        #END STEP 4 - Provision Deployments 
    }
}
#New for 2.7.1 - Add the optional to only run the Sizing Calculator. I may remove this for future releases.
if ($onlyProcessSizingAndNotInstall -eq "False")
{

    net use * /delete /y
    net stop dnscache
    net start dnscache
    net use * /delete /y

    ########################################################################################################################################################
    #New for v3 - Copy all packages (and XML) to all Servers
    #
    copyCommonPackageToServers $($xmlFinalConfigFile) $getCurrentScriptLocation $spMediaLocation
        
    copyAllScriptPackagesToServers $xmlFinalConfigFile $getCurrentScriptLocation $spMediaLocation

    copyConfigurationXMLToEachServer $xmlFinalConfigFile $getCurrentScriptLocation

   
    ########################################################################################################################################################
    #STEP 5 - Start Script Execution
    #Now that the Deployments are provisioned, start executing the scripts.
    LogStep "Start script execution against the Deployment(s)"    
    try
    {  

        #Set the appropriate Install Flags of the Service Applications.
        changeProvisionPropertyOfServiceApps $xmlFinalConfigFile -hA $true

        #If DII Install = $False then delete the AD Objects for the Cluster Name and the Listener Name. If you are not using NG DEV environmen then evaluate if these are useful to you or not.        
        #TODO for 3.0.3 release - change back to -eq $false
        if ($isDSIInstall -eq $true)
        {   
            #New for 3.0.3. Dont clear down AD, DNS etc if we dont need to as the cluster will be manually created.         
            if ($createAllClusterElements -eq $true)
            {
                executeARPDeleteCommandOnSQLServerDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #NOTE - NG Test env only.
                nonDSIInstallRemoveHAObjects $xmlFinalConfigFile  #NOTE - This still uses PS Remoting. But is for Test Installs Only.
                nonDSIInstallRemoveDNSObjects $xmlFinalConfigFile  #NOTE - This still uses PS Remoting. But is for Test Installs Only.
            }
        }
    

        #################################################################################################                
        #STEP 5.0 - Copy XML config to the sub folder.
        LogStep "Copy XML Config file to the SP Scripts sub folder."
        #Copy-Item $xmlFinalConfigFile -Destination $($getCurrentScriptLocation.Path + "\SP Scripts\") -Force
        #saveFinalXML -xMLConfigFile $xmlFinalConfigFile -configName $xmlFinalConfigFileNoPath -newPath  $($getCurrentScriptLocation.Path + "\Installations\Configuration XML\")   
        saveFinalXML -xMLConfigFile $xmlFinalConfigFile -configName $xmlFinalConfigFileNoPath -newPath  $($getCurrentScriptLocation.Path + "\Configuration Management\Installations Configuration XML\")    
        writeStatusPageUpdate "2" $amsEnabled
        #END STEP 0 - Copy XML Config file.

        if (($ignoreSizingOutputNamesAndImportServerNamesAndIPs -eq $true) -and ($isDSIInstall -eq $false) -AND ($preInstallSPBinariesForAllExtensions -eq $false))
        {
            #################################################################################################                
            #STEP 5.1 - Configure DC Script
            LogStep "Configure Domain Settings"
            LogInfo "Calling .\ConfigureDCAndAccounts.ps1; Configure-Domain"
            $stepLogFilePrefix = "Manager_ConfigureDCAndAcounts"
            $stepLocalLogFilePrefix = "Local_ConfigureDCAndAcounts" 
            [datetime] $startOperationTime =  get-date

            $currentSessionDetailID = logStatusMessageToHTML "Configuring Domain membership" "[HA]" $amsEnabled            
            powershell.exe -noprofile -file "Packages\Domain Configuration\Manager_ConfigureDCAndAccounts.ps1" $xmlFinalConfigFileNoPath "All" #| Out-Null
            LogInfo $((processExitCode $LASTEXITCODE "Configure DC") +  " (Exit Code: " + $LASTEXITCODE + ")")
            $LASTEXITCODE = 0
            if ($amsEnabled)
            {
                try
                {
                    $logFileContents = getLogFileContents $stepLogFilePrefix
                    updateSessionDetailFile $currentSessionDetailID $logFileContents
                    getLogFileContentsFromServerAndUpdateLogging $xmlFinalConfigFileNoPath $currentSessionDetailID $stepLocalLogFilePrefix $startOperationTime
                }
                catch
                {
                    #throw away any Azure logging errors - its a problem but it shouldnt stop a install.
                }
            }      
            #END STEP 1 - Configure DC Script
        }

        if ($preInstallSPBinariesForAllExtensions -eq $false)
        {
            #################################################################################################                
            #STEP 5.2 - Install SP Binaries
            LogStep "Install SP Binaries"
            LogInfo "Calling .\Packages\SP Binaries\Manager_InstallSPBinaries.ps1; All"
            $currentSessionDetailID = logStatusMessageToHTML "Installing SP Binaries" "[HA]" $amsEnabled
            #Update the log file prefix
            $stepLogFilePrefix = "Manager_InstallSPBinaries"  
            $stepLocalLogFilePrefix = "Local_InstallSPBinaries" 
            [datetime] $startOperationTime =  get-date
          
            powershell.exe -noprofile -file "Packages\SP Binaries\Manager_InstallSPBinaries.ps1" $xmlFinalConfigFileNoPath "All" #| Out-Null
            LogInfo $((processExitCode $LASTEXITCODE "Install SP Binaries") +  " (Exit Code: " + $LASTEXITCODE + ")")
            $LASTEXITCODE = 0
            if ($amsEnabled)
            {
                try
                {
                    $logFileContents = getLogFileContents $stepLogFilePrefix
                    updateSessionDetailFile $currentSessionDetailID $logFileContents
                    getLogFileContentsFromServerAndUpdateLogging $xmlFinalConfigFileNoPath $currentSessionDetailID $stepLocalLogFilePrefix $startOperationTime
                }
                catch
                {
                    #throw away any Azure logging errors - its a problem but it shouldnt stop a install.
                }
            }      
            #END STEP 1 - Install SP Binaries            
        }

        #################################################################################################
        #STEP 5.3 - Install SQL
        LogStep "Installing SQL Server 2012"
        LogInfo "Calling .\InstallSQLBinaries.ps1;"
        $currentSessionDetailID = logStatusMessageToHTML "Installing SQL Server" "[HA]" $amsEnabled
        $stepLogFilePrefix = "Manager_InstallSQLBinaries"  
        $stepLocalLogFilePrefix = "Local_InstallSQLBinaries" 
        [datetime] $startOperationTime =  get-date  
        powershell.exe -noprofile -file "Packages\SQL Binaries\Manager_InstallSQLBinaries.ps1" $xmlFinalConfigFileNoPath "False" #| Out-Null
        LogInfo $((processExitCode $LASTEXITCODE "Install SQL") +  " (Exit Code: " + $LASTEXITCODE + ")")
        if ($amsEnabled)
        {
            try
            {
                $logFileContents = getLogFileContents $stepLogFilePrefix
                updateSessionDetailFile $currentSessionDetailID $logFileContents
                getLogFileContentsFromServerAndUpdateLogging $xmlFinalConfigFileNoPath $currentSessionDetailID $stepLocalLogFilePrefix $startOperationTime
            }
            catch
            {
                #throw away any Azure logging errors - its a problem but it shouldnt stop a install.
            }
        }      
        if ($isDSIInstall -eq $true)
        {
            LogInfo "Sleep for 2 minutes to ensure that the SQL Instance is ready"
            Sleep (120)
            LogInfo "Sleep complete"    
        }
        else
        {
            LogInfo "This is a test (non DSI) install. Only sleep for 1 minutes"
            Sleep (60)
            LogInfo "Sleep complete"    
        }            
        $LASTEXITCODE = 0       


        #################################################################################################
        #STEP 5.3a - Create additional data drives if needed.
        LogStep "Configuring 2nd Data Drive Folders"
        LogInfo "Calling ConfigureSQLForES.ps1; CreateDataDriveFoldersOnly"
        $currentSessionDetailID = logStatusMessageToHTML "SQL Create 2nd Drive Folders (1 of 1)" "[HA]" $amsEnabled
        #Update the log file prefix
        $stepLogFilePrefix = "Manager_ConfigureSQLForES"  
        $stepLocalLogFilePrefix = "Local_ConfigureSQLForES" 
        [datetime] $startOperationTime = get-date                 
        powershell.exe -noprofile -file "Packages\Configure SQL\Manager_ConfigureSQLForES.ps1"  $xmlFinalConfigFileNoPath $smallPreSizeDBsForDevInstalls "CreateDataDriveFoldersOnly" #| Out-Null
        LogInfo $((processExitCode $LASTEXITCODE "Create 2nd Disk Folders") +  " (Exit Code: " + $LASTEXITCODE + ")")
        $LASTEXITCODE = 0
        if ($amsEnabled)
        {
            try
            {
                $logFileContents = getLogFileContents $stepLogFilePrefix
                updateSessionDetailFile $currentSessionDetailID $logFileContents
                getLogFileContentsFromServerAndUpdateLogging $xmlFinalConfigFileNoPath $currentSessionDetailID $stepLocalLogFilePrefix $startOperationTime
            }
            catch
            {
                #throw away any Azure logging errors - its a problem but it shouldnt stop a install.
            }
        }                
        #END STEP 5.3a - Configure Farm (Initial Settings)


        #################################################################################################
        #STEP 5.4 - Configure Model DB
        LogStep "Configuring SQL Model DB"
        LogInfo "Calling ConfigureSQLForES.ps1; ModelDBOnly"
        $currentSessionDetailID = logStatusMessageToHTML "Starting SQL Model DB changes  (Stage 1 of 1)" "[HA]" $amsEnabled
        $stepLogFilePrefix = "Manager_ConfigureSQLForES" 
        $stepLocalLogFilePrefix = "Local_ConfigureSQLForES" 
        [datetime] $startOperationTime =  get-date  
        powershell.exe -noprofile -file "Packages\Configure SQL\Manager_ConfigureSQLForES.ps1"  $xmlFinalConfigFileNoPath $smallPreSizeDBsForDevInstalls "ModelDBOnly" #| Out-Null
        LogInfo $((processExitCode $LASTEXITCODE "Starting SQL Model DB changes") +  " (Exit Code: " + $LASTEXITCODE + ")")
        $LASTEXITCODE = 0
        if ($amsEnabled)
        {
            try
            {
                $logFileContents = getLogFileContents $stepLogFilePrefix
                updateSessionDetailFile $currentSessionDetailID $logFileContents
                getLogFileContentsFromServerAndUpdateLogging $xmlFinalConfigFileNoPath $currentSessionDetailID $stepLocalLogFilePrefix $startOperationTime
            }
            catch
            {
                #throw away any Azure logging errors - its a problem but it shouldnt stop a install.
            }
        } 
        #END STEP 3 - Configure Farm (Initial Settings)


        #################################################################################################
        #STEP 5.5 - Upgarde editions of SQL Server to Enterprise.
        LogStep "Installing SQL Server 2012"
        LogInfo "Calling .\InstallSQLBinaries.ps1;"
        $currentSessionDetailID = logStatusMessageToHTML "Upgrade Editions SQL Server" "[HA]" $amsEnabled
        $stepLogFilePrefix = "Manager_InstallSQLBinaries"   
        $stepLocalLogFilePrefix = "Local_InstallSQLBinaries" 
        [datetime] $startOperationTime =  get-date   
        powershell.exe -noprofile -file "Packages\SQL Binaries\Manager_InstallSQLBinaries.ps1" $xmlFinalConfigFileNoPath "True" #| Out-Null
        LogInfo $((processExitCode $LASTEXITCODE "Install SQL") +  " (Exit Code: " + $LASTEXITCODE + ")")
        if ($amsEnabled)
        {
            try
            {
                $logFileContents = getLogFileContents $stepLogFilePrefix
                updateSessionDetailFile $currentSessionDetailID $logFileContents
                getLogFileContentsFromServerAndUpdateLogging $xmlFinalConfigFileNoPath $currentSessionDetailID $stepLocalLogFilePrefix $startOperationTime
            }
            catch
            {
                #throw away any Azure logging errors - its a problem but it shouldnt stop a install.
            }
        } 
        $LASTEXITCODE = 0
        #################################################################################################


        #STEP 5.6 - Configure Always On Availability Groups - Step 1 the Shares, which updates the XML. 
        LogStep "Configuring Always On Availability Groups"
        LogInfo "Calling ConfigureAlwaysOn.ps1; ConfigureAlwaysOn"
        $stepLogFilePrefix = "Manager_ConfigureAlwaysOn" 
        $stepLocalLogFilePrefix = "Local_ConfigureAlwaysOn" 
        [datetime] $startOperationTime =  get-date 
        $currentSessionDetailID = logStatusMessageToHTML "Configuring SQL Always On (Stage 1 of 2)" "[HA]" $amsEnabled
        powershell.exe -noprofile -file "Packages\Ext High Availability\Manager_ConfigureAlwaysOn.ps1" $xmlFinalConfigFileNoPath "SharesOnly"        
        LogInfo $((processExitCode $LASTEXITCODE "SQL Always On") +  " (Exit Code: " + $LASTEXITCODE + ")")
        $LASTEXITCODE = 0
        if ($amsEnabled)
        {
            try
            {
                $logFileContents = getLogFileContents $stepLogFilePrefix
                updateSessionDetailFile $currentSessionDetailID $logFileContents
                getLogFileContentsFromServerAndUpdateLogging $xmlFinalConfigFileNoPath $currentSessionDetailID $stepLocalLogFilePrefix $startOperationTime
            }
            catch
            {
                #throw away any Azure logging errors - its a problem but it shouldnt stop a install.
            }
        } 
        #END STEP 3 - Configure Always On Availability Groups
        #################################################################################################

        #Not needed for 3.1.0 + because we dont update the XML here with share names anymore.
        #copyConfigurationXMLToEachServer $xmlFinalConfigFile $getCurrentScriptLocation


        #New for 3.0.4 - Stop OWS Timer Service on all other servers in the farm.
        LogStep "Stop OWS Timer Service on All SP Servers prior to Always On Config"
        LogInfo "Calling FinaliseFarm.ps1; Finalise-Farm"
        $currentSessionDetailID = logStatusMessageToHTML "Stop OWS Service on all SP Servers" "[HA]" $amsEnabled
        #Update the log file prefix
        $stepLogFilePrefix = "Manager_FinaliseFarm"
        $stepLocalLogFilePrefix = "Local_FinaliseFarm" 
        [datetime] $startOperationTime =  get-date
        powershell.exe -noprofile -file "Packages\Finalise Farm\Manager_FinaliseFarm.ps1"  $xmlFinalConfigFileNoPath "OnlyStopOWSTimerService" #| Out-Null                         
        LogInfo $((processExitCode $LASTEXITCODE "Finalise Farm") +  " (Exit Code: " + $LASTEXITCODE + ")")
        $LASTEXITCODE = 0
        if ($amsEnabled)
        {
            try
            {
                $logFileContents = getLogFileContents $stepLogFilePrefix
                updateSessionDetailFile $currentSessionDetailID $logFileContents
                getLogFileContentsFromServerAndUpdateLogging $xmlFinalConfigFileNoPath $currentSessionDetailID $stepLocalLogFilePrefix $startOperationTime
            }
            catch
            {
                #throw away any Azure logging errors - its a problem but it shouldnt stop a install.
            }
        } 




        #STEP 5.6 - Configure Always On Availability Groups - Step 1 the Shares, which updates the XML. 
        LogStep "Configuring Always On Availability Groups"
        LogInfo "Calling ConfigureAlwaysOn.ps1; ConfigureAlwaysOn"
        $stepLogFilePrefix = "Manager_ConfigureAlwaysOn"  
        $stepLocalLogFilePrefix = "Local_ConfigureAlwaysOn" 
        [datetime] $startOperationTime =  get-date
        logStatusMessageToHTML "Configuring SQL Always On (Stage 2 of 2)" "[HA]" $amsEnabled
        powershell.exe -noprofile -file "Packages\Ext High Availability\Manager_ConfigureAlwaysOn.ps1" $xmlFinalConfigFileNoPath "ClusteringAndAlwaysOnOnly"        
        LogInfo $((processExitCode $LASTEXITCODE "SQL Always On") +  " (Exit Code: " + $LASTEXITCODE + ")")
        $LASTEXITCODE = 0
        if ($amsEnabled)
        {
            try
            {
                $logFileContents = getLogFileContents $stepLogFilePrefix
                updateSessionDetailFile $currentSessionDetailID $logFileContents
                getLogFileContentsFromServerAndUpdateLogging $xmlFinalConfigFileNoPath $currentSessionDetailID $stepLocalLogFilePrefix $startOperationTime
            }
            catch
            {
                #throw away any Azure logging errors - its a problem but it shouldnt stop a install.
            }
        } 
        #END STEP 3 - Configure Always On Availability Groups
        #################################################################################################  
        
        
        
        #New for 3.0.4 - Stop OWS Timer Service on all other servers in the farm.
        LogStep "Start OWS Timer Service on All SP Servers prior to Always On Config"
        LogInfo "Calling FinaliseFarm.ps1; Finalise-Farm"
        $currentSessionDetailID = logStatusMessageToHTML "Start OWS Service on all SP Servers" "[HA]" $amsEnabled
        #Update the log file prefix
        $stepLogFilePrefix = "Manager_FinaliseFarm"
        $stepLocalLogFilePrefix = "Local_FinaliseFarm" 
        [datetime] $startOperationTime =  get-date
        powershell.exe -noprofile -file "Packages\Finalise Farm\Manager_FinaliseFarm.ps1"  $xmlFinalConfigFileNoPath "OnlyStartOWSTimerService" #| Out-Null                         
        LogInfo $((processExitCode $LASTEXITCODE "Finalise Farm") +  " (Exit Code: " + $LASTEXITCODE + ")")
        $LASTEXITCODE = 0
        if ($amsEnabled)
        {
            try
            {
                $logFileContents = getLogFileContents $stepLogFilePrefix
                updateSessionDetailFile $currentSessionDetailID $logFileContents
                getLogFileContentsFromServerAndUpdateLogging $xmlFinalConfigFileNoPath $currentSessionDetailID $stepLocalLogFilePrefix $startOperationTime
            }
            catch
            {
                #throw away any Azure logging errors - its a problem but it shouldnt stop a install.
            }
        } 
        
             
       
        #STEP 5.7 - Configure Farm (Initial Settings)
        LogStep "Configuring SharePoint Farm settings"
        LogInfo "Calling Packages\Create Farm\Manager_CreateFarmAndInititalConfigCombined.ps1; All"
        $currentSessionDetailID = logStatusMessageToHTML "SharePoint Install (Farm Join)" "[HA]" $amsEnabled
        #Update the log file prefix
        $stepLogFilePrefix = "Manager_CreateFarmAndInitialConfig"
        $stepLocalLogFilePrefix = "Local_CreateFarmAndInitialConfig" 
        [datetime] $startOperationTime =  get-date
        powershell.exe -noprofile -file "Packages\Create Farm\Manager_CreateFarmAndInititalConfigCombined.ps1"  $xmlFinalConfigFileNoPath "All" #| Out-Null
        LogInfo $((processExitCode $LASTEXITCODE "Create Farm And Initial Settings") +  " (Exit Code: " + $LASTEXITCODE + ")")
        $LASTEXITCODE = 0
        if ($amsEnabled)
        {
            try
            {
                $logFileContents = getLogFileContents $stepLogFilePrefix
                updateSessionDetailFile $currentSessionDetailID $logFileContents
                getLogFileContentsFromServerAndUpdateLogging $xmlFinalConfigFileNoPath $currentSessionDetailID $stepLocalLogFilePrefix $startOperationTime
            }
            catch
            {
                #throw away any Azure logging errors - its a problem but it shouldnt stop a install.
            }
        } 
                       
    
        #################################################################################################
        #STEP 5.8 - Create Service Applications
        LogStep "Create Service Applications"
        LogInfo "Calling CreateServiceApplication.ps1;"
        $currentSessionDetailID = logStatusMessageToHTML "SharePoint Install (Service Apps)" "[HA]" $amsEnabled
        #Update the log file prefix
        $stepLogFilePrefix = "Manager_CreateServiceApps"
        $stepLocalLogFilePrefix = "Local_CreateServiceApps" 
        [datetime] $startOperationTime =  get-date
        $exportExistingSearchTopologyDrive = "E"
        powershell.exe -noprofile -file "Packages\Service Applications\Manager_CreateServiceApplication.ps1"  $xmlFinalConfigFileNoPath $exportExistingSearchTopologyDrive "All" #| Out-Null                          
        LogInfo $((processExitCode $LASTEXITCODE "Create Service Applications") +  " (Exit Code: " + $LASTEXITCODE + ")")
        $LASTEXITCODE = 0
        if ($amsEnabled)
        {
            try
            {
                $logFileContents = getLogFileContents $stepLogFilePrefix
                updateSessionDetailFile $currentSessionDetailID $logFileContents
                getLogFileContentsFromServerAndUpdateLogging $xmlFinalConfigFileNoPath $currentSessionDetailID $stepLocalLogFilePrefix $startOperationTime
            }
            catch
            {
                #throw away any Azure logging errors - its a problem but it shouldnt stop a install.
            }
        } 
        #END STEP 5 - Configure Service Applications

        #################################################################################################
        #STEP 5.8 - Finalise farm
         LogStep "Finalizing SharePoint Farm Configuration"
        LogInfo "Calling FinaliseFarm.ps1; Finalise-Farm"
        $currentSessionDetailID = logStatusMessageToHTML "SharePoint Install (Finalise Farm)" "[HA]" $amsEnabled
        #Update the log file prefix
        $stepLogFilePrefix = "Manager_FinaliseFarm"
        $stepLocalLogFilePrefix = "Local_FinaliseFarm" 
        [datetime] $startOperationTime =  get-date
        powershell.exe -noprofile -file "Packages\Finalise Farm\Manager_FinaliseFarm.ps1"  $xmlFinalConfigFileNoPath "All" #| Out-Null                         
        LogInfo $((processExitCode $LASTEXITCODE "Finalise Farm") +  " (Exit Code: " + $LASTEXITCODE + ")")
        $LASTEXITCODE = 0
        if ($amsEnabled)
        {
            try
            {
                $logFileContents = getLogFileContents $stepLogFilePrefix
                updateSessionDetailFile $currentSessionDetailID $logFileContents
                getLogFileContentsFromServerAndUpdateLogging $xmlFinalConfigFileNoPath $currentSessionDetailID $stepLocalLogFilePrefix $startOperationTime
            }
            catch
            {
                #throw away any Azure logging errors - its a problem but it shouldnt stop a install.
            }
        } 
        #END STEP 6 - Finalise Farm

        #################################################################################################

        #Update the SQLAliases in the XML for Always On.
        updateSQLAliasesForAlwaysOn $xmlFinalConfigFile
        copyConfigurationXMLToEachServer $xmlFinalConfigFile $getCurrentScriptLocation

        #STEP 5.9 - Update SQL Aliases on each SP Server
        LogStep "Configuring SharePoint local SQL Aliases"
        LogInfo "Calling CreateFarmAndInititalConfigCombined.ps1; CreateSQLAliasesOnly"
        $currentSessionDetailID = logStatusMessageToHTML "SharePoint Install (SQL Aliases)" "[HA]" $amsEnabled
        #Update the log file prefix
        $stepLogFilePrefix = "Manager_CreateFarmAndInitialConfig"
        $stepLocalLogFilePrefix = "Local_CreateFarmAndInitialConfig" 
        [datetime] $startOperationTime =  get-date
        powershell.exe -noprofile -file "Packages\Create Farm\Manager_CreateFarmAndInititalConfigCombined.ps1"  $xmlFinalConfigFileNoPath "CreateSQLAliasesOnly" #| Out-Null
        LogInfo $((processExitCode $LASTEXITCODE "Create Farm And Initial Settings") +  " (Exit Code: " + $LASTEXITCODE + ")")
        $LASTEXITCODE = 0
        if ($amsEnabled)
        {
            try
            {
                $logFileContents = getLogFileContents $stepLogFilePrefix
                updateSessionDetailFile $currentSessionDetailID $logFileContents
                getLogFileContentsFromServerAndUpdateLogging $xmlFinalConfigFileNoPath $currentSessionDetailID $stepLocalLogFilePrefix $startOperationTime
            }
            catch
            {
                #throw away any Azure logging errors - its a problem but it shouldnt stop a install.
            }
        } 
        #END STEP 3 - Configure Farm (Initial Settings)    
        #################################################################################################
        
        LogStep "Check URLs are Accessible Prior to forced Core 2 Failover"
        LogInfo "Checking URLs are accesible prior to Force Failover"
        $currentSessionDetailID = logStatusMessageToHTML "Checking URLs are accesible prior to Force Failover" "[HA]" $amsEnabled
        checkFarmURLsAccessible $xmlFinalConfigFile


        LogStep "Simulating a Core Data Centre Failover for 4 minutes."
        LogInfo "Calling FinaliseFarm.ps1; Finalise-Farm"
        $currentSessionDetailID = logStatusMessageToHTML "SharePoint Install (HA Core 2 Failure Test)" "[HA]" $amsEnabled
        #Update the log file prefix
        $stepLogFilePrefix = "Manager_FinaliseFarm"
        $stepLocalLogFilePrefix = "Local_FinaliseFarm" 
        [datetime] $startOperationTime =  get-date
        powershell.exe -noprofile -file "Packages\Finalise Farm\Manager_FinaliseFarm.ps1"  $xmlFinalConfigFileNoPath "TempTurnOffCore2ServersNetworkCards" #| Out-Null                         
        LogInfo $((processExitCode $LASTEXITCODE "Finalise Farm") +  " (Exit Code: " + $LASTEXITCODE + ")")
        $LASTEXITCODE = 0
        if ($amsEnabled)
        {
            try
            {
                $logFileContents = getLogFileContents $stepLogFilePrefix
                updateSessionDetailFile $currentSessionDetailID $logFileContents
                getLogFileContentsFromServerAndUpdateLogging $xmlFinalConfigFileNoPath $currentSessionDetailID $stepLocalLogFilePrefix $startOperationTime
            }
            catch
            {
                #throw away any Azure logging errors - its a problem but it shouldnt stop a install.
            }
        } 
        sleep 60
        #END STEP 6 - Finalise Farm    
        #################################################################################################
        LogStep "Check URLs are Accessible Post forced Core 2 Failover"
        LogInfo "Checking URLs are accesible post Forced Failover"
        $currentSessionDetailID = logStatusMessageToHTML "Checking URLs are accesible post Forced Failover" "[HA]" $amsEnabled
        
        checkFarmURLsAccessible $xmlFinalConfigFile



        #Update the "FarmServiceExtensions" XML Element.
        addSuccessfullyInstalledExtension -extensionName "High Availability" -plugName $plugName -rawXMLConfigFile $xmlFinalConfigFile

        #New for 2.7.1 + - Save the current topology
        saveCurrentTopologyXML -xMLConfigFile $xmlFinalConfigFile -configName $xmlCurrentTopologyConfigFileNoPath -newPath  $($getCurrentScriptLocation.Path + "\Configuration Management\Installations Configuration XML\") 
        #End new 2.7.1 current topology save.


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
     #Log the file contents to AMS.


       LogRuntimeError "Error occurred during script execution to deployment(s). Stop Installation" $_
       logStatusMessageToHTML "ERROR: Install has failed"    "[HA]" $amsEnabled
       writeStatusPageUpdate "4" $amsEnabled

        if (($currentSessionDetailID -gt 0) -and ($stepLogFilePrefix -ne "") -and ($amsEnabled -eq $true))
        {           
            try
            {
                $logFileContents = getLogFileContents $stepLogFilePrefix
                updateSessionDetailFile $currentSessionDetailID $logFileContents    
                if (  $stepLocalLogFilePrefix -ne "")
                {
                    getLogFileContentsFromServerAndUpdateLogging $xmlFinalConfigFileNoPath $currentSessionDetailID $stepLocalLogFilePrefix $startOperationTime                
                }
            }
            catch
            {
                #throw away any Azure logging errors - its a problem but it shouldnt stop a install.
            }          
        }

       exit 1;
    }
}
#Finish the logging.
logStatusMessageToHTML "Finished" "[HA]" $amsEnabled
LogEndServiceExecutionTracing