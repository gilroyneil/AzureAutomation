param 
(    
    [string]$zimoryConfigurationFile,
    [string]$SkipEarlyStepsForDebugging,
    [string]$isDSIInstall,
    [string]$onlyProcessSizingAndNotInstall,
    [string]$plugName,
    [int]$amsSessionID 
)

$useNewPlugs = $false
$currentVersion = "3.2.4"
$previousVersion = "3.0.5"
#Note - new for 3.0.3. This allows us to add a extension on top of a older version of the scripts. I would like to extend this and make it a version range. TODO - improve in 3.0.3 or 3.0.4.
$previousVersionToUpgradeFrom = "3.0.5"
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
$xmlFinalConfigFileNoPath = "Final_" + $currentVersion + "_ES_JD_Extension_LP.xml"
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
LogStartTracing $("c:\ServiceExecutorESExtensionLP" + $currentDate.ToString() + ".txt") $htmlUpdateFile $htmlAdminPageFile $htmlStatusFile

logStatusMessageToHTML "Configuring the Service Extension" "[LP]" $amsEnabled
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
        logStatusMessageToHTML "Configuration XML Processed" "[LP]" $amsEnabled
    }
    catch
    {
        LogRuntimeError "Error occurred during loading the Current Topology. Stop Installation" $_
        exit 1;
    }
    #END STEP 1 - Transform


    
#################################################################################################   
    #STEP 2 - Sizing Calculator (for Extensions we copy from the Base XML stored in CurrentTopology.xml rather than recalculate).
    LogStep "Sizing Calculator" 
    try
    {   

        extensionBackupProductVersionsFromCurrentTopologyXML $xmlCurrentTopologyConfigFile $xmlFinalConfigFile #Backup the <ProductVersions> Element               

        $langPacksFromConfigurationXML = getLanguagePackPlugsFromConfiguration $zimoryConfigurationFile $plugName

        processXMLForLangPacksExtension $xmlCurrentTopologyConfigFile $xmlFinalConfigFile $langPacksFromConfigurationXML

        if ($onlyProcessSizingAndNotInstall -eq "True")
        {
            [xml]$processedFinalXML = Get-Content $xmlFinalConfigFile -Encoding UTF8
            $newConfigName = $xmlFinalConfigFile.Replace(".xml", $("__LPExt__NewXML.xml"))
            $processedFinalXML.Save($newConfigName)
        }

        logStatusMessageToHTML "XML copied from Base Service XML and updated for new Language Packs" "[LP]" $amsEnabled
    }
    catch
    {
        LogRuntimeError "Error occurred during sizing. Stop Installation" $_
        exit 1;
    }
    #END STEP 3 - Sizing Calculator  


#################################################################################################
    #New for 2.7.1 - Add the optional to only run the Sizing Calculator.
    if ($onlyProcessSizingAndNotInstall -eq "True")
    {
        [xml]$processedFinalXML = Get-Content $xmlFinalConfigFile -Encoding UTF8
        $newConfigName = $xmlFinalConfigFile.Replace(".xml", $("__LPExt__NewXML.xml"))
        $processedFinalXML.Save($newConfigName)
    }
    else
    {

    
        #################################################################################################
        executeFireWallDisableScriptOnDeploymentsv3 $xmlFinalConfigFile $getCurrentScriptLocation #turn off the firewall.  
        checkAllServersHaveRebooted $xmlFinalConfigFile #Check the Servers can be pinged
        #################################################################################################
       
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

        #################################################################################################                
        #STEP 5.0 - Copy XML config to the sub folder.
        LogStep "Copy XML Config file to the SP Scripts sub folder."
        #Copy-Item $xmlFinalConfigFile -Destination $($getCurrentScriptLocation.Path + "\SP Scripts\") -Force
        #saveFinalXML -xMLConfigFile $xmlFinalConfigFile -configName $xmlFinalConfigFileNoPath -newPath  $($getCurrentScriptLocation.Path + "\Installations\Configuration XML\")   
        saveFinalXML -xMLConfigFile $xmlFinalConfigFile -configName $xmlFinalConfigFileNoPath -newPath  $($getCurrentScriptLocation.Path + "\Configuration Management\Installations Configuration XML\")    
        writeStatusPageUpdate "2" $amsEnabled
        #END STEP 0 - Copy XML Config file.

        

        if ($preInstallSPBinariesForAllExtensions -eq $false)
        {
            #################################################################################################                
            #STEP 5.2 - Install SP Binaries
            LogStep "Install SP Binaries - Lang Packs Only"
            LogInfo "Calling .\Packages\SP Binaries\Manager_InstallSPBinaries.ps1; LangPacksOnly"
            $currentSessionDetailID = logStatusMessageToHTML "Installing SP Binaries" "[LP]" $amsEnabled
            #Update the log file prefix
            $stepLogFilePrefix = "Manager_InstallSPBinaries"  
            $stepLocalLogFilePrefix = "Local_InstallSPBinaries" 
            [datetime] $startOperationTime =  get-date
          
    #        powershell.exe -noprofile -file "Packages\SP Binaries\Manager_InstallSPBinaries.ps1" $xmlFinalConfigFileNoPath "LangPacksOnly" #| Out-Null
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

       
        #STEP 5.7 - Configure Farm (Initial Settings)
        LogStep "Running PS Config"
        LogInfo "Calling Packages\Create Farm\Manager_CreateFarmAndInititalConfigCombined.ps1; ConfigureLanguagePacks"
        $currentSessionDetailID = logStatusMessageToHTML "SharePoint Install (Farm Join)" "[LP]" $amsEnabled
        #Update the log file prefix
        $stepLogFilePrefix = "Manager_CreateFarmAndInitialConfig"
        $stepLocalLogFilePrefix = "Local_CreateFarmAndInitialConfig" 
        [datetime] $startOperationTime =  get-date
  #      powershell.exe -noprofile -file "Packages\Create Farm\Manager_CreateFarmAndInititalConfigCombined.ps1"  $xmlFinalConfigFileNoPath "ConfigureLanguagePacks" #| Out-Null
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
                       
    

        #Update the "FarmServiceExtensions" XML Element.
        addSuccessfullyInstalledExtension -extensionName "Language Pack" -plugName $plugName -rawXMLConfigFile $xmlFinalConfigFile

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
       logStatusMessageToHTML "ERROR: Install has failed"    "[LP]" $amsEnabled
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
logStatusMessageToHTML "Finished" "[LP]" $amsEnabled
LogEndServiceExecutionTracing