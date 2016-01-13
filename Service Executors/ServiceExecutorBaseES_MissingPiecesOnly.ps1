param 
(
    [string]$zimoryConfigurationFile,
    [string]$zimoryOnBoardingConfigurationFile,
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
$currentVersion = "3.2.4"
[int]$numCurrentVersion = $currentVersion.Replace(".", "")

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
$xmlMergedConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\ES\MergedTransformed_" + $currentVersion + "_ES_JD.xml")
#This is the XML file which will be used by the scripted install.
$xmlFinalTempConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\ES\FinalStage1Output_" + $currentVersion + "_ES_JD.xml")
#This is the XML file which holds several settings which are specific to the customer/environment (farm number, deployment sever name, media server name, search proxy).
$xmlFinalTempConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\ES\FinalStage1Output_" + $currentVersion + "_ES_JD.xml")
#This is the XML file which holds several settings which are specific to the customer/environment (farm number, deployment sever name, media server name, search proxy).
$xmlCustomerEnvironmentTempConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\ES\MergedCustomerEnvironmentTransformed_" + $currentVersion + "_ES_JD.xml")

#New for 3.1.0 - An extra transform is needed to mix the Customer Service Data with the OnBoarding data.
$xmlCustomerOnboardingTempConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\ES\MergedCustomerOnBoardingTransformed_" + $currentVersion + "_ES_JD.xml")

#New for 2.7.1+ - a XML file to store the topology.
$xmlCurrentTopologyConfigFileNoPath = "Final_" + $currentVersion + "_ES_JD_CurrentTopology.xml"

#These next 2 entries are the name of the final XML files which are created in steps 1 - 4
$xmlFinalConfigFileNoPath = "Final_" + $currentVersion + "_ES_JD_BaseService.xml"
$xmlFinalConfigFile = $($getCurrentScriptLocation.Path + "\" + $xmlFinalConfigFileNoPath)
$xmlFinalConfigFileNoPath_original = "Final_" + $currentVersion + "_ES_JD_BaseService.xml"
$xmlFinalConfigFile_original = $($getCurrentScriptLocation.Path + "\" + $xmlFinalConfigFileNoPath)



#New for 3.0.0 These next 2 entries are the name of the final XML files which are used to install SP Binaries to the Base Servers and All extensions.
$xmlFinalConfigFileNoPathWithExtensionsForBinaryInstall = "Final_" + $currentVersion + "_ES_JD_BaseServiceAndAllExtensions_BinariesOnly.xml"
$xmlFinalConfigFileWithExtensionsForBinaryInstall  = $($getCurrentScriptLocation.Path + "\" + $xmlFinalConfigFileNoPathWithExtensionsForBinaryInstall)





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
#Use the local admin credentials of the media server.

# [TB] 3.1.5 - support copying all media locally
$localMediaLocation = ($environmentConfig.SelectSingleNode("//localmediapath")).InnerText


#################################################################################################
#New for 2.8.1+ - AMS integration
$amsUrl = ($environmentConfig.SelectSingleNode("//jsonurl")).InnerText
$amsProxy = ($environmentConfig.SelectSingleNode("//proxy")).InnerText
$amsAppKey = ($environmentConfig.SelectSingleNode("//applicationkey")).InnerText
$amsSessionTable = ($environmentConfig.SelectSingleNode("//sessiontable")).InnerText
$amsSessionDetailTable = ($environmentConfig.SelectSingleNode("//sessiondetailtable")).InnerText
$amsSessionDetailServerTable = ($environmentConfig.SelectSingleNode("//sessiondetailservertable")).InnerText
$amsRegistrationsTable = ($environmentConfig.SelectSingleNode("//registrationstable")).InnerText
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

#################################################################################################    
#New for 3.0.0 - Pick up value from XML to determine if we pre-install the binaries for the Base and the HA Extension.
$preInstallSPBinariesForAllExtensions = ($environmentConfig.SelectSingleNode("//preinstallspbinariesforhainbaseprovisioning")).InnerText


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

#################################################################################################
# Configure AMS Logging if setup in config


#################################################################################################


#Reset the error/warning counters. These are not used in this release but may be used in future for finer grained reporting.
$LASTEXITCODE = 0
$errCount = 0
$warningCount = 0

#Configure logging
$currentDate = Get-Date -format "yyyy-MMM-d-HH-mm-ss"
LogStartTracing $("c:\v3_ServiceExecutorBaseES" + $currentDate.ToString() + ".txt") $htmlUpdateFile $htmlAdminPageFile $htmlStatusFile



if ($SkipEarlyStepsForDebugging -eq $false)
{
#################################################################################################
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
    
#################################################################################################
    #STEP 2 - Sizing Calculator
    LogStep "Sizing Calculator" 
    try
    {
        #Simple test for post CEBIT work - check is version 2.7.X or higher.   
        if ($numCurrentVersion -gt 269)
        { 
           if ($SkipXMLCreation -eq "False")
            {     
                processSizingESv2 $xmlMergedConfigFile #Calculate the number of servers etc and then write directly back to the XML.
            }

            if ($ignoreSizingOutputNamesAndImportServerNamesAndIPs -eq $true)
            {
                logStatusMessageToHTML "Import Existing Servers into Configuration XML" "[ES BASE]" $amsEnabled 
                loginfo "We will import Servers from a XML file"
                #If the setting is configured, backup the output from the Search Topology and then use the server names from the XML file in the same folder as this script. This needs to be named "base_servers_import.xml"
                backupServersFromSizingCalaculatorOutputXML -rawCurrentTopologyXMLConfigFile $xmlMergedConfigFile -rawXMLConfigFile $xmlMergedConfigFile
                importServersAndReplaceSizingCalculatorOutput -importServersXML $xmlServerImportFile -configXML $xmlMergedConfigFile
                loginfo "Imported"
            }
        }
        else
        {
            #Deprecate soon, once is clear we dont need to provide any CEBIT support. 
            processSizingES $xmlMergedConfigFile #Calculate the number of servers etc and then write directly back to the XML.
        }
    }
    catch
    {
        LogRuntimeError "Error occurred during sizing calculator. Stop Installation" $_
        exit 1;
    }
    #END STEP 2 - Sizing Calculator  

#################################################################################################
    #STEP 3 - Perform XSLT Transform
    LogStep "Transform XML" 
    try
    {   
        if ($SkipXMLCreation -eq "False")
        {     
            transformXMLToFinalSchema $xsltStage1 $xsltStage2 $xmlMergedConfigFile $xmlFinalTempConfigFile $xmlFinalConfigFile #perform XSLT transform (which contains logic) to the final XML schema.
        }
        logStatusMessageToHTML "Base Configuration XML Processed" "[ES BASE]" $amsEnabled        
    }
    catch
    {
        LogRuntimeError "Error occurred during XSLT Transform. Stop Installation" $_
        exit 1;
    }
    #END STEP 3 - XSLT Transform

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
        #################################################################################################
            #STEP 4 - Provision Deployments
            LogStep "Provision Deployment(s)"   
            #Stage 1 - Provision the deployment(s) and wait for the deployment to be RUNNING.
            try
            {   
                logStatusMessageToHTML "About to provision the VMs" "[ES BASE]" $amsEnabled
                configureLocalHostFileZimoryServer $xmlFinalConfigFile #In DSI we need a host entry to access Zimory API. This will add the host entry if its defined in the XML.
                #Simple test for post CEBIT work - check is version 2.7.X or higher.   
                if ($numCurrentVersion -gt 269)
                {
                    #This is the new code which should be used.
                    if ($ignoreSizingOutputNamesAndImportServerNamesAndIPs -eq $false)
                    {
                        if ($SkipXMLCreation -eq "False")
                        {
                            provisionDeploymentsv2 $xmlFinalConfigFile $getCurrentScriptLocation #Use Zimory API to create deployments and update the XML with the new IP addresses of these VMs. This function will not return until the deployment has started - which could be a LONG delay - 1 to 2 hours etc. 
                        }
                    }
                    else
                    {
                        #Base Service, update IP Addresses
                        updateIPAddressesForImportedServers $xmlFinalConfigFile
                        if ($isDSIInstall -eq $true)
                        {
                            loginfo  "Is DII Install, and we have set to Import Server. Servers must be Domain Joined already."
                            logStatusMessageToHTML "Is DII Install, and we have set to Import Server. Servers must be Domain Joined already." "[ES BASE]" $amsEnabled                            
                            updateDomainJoinedFlagOnDeploymentsv3 $xmlFinalConfigFile $xmlFinalConfigFile
                        }
                        if ($isDSIInstall -eq $false)
                        {
                            #Reset the VMs - this is experimental and doesnt work well. Only for Base Service.
                            logStatusMessageToHTML "Test Install - Reset the VMs" "[ES BASE]" $amsEnabled
                            if ($preInstallSPBinariesForAllExtensions -eq $false)
                            {
                                executeResetBaseServiceVMsNGEnvironment $ngVMServer $getCurrentScriptLocation
                            }
                        }

                        #New functionality - run through the Service Extensions Sizing
                        if ($preInstallSPBinariesForAllExtensions -eq $true)
                        {
                            if ($isDSIInstall -eq $false)
                            {
                                executeResetBaseServiceAndExtensionsVMsNGEnvironment $ngVMServer $getCurrentScriptLocation
                            }
                            logStatusMessageToHTML "Also Process Extension Binaries." "[ES BASE]" $amsEnabled
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
                    logStatusMessageToHTML "Finished Early Due to 'onlyFullyProcessXMLButNoScriptExecution' flag" "[ES BASE]" $amsEnabled
                    LogEndServiceExecutionTracing
                    return 0
                }


                configureLocalHostFile $xmlFinalConfigFile #To ensure that we only interact with the correct servers, we will modify the local host file. We need this because we are provisioning multiple VMs with identical Windows Computer names.
                logStatusMessageToHTML "Virtual Machines provisioned" "[ES BASE]" $amsEnabled
            }
            catch
            {
                LogRuntimeError "[ES BASE] Error occurred during provisioning Deployments via Zimory API. Stop Installation" $_
                exit 1;
            }
            


            #Stage 2 - now the deployment(s) are running, perform the initial Startup script configuration.
            try
            {                 
    #################################################################################################
                #STEP 4.1 - Startup Scripts
                logStatusMessageToHTML "Running Startup Scripts"  "[ES BASE]" $amsEnabled   
                
                
               

    #################################################################################################
                #STEP 4.1 - END Startup Scripts
            }
            catch
            {
                LogRuntimeError "[ES BASE] Error occurred during provisioning Deployments via Zimory API or performing initial configuration (computer name, local disks etc). Stop Installation" $_
                exit;
            }
            #END STEP 4 - Provision Deployments 

            #New for 3.0.1 - Stop Install at this point if argument says so.
            if ($OnlyGetAsFasAsRunningStartupScripts -eq $true)
            {
                logStatusMessageToHTML "Finished Early Due to 'OnlyGetAsFasAsRunningStartupScripts' flag" "[ES BASE]" $amsEnabled
                LogEndServiceExecutionTracing
                return 0
            }


        }
    }

    
    #New for 2.7.1 - Add the optional to only run the Sizing Calculator. I may remove this for future releases.
    if ($onlyProcessSizingAndNotInstall -eq "False")
    {    
        net use * /delete /y
        net stop dnscache
        net start dnscache
        net use * /delete /y




        if ($preInstallSPBinariesForAllExtensions -eq $true)
        {
            $xmlFinalConfigFile = $xmlFinalConfigFileWithExtensionsForBinaryInstall
            $xmlFinalConfigFileNoPath = $xmlFinalConfigFileNoPathWithExtensionsForBinaryInstall
            
        }

        ########################################################################################################################################################
        #New for v3 - Copy all packages (and XML) to all Servers                
        copyCommonPackageToServers $($xmlFinalConfigFile) $getCurrentScriptLocation $spMediaLocation
        
        copyAllScriptPackagesToServers $xmlFinalConfigFile $getCurrentScriptLocation $spMediaLocation

#        copyConfigurationXMLToEachServer $xmlFinalConfigFile $getCurrentScriptLocation          
   
   
        # [TB] 3.1.5 - copy all media to each server (if required)
        if ($localMediaLocation -ne $null -and $localMediaLocation -ne "")
        {
            copyMediaToEachServer $xmlFinalConfigFile
        }

        ########################################################################################################################################################
        #STEP 5 - Start Script Execution
        #Now that the Deployments are provisioned, start executing the scripts.
        LogStep "Start script execution against the Deployment(s)"    
        try
        {    
            #Used for AMS logging. These 2 variables are used to get the latest log file contents and add it to the logging DB.
            $stepLogFilePrefix = ""
            $currentSessionDetailID = 0
            
           
            if ($ignoreSizingOutputNamesAndImportServerNamesAndIPs -eq $false)
            {
                #################################################################################################                
                #STEP 5.1 - Configure DC Script
                LogStep "Configure Domain Settings"
                LogInfo "Calling .\Packages\Domain Configuration\Manager_ConfigureDCAndAccounts.ps1; All"
                
                #Update the log file prefix
                $stepLogFilePrefix = "Manager_ConfigureDCAndAcounts"
                $stepLocalLogFilePrefix = "Local_ConfigureDCAndAcounts" 
                [datetime] $startOperationTime =  get-date        
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

            #################################################################################################                
            #STEP 5.2 - Install SP Binaries
            LogStep "Install SP Binaries"
            LogInfo "Calling .\Packages\SP Binaries\Manager_InstallSPBinaries.ps1; All"
           
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
            #END STEP 5.2 - Install SP Binaries


                

            #################################################################################################
            #STEP 5.2 - Install SQL
            LogStep "Installing SQL Server 2012"
            LogInfo "Calling Packages\SQL Binaries\Manager_InstallSQLBinaries.ps1"
            
            #Update the log file prefix
            $stepLogFilePrefix = "Manager_InstallSQLBinaries"
            $stepLocalLogFilePrefix = "Local_InstallSQLBinaries" 
            [datetime] $startOperationTime = get-date       
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
                
           

        }
        catch
        {
            LogRuntimeError "Error occurred during script execution to deployment(s). Stop Installation" $_
            
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

LogEndServiceExecutionTracing

