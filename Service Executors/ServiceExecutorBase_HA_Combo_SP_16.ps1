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
$currentVersion = "4.0.0"
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
$staticXmlConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\RawStatic_" + $currentVersion + "_SP_JD.xml")
#This is the XML file which will be used by the scripted install. Its content will change over the Steps below (it will be merged and then later transformed to meet the XML schema needed by the scripts).
$xmlMergedConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\SP\MergedTransformed_" + $currentVersion + "_SP_JD.xml")
#This is the XML file which will be used by the scripted install.
$xmlFinalTempConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\SP\FinalStage1Output_" + $currentVersion + "_SP_JD.xml")
#This is the XML file which holds several settings which are specific to the customer/environment (farm number, deployment sever name, media server name, search proxy).
$xmlFinalTempConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\SP\FinalStage1Output_" + $currentVersion + "_SP_JD.xml")
#This is the XML file which holds several settings which are specific to the customer/environment (farm number, deployment sever name, media server name, search proxy).
$xmlCustomerEnvironmentTempConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\SP\MergedCustomerEnvironmentTransformed_" + $currentVersion + "_SP_JD.xml")

#New for 3.1.0 - An extra transform is needed to mix the Customer Service Data with the OnBoarding data.
$xmlCustomerOnboardingTempConfigFile = $($getCurrentScriptLocation.Path + "\Service Executors\XML\SP\MergedCustomerOnBoardingTransformed_" + $currentVersion + "_ES_JD.xml")

#New for 2.7.1+ - a XML file to store the topology.
$xmlCurrentTopologyConfigFileNoPath = "Final_" + $currentVersion + "_SP_JD_CurrentTopology.xml"

#These next 2 entries are the name of the final XML files which are created in steps 1 - 4
$xmlFinalConfigFileNoPath = "Final_" + $currentVersion + "_SP_JD_BaseService.xml"
$xmlFinalConfigFile = $($getCurrentScriptLocation.Path + "\" + $xmlFinalConfigFileNoPath)
$xmlFinalConfigFileNoPath_original = "Final_" + $currentVersion + "_SP_JD_BaseService.xml"
$xmlFinalConfigFile_original = $($getCurrentScriptLocation.Path + "\" + $xmlFinalConfigFileNoPath)

#New for 3.4.0
#These next 2 entries are the name of the final XML files which are created in steps 1 - 4
$xmlFinalConfigFileHANoPath = "Final_" + $currentVersion + "_SP_JD_BaseService_HA.xml"
$xmlFinalConfigFileHA = $($getCurrentScriptLocation.Path + "\" + $xmlFinalConfigFileHANoPath)
$xmlFinalConfigFileHANoPath_original = "Final_" + $currentVersion + "_SP_JD_BaseService_HA.xml"
$xmlFinalConfigFileHA_original = $($getCurrentScriptLocation.Path + "\" + $xmlFinalConfigFileHANoPath)


#New for 3.0.0 These next 2 entries are the name of the final XML files which are used to install SP Binaries to the Base Servers and All extensions.
$xmlFinalConfigFileNoPathWithExtensionsForBinaryInstall = "Final_" + $currentVersion + "_SP_JD_BaseServiceAndAllExtensions_BinariesOnly.xml"
$xmlFinalConfigFileWithExtensionsForBinaryInstall  = $($getCurrentScriptLocation.Path + "\" + $xmlFinalConfigFileNoPathWithExtensionsForBinaryInstall)





$xsltEnvironmentAndZimory = $($getCurrentScriptLocation.Path + "\SP_CustomerAndEnvironment_Zimory_Transform_16.xsl")
if ($isDSIInstall -eq $false){$xsltEnvironmentAndZimory = $($getCurrentScriptLocation.Path + "\SP_CustomerAndEnvironment_Zimory_Transform_NON_TSYS.xsl")}

#New IF statement to support new plugs.
if ($useNewPlugs -eq $true)
{
    $xsltZimoryAndStatic = $($getCurrentScriptLocation.Path + "\Service Executors\XSLT\SAO_SP_Static_Zimory_Transform_newplug.xslt")
}
else
{
    $xsltZimoryAndStatic = $($getCurrentScriptLocation.Path + "\Service Executors\XSLT\SAO_SP_Static_Zimory_Transform.xslt")
}

$xsltStage1 = $($getCurrentScriptLocation.Path + "\Service Executors\XSLT\DSCFarmConfigurationTransformStage1.xsl")
$xsltStage2 = $($getCurrentScriptLocation.Path + "\Service Executors\XSLT\DSCFarmConfigurationTransformStage2.xsl")




$xsltStage1 = $($getCurrentScriptLocation.Path + "\Service Executors\XSLT\SPFarmConfigurationTransformStage1.xsl")
$xsltStage2 = $($getCurrentScriptLocation.Path + "\Service Executors\XSLT\SPFarmConfigurationTransformStage2.xsl")


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
$xmlServerImportFile = $($getCurrentScriptLocation.Path + "\Server Import XML\" + $oSVersion + "\2016\sp_base_servers_import_16.xml")
$xmlHAServerImportFile = $($getCurrentScriptLocation.Path + "\Server Import XML\" + $oSVersion + "\2016\sp_ha_servers_import_16.xml")



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
LogStartTracing $("c:\v3_ServiceExecutorBaseSP" + $currentDate.ToString() + ".txt") $htmlUpdateFile $htmlAdminPageFile $htmlStatusFile

logStatusMessageToHTML "Installing the Base Service" "[SP BASE 16]" $amsEnabled
writeStatusPageUpdate "1" $amsEnabled

if ($SkipEarlyStepsForDebugging -eq $false)
{
#################################################################################################
    #STEP 1 - Process XML (merge Zimory configuration with our static XML structure)
    LogStep "Merge customer specific metadata with our static XML"    
    try
    {   if ($SkipXMLCreation -eq "False")
        {      
            mergeCustomerAndEnvironmentConfiguration $xsltZimoryAndStatic $xsltEnvironmentAndZimory $zimoryConfigurationFile $xmlMergedConfigFile $xmlCustomerEnvironmentTempConfigFile  $xmlCustomerOnboardingTempConfigFile $zimoryOnBoardingConfigurationFile #Merge the XML from Zimory with our raw XML. There are 2 transforms being done in here.
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

        if ($SkipXMLCreation -eq "False")
        {       
            processSizingSPv4_16 $xmlMergedConfigFile $xmlServerImportFile #Calculate the number of servers etc and then write directly back to the XML.
        }

        if ($ignoreSizingOutputNamesAndImportServerNamesAndIPs -eq $true)
        {
            logStatusMessageToHTML "Import Existing Servers into Configuration XML" "[SP BASE 16]" $amsEnabled 
            loginfo "We will import Servers from a XML file"
            #If the setting is configured, backup the output from the Search Topology and then use the server names from the XML file in the same folder as this script. This needs to be named "base_servers_import.xml"
            backupServersFromSizingCalaculatorOutputXML -rawCurrentTopologyXMLConfigFile $xmlMergedConfigFile -rawXMLConfigFile $xmlMergedConfigFile
            importServersAndReplaceSizingCalculatorOutput -importServersXML $xmlServerImportFile -configXML $xmlMergedConfigFile
            loginfo "Imported"
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



            #new for 4.0.0 - SP 16.

           # [xml]$xmlSaveHive = Get-Content $xmlFinalConfigFile -Encoding UTF8 
           # $xmlSaveHive.Configuration.Hive = "16"
           # $xmlSaveHive.Save($xmlFinalConfigFile)


            #New for 3.4.0 + - Do the HA sizing too.
            [xml]$xmlFinalConfigFileHATEMP = Get-Content $xmlFinalConfigFile -Encoding UTF8 
            if (($xmlFinalConfigFileHATEMP.Configuration.Install.IsHAInstall -eq "True")  -or ($xmlFinalConfigFileHATEMP.Configuration.Install.IsHAInstall -eq "TRUE") -or ($xmlFinalConfigFileHATEMP.Configuration.Install.IsHAInstall -eq "true"))
            {
                logStatusMessageToHTML "HA Configuration XML will be Processed" "[SP BASE 16]" $amsEnabled    
                $xmlFinalConfigFileHATEMP.Save($xmlFinalConfigFileHA)
                processSizingSPv3Extension $xmlFinalConfigFile $xmlFinalConfigFileHA -hA $true -qpsMultiplier 0

                #New for 3.4.0 - Make some dynamic setting of Always On values possible.
                updateSQLHAConfigWithDynamicValuesIfNeeded $xmlFinalConfigFileHA -hA $true       
                updateSQLAliasesWithShareValues $xmlFinalConfigFileHA -hA $true       
                updateSQLAliasesToReflectNewDBServers_SP_HA $xmlFinalConfigFileHA -hA $true       
                reworkSearchTopology $xmlFinalConfigFile $xmlFinalConfigFileHA -hA $true
                #changeProvisionPropertyOfServiceApps $xmlFinalConfigFile -hA $true  

                updateSQLAliasesForAlwaysOn_NewALwaysOnElementsOnly $xmlFinalConfigFileHA
                    
                [xml]$xmlFinalConfigFileHATEMP2 = Get-Content $xmlFinalConfigFileHA -Encoding UTF8 
                $xmlFinalConfigFileHATEMP2.Save($xmlFinalConfigFile)
            }

        }
        logStatusMessageToHTML "Base Configuration XML Processed" "[SP BASE 16]" $amsEnabled        
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
                logStatusMessageToHTML "About to provision the VMs" "[SP BASE 16]" $amsEnabled
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
                            logStatusMessageToHTML "Is DII Install, and we have set to Import Server. Servers must be Domain Joined already." "[SP BASE 16]" $amsEnabled                            
                            updateDomainJoinedFlagOnDeploymentsv3 $xmlFinalConfigFile $xmlFinalConfigFile
                        }
                        if ($isDSIInstall -eq $false)
                        {
                            #Reset the VMs - this is experimental and doesnt work well. Only for Base Service.
                            logStatusMessageToHTML "Test Install - Reset the VMs" "[SP BASE 16]" $amsEnabled
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
                            logStatusMessageToHTML "Also Process Extension Binaries." "[SP BASE 16]" $amsEnabled
                            [xml]$baseConfig = Get-Content $xmlFinalConfigFile -Encoding UTF8
                            $baseConfig.Save($xmlFinalConfigFileWithExtensionsForBinaryInstall)
                            processSizingSPv2Extension $xmlFinalConfigFile $xmlFinalConfigFileWithExtensionsForBinaryInstall -hA $true
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
                    logStatusMessageToHTML "Finished Early Due to 'onlyFullyProcessXMLButNoScriptExecution' flag" "[SP BASE 16]" $amsEnabled
                    LogEndServiceExecutionTracing
                    return 0
                }


                configureLocalHostFile $xmlFinalConfigFile #To ensure that we only interact with the correct servers, we will modify the local host file. We need this because we are provisioning multiple VMs with identical Windows Computer names.
                logStatusMessageToHTML "Virtual Machines provisioned" "[SP BASE 16]" $amsEnabled
            }
            catch
            {
                LogRuntimeError "[SP BASE 16] Error occurred during provisioning Deployments via Zimory API. Stop Installation" $_
                exit 1;
            }
            


            #Stage 2 - now the deployment(s) are running, perform the initial Startup script configuration.
            try
            {                 
    #################################################################################################
              #STEP 4.1 - Startup Scripts
                logStatusMessageToHTML "Running Startup Scripts"  "[ES BASE]" $amsEnabled   
                
                net use * /delete /y
                net stop dnscache
                net start dnscache
                net use * /delete /y

                copyStartupScriptsToServer $xmlFinalConfigFile $getCurrentScriptLocation
                copySPHotfixesToSPServers -xmlConfigFile $xmlFinalConfigFile -getCurrentScriptLocation $getCurrentScriptLocation
                copySQLHotfixesToSQLServers -xmlConfigFile $xmlFinalConfigFile -getCurrentScriptLocation $getCurrentScriptLocation

                #New for 3.0.1 - Stop Install at this point if argument says so.
                if ($onlyGetAsFarAsCopyingSPAndSQLHotfixes -eq $true)
                {
                    logStatusMessageToHTML "Finished Early Due to 'onlyGetAsFarAsCopyingSPAndSQLHotfixes' flag" "[ES BASE]" $amsEnabled
                    LogEndServiceExecutionTracing
                    return 0
                }

                executeFireWallDisableScriptOnDeploymentsv4 $xmlFinalConfigFile $getCurrentScriptLocation #turn off the firewall.        
                executeUACDisableScriptOnDeploymentsv3_AUTOREBOOT_v4 $xmlFinalConfigFile $getCurrentScriptLocation #disable UAC. For dev, this will trigger a reboot.
                                   

                net use * /delete /y
                net stop dnscache
                net start dnscache
                net use * /delete /y

                

                #executeFireWallDisableScriptOnDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #turn off the firewall.                           
                executeInstallSPPreInstallHotfixesOnDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #Install the hotfixes which MS desribe need to be present before a SP install - see http://technet.microsoft.com/en-us/library/cc262485.aspx
                executeInstallSQLPreInstallHotfixesOnDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #Install .NET 4 and PowerShell 3 on the SQL Server. We need this for some of our scripting.

                net use * /delete /y                       
                #if ($isDSIInstall -eq $false)
                #{
                    executeEnableRDPScriptOnDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #Enable RDP
                #}       
                checkAllServersHaveRebooted $xmlFinalConfigFile #Check the Servers can be pinged

                #startWinRMServiceAllServers $xmlFinalConfigFile $getCurrentScriptLocation #Start WINRM       
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

                executeConfigureEnvironmetnVariablesScriptOnDeploymentsv4 $xmlFinalConfigFile $getCurrentScriptLocation #run script which sets the environment variables to help keep the hive off of C Drive. DOESNT WORK.
                checkAllServersHaveRebooted $xmlFinalConfigFile #Check the Servers can be pinged
                #updateStartupScriptsRunAttributeOnDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #Now update the flag which says that the StartUp Scripts have executed successfully and we wont re-run.                


                #New for 3.1.8 + - Tidy up the C drive post deployment.
                tidyUpCDriveStartUpScriptOutput $xmlFinalConfigFile $getCurrentScriptLocation #rmeove temp files from c. copy to e                      

                logStatusMessageToHTML "Reboot all Servers"  "[ES BASE]" $amsEnabled   
                LogInfo "Reboot all Servers prior to main install"
                RestartAll-AllSPServersLocalAdminAccount-WaitWMI $xmlFinalConfigFile
                

                

    #################################################################################################
                #STEP 4.1 - END Startup Scripts
            }
            catch
            {
                LogRuntimeError "[SP BASE 16] Error occurred during provisioning Deployments via Zimory API or performing initial configuration (computer name, local disks etc). Stop Installation" $_
                exit;
            }
            #END STEP 4 - Provision Deployments 

            #New for 3.0.1 - Stop Install at this point if argument says so.
            if ($OnlyGetAsFasAsRunningStartupScripts -eq $true)
            {
                logStatusMessageToHTML "Finished Early Due to 'OnlyGetAsFasAsRunningStartupScripts' flag" "[SP BASE 16]" $amsEnabled
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
        
        #New for v3 - Copy all packages (and XML) to all Servers   
        [xml]$configForCopy = Get-Content $xmlFinalConfigFile  -Encoding UTF8 
        $spMediaLocation = $("\\" + $configForCopy.Configuration.Install.MediaServer + "\MediaShare\SP Scripts v3")

        configureLocalHostFile $xmlFinalConfigFile #To ensure that we only interact with the correct servers, we will modify the local host file. We need this because we are provisioning multiple VMs with identical Windows Computer names.
        
        
              
#        copyCommonPackageToServers $($xmlFinalConfigFile) $getCurrentScriptLocation $spMediaLocation
        
 #       copyAllScriptPackagesToServers $xmlFinalConfigFile $getCurrentScriptLocation $spMediaLocation

 #todo

 #copyStartupScriptsToServer_16 $xmlFinalConfigFile $getCurrentScriptLocation
 #executeFireWallDisableScriptOnDeploymentsv4 $xmlFinalConfigFile $getCurrentScriptLocation #turn off the firewall.        
 #               executeUACDisableScriptOnDeploymentsv3_AUTOREBOOT_v4 $xmlFinalConfigFile $getCurrentScriptLocation #disable UAC. For dev, this will trigger a reboot.
               

        copyConfigurationXMLToEachServer_16 $xmlFinalConfigFile $getCurrentScriptLocation          

        
        # [TB] 3.1.5 - copy all media to each server (if required)
        if ($localMediaLocation -ne $null -and $localMediaLocation -ne "")
        {                        
        #"TODO
 #           copyMediaToEachServer $xmlFinalConfigFile
        }

        

        [xml]$xmlFinalConfigFileDOM = Get-Content $xmlFinalConfigFile -Encoding UTF8 

        ########################################################################################################################################################
        #STEP 5 - Start Script Execution
        #Now that the Deployments are provisioned, start executing the scripts.
        LogStep "Start script execution against the Deployment(s)"    
        try
        {    
            #Used for AMS logging. These 2 variables are used to get the latest log file contents and add it to the logging DB.
            $stepLogFilePrefix = ""
            $currentSessionDetailID = 0
            
            #################################################################################################                
            #STEP 5.0 - Copy XML config to the sub folder.
            LogStep "Copy XML Config file to the SP Scripts sub folder."
            #Copy-Item $xmlFinalConfigFile -Destination $($getCurrentScriptLocation.Path + "\SP Scripts\") -Force
            saveFinalXML -xMLConfigFile $xmlFinalConfigFile -configName $xmlFinalConfigFileNoPath -newPath  $($getCurrentScriptLocation.Path + "\Configuration Management\Installations Configuration XML\")    
            writeStatusPageUpdate "2" $amsEnabled
            #END STEP 0 - Copy XML Config file.
          
           
            #################################################################################################
            #STEP 5.4 - Configure Farm (Initial Settings)
            LogStep "Configuring SharePoint Farm settings"
            LogInfo "Calling Packages\Create Farm\Manager_CreateFarmAndInititalConfigCombined.ps1; All"
            $currentSessionDetailID = logStatusMessageToHTML "SharePoint Install (Stage 1 of 4)" "[SP BASE 16]" $amsEnabled
            #Update the log file prefix
            $stepLogFilePrefix = "Manager_CreateFarmAndInitialConfig"
            $stepLocalLogFilePrefix = "Local_CreateFarmAndInitialConfig" 
            [datetime] $startOperationTime =  get-date  
     #       powershell.exe -noprofile -file "Packages\Create Farm\Manager_CreateFarmAndInititalConfigCombined.ps1"  $xmlFinalConfigFileNoPath "All" #| Out-Null
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
             pause   
            #END STEP 3 - Configure Farm (Initial Settings)

            #################################################################################################
            #STEP 5.5 - Create Web Applications - NG TODO - check.
            LogStep "Creating SharePoint Web Applications"
            LogInfo "Calling CreateWebApplications.ps1;"
            $currentSessionDetailID = logStatusMessageToHTML "SharePoint Install (Stage 2 of 4)" "[SP BASE 16]" $amsEnabled
            #Update the log file prefix
            $stepLogFilePrefix = "Manager_CreateWebApplications"
            $stepLocalLogFilePrefix = "Local_CreateWebApplications" 
            [datetime] $startOperationTime =  get-date
     #       powershell.exe -noprofile -file "Packages\Web Applications\Manager_CreateWebApplications.ps1"  $xmlFinalConfigFileNoPath #| Out-Null  
            LogInfo $((processExitCode $LASTEXITCODE "Create Web Applications") +  " (Exit Code: " + $LASTEXITCODE + ")")
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
                
            #END STEP 4 - Create Web Applications
            pause
            #################################################################################################
            #STEP 5.6 - Create Service Applications
            LogStep "Create Service Applications"
            LogInfo "Calling CreateServiceApplication.ps1;"
            $currentSessionDetailID = logStatusMessageToHTML "SharePoint Install (Stage 3 of 4)" "[SP BASE 16]" $amsEnabled
            #Update the log file prefix
            $stepLogFilePrefix = "Manager_CreateServiceApps"
            $stepLocalLogFilePrefix = "Local_CreateServiceApps" 
            [datetime] $startOperationTime =  get-date
            $exportExistingSearchTopologyDrive = "E"
    #        powershell.exe -noprofile -file "Packages\Service Applications\Manager_CreateServiceApplication.ps1"  $xmlFinalConfigFileNoPath $exportExistingSearchTopologyDrive "All" #| Out-Null                          
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
            pause
            #################################################################################################
            #STEP 5.7 - Finalise farm
            LogStep "Finalizing SharePoint Farm Configuration"
            LogInfo "Calling FinaliseFarm.ps1; Finalise-Farm"
            $currentSessionDetailID = logStatusMessageToHTML "SharePoint Install (Stage 4 of 4)" "[SP BASE 16]" $amsEnabled
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
            #STEP 5.8a - Configure all other DBs - Move Certain DBs
            LogStep "Configuring SQL DBs for a SP Install - Move DBs"
            LogInfo "Calling ConfigureSQLForES.ps1; AllOthersNoModelDB"
            $currentSessionDetailID = logStatusMessageToHTML "SQL DB Moves (Stage 1 of 1)" "[SP BASE 16]" $amsEnabled
            #Update the log file prefix
            $stepLogFilePrefix = "Manager_ConfigureSQLForES"
            $stepLocalLogFilePrefix = "Local_ConfigureSQLForES" 
            [datetime] $startOperationTime =  get-date
            powershell.exe -noprofile -file "Packages\Configure SQL\Manager_ConfigureSQLForES.ps1"  $xmlFinalConfigFileNoPath $smallPreSizeDBsForDevInstalls "MoveSomeDBsToOtherDrive" #| Out-Null            
            LogInfo $((processExitCode $LASTEXITCODE "SQL DB changes") +  " (Exit Code: " + $LASTEXITCODE + ")")
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
            #STEP 5.8 - Configure all other DBs
            LogStep "Configuring SQL DBs for a SP Install - Configure Sizes"
            LogInfo "Calling ConfigureSQLForES.ps1; AllOthersNoModelDB"
            $currentSessionDetailID = logStatusMessageToHTML "SQL DB Modifications (Stage 1 of 1)" "[SP BASE 16]" $amsEnabled
            #Update the log file prefix
            $stepLogFilePrefix = "Manager_ConfigureSQLForES"
            $stepLocalLogFilePrefix = "Local_ConfigureSQLForES" 
            [datetime] $startOperationTime =  get-date
            powershell.exe -noprofile -file "Packages\Configure SQL\Manager_ConfigureSQLForES.ps1"  $xmlFinalConfigFileNoPath $smallPreSizeDBsForDevInstalls "AllOthersNoModelDB" #| Out-Null            
            LogInfo $((processExitCode $LASTEXITCODE "SQL DB changes") +  " (Exit Code: " + $LASTEXITCODE + ")")
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
            #STEP 5.9 - Configure all other DBs
            LogStep "Configuring SQL DBs for a SP Install - Maintainance Plans"
            LogInfo "Calling ConfigureSQLForES.ps1; SQLIntegrationServices"
            $currentSessionDetailID = logStatusMessageToHTML "SQL DB Modifications (MPs)" "[SP BASE 16]" $amsEnabled
            #Update the log file prefix
            $stepLogFilePrefix = "Manager_ConfigureSQLForES"
            $stepLocalLogFilePrefix = "Local_ConfigureSQLForES" 
            [datetime] $startOperationTime =  get-date
            powershell.exe -noprofile -file "Packages\Configure SQL\Manager_ConfigureSQLForES.ps1"  $xmlFinalConfigFileNoPath $smallPreSizeDBsForDevInstalls "SQLIntegrationServices" #| Out-Null            
            LogInfo $((processExitCode $LASTEXITCODE "SQL DB changes") +  " (Exit Code: " + $LASTEXITCODE + ")")
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
            #STEP 5.9 - Configure all other DBs
            LogStep "Configuring SQL DBs for a SP Install - Maintainance Plans Agent Start"
            LogInfo "Calling ConfigureSQLForES.ps1; SQLIntegrationServices"
            $currentSessionDetailID = logStatusMessageToHTML "SQL DB Modifications (MPs Agent Start)" "[SP BASE 16]" $amsEnabled
            #Update the log file prefix
            $stepLogFilePrefix = "Manager_ConfigureSQLForES"
            $stepLocalLogFilePrefix = "Local_ConfigureSQLForES" 
            [datetime] $startOperationTime =  get-date
            powershell.exe -noprofile -file "Packages\Configure SQL\Manager_ConfigureSQLForES.ps1"  $xmlFinalConfigFileNoPath $smallPreSizeDBsForDevInstalls "SQLIntegrationServicesServiceStart" #| Out-Null            
            LogInfo $((processExitCode $LASTEXITCODE "SQL DB changes") +  " (Exit Code: " + $LASTEXITCODE + ")")
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


if (($xmlFinalConfigFileDOM.Configuration.Install.IsHAInstall -eq "True")  -or ($xmlFinalConfigFileDOM.Configuration.Install.IsHAInstall -eq "TRUE") -or ($xmlFinalConfigFileDOM.Configuration.Install.IsHAInstall -eq "true"))
{

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


            #STEP 5.9 - Update SQL Aliases on each SP Server
            LogStep "Configuring SharePoint local SQL Aliases for HA"
            LogInfo "Calling CreateFarmAndInititalConfigCombined.ps1; CreateSQLAliasesOnly"
            $currentSessionDetailID = logStatusMessageToHTML "SharePoint Install (SQL Aliases)" "[HA]" $amsEnabled
            #Update the log file prefix
            $stepLogFilePrefix = "Manager_CreateFarmAndInitialConfig"
            $stepLocalLogFilePrefix = "Local_CreateFarmAndInitialConfig" 
            [datetime] $startOperationTime =  get-date
            powershell.exe -noprofile -file "Packages\Create Farm\Manager_CreateFarmAndInititalConfigCombined.ps1"  $xmlFinalConfigFileNoPath "CreateSQLAliasesOnlyHA" #| Out-Null
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

}

            #################################################################################################
            #STEP 5.9 - Finalise farm
            LogStep "Finalizing install"
            LogInfo "Calling FinaliseFarm.ps1; Finalise-Farm RestartAllSPServers"
            $currentSessionDetailID = logStatusMessageToHTML "Rebooting all Servers" "[SP BASE 16]" $amsEnabled
            #Update the log file prefix
            $stepLogFilePrefix = "Manager_FinaliseFarm"            
            $stepLocalLogFilePrefix = "Local_FinaliseFarm"
            [datetime] $startOperationTime =  get-date
            powershell.exe -noprofile -file "Packages\Finalise Farm\Manager_FinaliseFarm.ps1"  $xmlFinalConfigFileNoPath "RestartAllSPServers" #| Out-Null             
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
            LogRuntimeError "Error occurred during script execution to deployment(s). Stop Installation" $_
            logStatusMessageToHTML "ERROR: Install has failed" "[SP BASE 16]" $amsEnabled
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
logStatusMessageToHTML "Finished" "[SP BASE 16]" $amsEnabled
LogEndServiceExecutionTracing

