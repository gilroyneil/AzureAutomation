param 
(
    [string]$zimoryConfigurationFile,
    [string]$SkipEarlyStepsForDebugging,
    [string]$isDSIInstall,
    [string]$onlyProcessSizingAndNotInstall,
    [string]$plugName,
    [int]$amsSessionID 
)

$haPLugName = "SAO-ES-HA"
$useNewPlugs = $false
$currentVersion = "2.8.1"
[int]$numCurrentVersion = $currentVersion.Replace(".", "")

#Execute 2 commands which will ensure scripts run smoothly.
Set-ExecutionPolicy Bypass -Force
Get-PSSession | Remove-PSSession

#################################################################################################
# Configure all the file locations.
#Get current script location.
$getCurrentScriptLocation = Get-Location
#This is the static XML file which contains static configuration but no customer specific values. Its not in the final schema - its a very flat XML strucutre.
$staticXmlConfigFile = $($getCurrentScriptLocation.Path + "\SP Scripts\XML\RawStatic_" + $currentVersion + "_ES_JD.xml")
#This is the XML file which will be used by the scripted install. Its content will change over the Steps below (it will be merged and then later transformed to meet the XML schema needed by the scripts).
$xmlMergedConfigFile = $($getCurrentScriptLocation.Path + "\SP Scripts\XML\ES\MergedTransformed_" + $currentVersion + "_ES_JD.xml")
#This is the XML file which will be used by the scripted install.
$xmlFinalTempConfigFile = $($getCurrentScriptLocation.Path + "\SP Scripts\XML\ES\FinalStage1Output_" + $currentVersion + "_ES_JD.xml")
#This is the XML file which holds several settings which are specific to the customer/environment (farm number, deployment sever name, media server name, search proxy).
$xmlFinalTempConfigFile = $($getCurrentScriptLocation.Path + "\SP Scripts\XML\ES\FinalStage1Output_" + $currentVersion + "_ES_JD.xml")
#This is the XML file which holds several settings which are specific to the customer/environment (farm number, deployment sever name, media server name, search proxy).
$xmlCustomerEnvironmentTempConfigFile = $($getCurrentScriptLocation.Path + "\SP Scripts\XML\ES\MergedCustomerEnvironmentTransformed_" + $currentVersion + "_ES_JD.xml")

#New for 2.7.1+ - a XML file to store the topology.
$xmlCurrentTopologyConfigFileNoPath = "Final_" + $currentVersion + "_ES_JD_CurrentTopology.xml"
$xmlCurrentTopologyConfigFile = $($getCurrentScriptLocation.Path + "\Installations\Configuration XML\" + $xmlCurrentTopologyConfigFileNoPath)



#These next 2 entries are the name of the final XML files which are created in steps 1 - 4
$xmlFinalConfigFileNoPath = "Final_" + $currentVersion + "_ES_JD_Extension_EQPS.xml"
$xmlFinalConfigFile = $($getCurrentScriptLocation.Path + "\" + $xmlFinalConfigFileNoPath)

$xsltEnvironmentAndZimory = $($getCurrentScriptLocation.Path + "\SAO_ES_CustomerAndEnvironment_Zimory_Transform.xsl")
if ($isDSIInstall -eq $false){$xsltEnvironmentAndZimory = $($getCurrentScriptLocation.Path + "\SAO_ES_CustomerAndEnvironment_Zimory_Transform_TEST.xsl")}

#New IF statement to support new plugs.
if ($useNewPlugs -eq $true)
{
    $xsltZimoryAndStatic = $($getCurrentScriptLocation.Path + "\SP Scripts\XSLT\SAO_ES_Static_Zimory_Transform_newplug.xslt")
}
else
{
    $xsltZimoryAndStatic = $($getCurrentScriptLocation.Path + "\SP Scripts\XSLT\SAO_ES_Static_Zimory_Transform.xslt")
}

$xsltStage1 = $($getCurrentScriptLocation.Path + "\SP Scripts\XSLT\DSCFarmConfigurationTransformStage1.xsl")
$xsltStage2 = $($getCurrentScriptLocation.Path + "\SP Scripts\XSLT\DSCFarmConfigurationTransformStage2.xsl")

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
$secAccountPassword = ConvertTo-SecureString "Start123" -AsPlaintext -Force 
$AccountCredentials = New-Object System.Management.Automation.PsCredential "media\Administrator",$secAccountPassword

#################################################################################################
#New for 2.8.1+ - AMS integration
$amsUrl = ($environmentConfig.SelectSingleNode("//jsonurl")).InnerText
$amsAppKey = ($environmentConfig.SelectSingleNode("//applicationkey")).InnerText
$amsSessionTable = ($environmentConfig.SelectSingleNode("//sessiontable")).InnerText
$amsSessionDetailTable = ($environmentConfig.SelectSingleNode("//sessiondetailtable")).InnerText

#################################################################################################

. ".\SP Scripts Source\TSPInstallerLogging.ps1"
. ".\SP Scripts Source\TSCommonFunctions.ps1"
. ".\SP Scripts Source\JSONFunctions.ps1"

#################################################################################################
if (($amsUrl -ne "") -and ($amsSessionID -ne 0))
{
    $amsEnabled = $true
    Configure-AzureMobileServiceConfig $amsUrl $amsAppKey $amsSessionTable $amsSessionDetailTable
    loadAMSSesion $amsSessionID
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
LogStartTracing $("c:\ServiceExecutorESExtensionQPS" + $currentDate.ToString() + ".txt") $htmlUpdateFile $htmlAdminPageFile $htmlStatusFile

logStatusMessageToHTML "Configuring the Service Extension" "[eQPS]" $amsEnabled
writeStatusPageUpdate "1" $amsEnabled

if ($SkipEarlyStepsForDebugging -eq $false)
{
#################################################################################################
    #STEP 1 - Perform XSLT Transform
    LogStep "Transform XML" 
    try
    {   
        #transformXMLToFinalSchema $xsltStage1 $xsltStage2 $xmlMergedConfigFile $xmlFinalTempConfigFile $xmlFinalConfigFile #perform XSLT transform (which contains logic) to the final XML schema.
        #TODO - testing.
        [xml]$xmlFinalConfigFileTEMP = Get-Content $xmlCurrentTopologyConfigFile -Encoding UTF8   
        $xmlFinalConfigFileTEMP.Save($xmlFinalConfigFile)
        logStatusMessageToHTML "Configuration XML Processed" "[eQPS]" $amsEnabled
        
    }
    catch
    {
        LogRuntimeError "Error occurred during XSLT Transform. Stop Installation" $_
        exit 1;
    }
    #END STEP 1 - Transform


    #################################################################################################   
    #STEP 2 - Check if the Farm has already got this extension installed or has reached the limit of installs for this extension.
    LogStep "Check that the Farm should have this extension installed" 
    try
    {          
        loginfo "`nCheck that the mandatory pre-requisite HA Extension is already installed"
        $plugData = getPlugXMLIfAlreadyInstalled -plugName $haPLugName -rawXMLConfigFile $xmlFinalConfigFile
        #HA is a mandatory pre-requisite for eQPS. Check its installed.
        if ($plugData -eq $null)
        {
            logStatusMessageToHTML "The High Availability Extension needs to be installed in the farm before you can add eQPS Extensions" "[eQPS]" $amsEnabled
            loginfo "[eQPS] The High Availability Extension needs to be installed in the farm before you can add eQPS Extensions"
            throw "The High Availability Extension needs to be installed in the farm before you can add eQPS Extensions"
        }
        else
        {
            logStatusMessageToHTML "The High Availability Extension (a mandatory pre-requisite) is installed. Proceed with Install" "[eQPS]" $amsEnabled
            loginfo "[eQPS] The High Availability Extension (a mandatory pre-requisite) is installed. Proceed with Install"
            #Check the number of eQPS Extensions in the Configuration XML 
            [int]$eQPSMultiplierFromConfigurationXML = countNumberOfEQPSExtensionsInXML $zimoryConfigurationFile $plugName
            logStatusMessageToHTML $("QPS Multipliers in Configuration XML: " + $eQPSMultiplierFromConfigurationXML) "[eQPS]" $amsEnabled
            LogInfo $("[eQPS] QPS Multipliers in Configuration XML: " + $eQPSMultiplierFromConfigurationXML)

            #Now check the number of already installed eQPS Extensions.  
            [int]$eQPSExtnesionsAlreadyInstalled = 0
            [int]$eQPSMultiplier = 0
            $plugDataeQPS = getPlugXMLIfAlreadyInstalled -plugName $plugName -rawXMLConfigFile $xmlFinalConfigFile
            if ($plugDataeQPS -ne $null)
            {
                $eQPSExtnesionsAlreadyInstalled = $plugDataeQPS.Count
            }
            logStatusMessageToHTML $("QPS Multipliers already deployed to Farm: " + $eQPSExtnesionsAlreadyInstalled) "[eQPS]" $amsEnabled
            LogInfo $("[eQPS] QPS Multipliers already deployed to Farm: " + $eQPSExtnesionsAlreadyInstalled)

            if ($eQPSMultiplierFromConfigurationXML -gt $eQPSExtnesionsAlreadyInstalled)
            {
                $eQPSMultiplier = ($eQPSMultiplierFromConfigurationXML - $eQPSExtnesionsAlreadyInstalled)
                logStatusMessageToHTML $("eQPS Multipliers that need to be deployed to the Farm ([eQPS in XML] - [eQPS Already Installed]): " + $eQPSMultiplier) "[eQPS]" $amsEnabled
                LogInfo $("eQPS Multipliers that need to be deployed to the Farm ([eQPS in XML] - [eQPS Already Installed]): " + $eQPSMultiplier)
            }
            else
            {
                logStatusMessageToHTML $("There are already sufficent eQPS Extensions installed to the farm. Stop Install") "[eQPS]" $amsEnabled
                LogInfo $("There are already sufficent eQPS Extensions installed to the farm. Stop Install")
                throw "There are already sufficent eQPS Extensions installed to the farm. Stop Install"
            }
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
        extensionBackupServersFromCurrentTopologyXML $xmlCurrentTopologyConfigFile $xmlFinalConfigFile #Calculate the number of servers etc and then write directly back to the XML.
        extensionBackupCurrentSearchTopologyXML $xmlCurrentTopologyConfigFile $xmlFinalConfigFile #Calculate the number of servers etc and then write directly back to the XML.     
        #Change for 2.7.2 - change hA flag to $true as its a mandatory pre-requisite to applying a eQPS Extension.   
        processSizingESv2Extension $xmlCurrentTopologyConfigFile $xmlFinalConfigFile -hA $true -qpsMultiplier $eQPSMultiplier
        reworkSearchTopology $xmlCurrentTopologyConfigFile $xmlFinalConfigFile -hA $false
        changeProvisionPropertyOfServiceApps $xmlFinalConfigFile -hA $false
        logStatusMessageToHTML "Sizing XML copied from Base Service XML" "[eQPS]" $amsEnabled
    }
    catch
    {
        LogRuntimeError "Error occurred during sizing calculator. Stop Installation" $_
        exit 1;
    }
    #END STEP 3 - Sizing Calculator  


#################################################################################################
    #New for 2.7.1 - Add the optional to only run the Sizing Calculator. I may remove this for future releases.
    if ($onlyProcessSizingAndNotInstall -eq "True")
    {
        [xml]$processedFinalXML = Get-Content $xmlFinalConfigFile
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
            logStatusMessageToHTML "About to provision the new Virtual Machines needed to support the Extension (this may take a while)" "[eQPS]" $amsEnabled
            configureLocalHostFileZimoryServer $xmlFinalConfigFile #In DSI we need a host entry to access Zimory API. This will add the host entry if its defined in the XML.
            #Simple test for post CEBIT work - check is version 2.7.X or higher.   
            if ($numCurrentVersion -gt 269)
            {
                if ($isDSIInstall -eq $false)
                {
            #        $t1 = Read-Host 'Reset all VMs to snapshot on test system'
                }
                provisionDeploymentsv2 $xmlFinalConfigFile $getCurrentScriptLocation #Use Zimory API to create deployments and update the XML with the new IP addresses of these VMs. This function will not return until the deployment has started - which could be a LONG delay - 1 to 2 hours etc. 
            }
            else
            {
                provisionDeployments $xmlFinalConfigFile $getCurrentScriptLocation #Use Zimory API to create deployments and update the XML with the new IP addresses of these VMs. This function will not return until the deployment has started - which could be a LONG delay - 1 to 2 hours etc. 
            }
            configureLocalHostFile $xmlFinalConfigFile #To ensure that we only interact with the correct servers, we will modify the local host file. We need this because we are provisioning multiple VMs with identical Windows Computer names.
            logStatusMessageToHTML "Virtual Machines provisioned" "[eQPS]" $amsEnabled
      
        }
        catch
        {
            LogRuntimeError "[eQPS] Error occurred during ensuring that the Deployments are available and contactable. Stop Installation" $_
            exit 1;
        }
    
        #Stage 2 - now the deployment(s) are running, perform the initial Startup script configuration.
        try
        {   
            logStatusMessageToHTML "Running Startup Scripts"  "[eQPS]" $amsEnabled
            #The line below has been commented out because the DSI Appliance does not support remoting. We need to configure it in the Startup script.
            #waitForPSRemotingToBeAvailable $xmlFinalConfigFile #ensure that all the servers are available via PS Remoting.
            checkAllServersHaveRebooted $xmlFinalConfigFile #Check the Servers can be pinged
            startWinRMServiceAllServers $xmlFinalConfigFile $getCurrentScriptLocation #run script which sets the computer names of each deployment. This will trigger a reboot.        
            executeStatupScriptOnDeployments $xmlFinalConfigFile $getCurrentScriptLocation #run script which sets the computer names of each deployment. This will trigger a reboot.
            checkAllServersHaveRebooted $xmlFinalConfigFile
            #checkPSRemotingIsAvailable $xmlFinalConfigFile #ensure that all the servers are available via PS Remoting.        
            waitForPSRemotingToBeAvailable $xmlFinalConfigFile #ensure that all the servers are available via PS Remoting.  
            #New for 2.7.2 - Configure Local Disks
            executeConfigureLocalDisksScriptOnDeployments $xmlFinalConfigFile $getCurrentScriptLocation #run script which sets up the local disks.
        }
        catch
        {
            LogRuntimeError "[eQPS] Error occurred during provisioning Deployments via Zimory API. Stop Installation" $_
            exit;
        }
        #END STEP 4 - Provision Deployments 
    }
}

#New for 2.7.1 - Add the optional to only run the Sizing Calculator. I may remove this for future releases.
if ($onlyProcessSizingAndNotInstall -eq "False")
{

    ########################################################################################################################################################
    #STEP 5 - Start Script Execution
    #Now that the Deployments are provisioned, start executing the scripts.
    LogStep "Start script execution against the Deployment(s)"    
    try
    {    
        changeProvisionPropertyOfServiceApps $xmlFinalConfigFile -hA $true
        #################################################################################################                
        #STEP 5.0 - Copy XML config to the sub folder.
        LogStep "Copy XML Config file to the SP Scripts sub folder."
        Copy-Item $xmlFinalConfigFile -Destination $($getCurrentScriptLocation.Path + "\SP Scripts\") -Force
        saveFinalXML -xMLConfigFile $xmlFinalConfigFile -configName $xmlFinalConfigFileNoPath -newPath  $($getCurrentScriptLocation.Path + "\Installations\Configuration XML\")   
        writeStatusPageUpdate "2" $amsEnabled
        #END STEP 0 - Copy XML Config file.

        #################################################################################################                
        #STEP 5.1 - Configure DC Script
        LogStep "Configure Domain Settings"
        LogInfo "Calling .\ConfigureDCAndAccounts.ps1; Configure-Domain"
        logStatusMessageToHTML "[eQPS] Configuring Domain membership of all Virtual Machines"
        powershell.exe -noprofile -file "SP Scripts Source\ConfigureDCAndAccounts.ps1" "'$xmlFinalConfigFile'" "All" #| Out-Null
        LogInfo $((processExitCode $LASTEXITCODE "Configure DC") +  " (Exit Code: " + $LASTEXITCODE + ")")
        $LASTEXITCODE = 0
        #END STEP 1 - Configure DC Script
        #################################################################################################

        #STEP 5.3 - Configure Farm (Initial Settings)
        LogStep "Configuring SharePoint Farm settings"
        LogInfo "Calling CreateFarmAndInititalConfigCombined.ps1; CreateAndConfigure-Farm"
        logStatusMessageToHTML "Starting SharePoint Install  (Stage 1 of 3)" "[eQPS]" $amsEnabled
        powershell.exe -noprofile -file "SP Scripts Source\CreateFarmAndInititalConfigCombined.ps1"  "'$xmlFinalConfigFile'" "All" #| Out-Null
        LogInfo $((processExitCode $LASTEXITCODE "Create Farm And Initial Settings") +  " (Exit Code: " + $LASTEXITCODE + ")")
        $LASTEXITCODE = 0
        #END STEP 3 - Configure Farm (Initial Settings)    
        
    
        #################################################################################################
        #STEP 5.4 - Create Service Applications
        LogStep "Create Service Applications"
        LogInfo "Calling CreateServiceApplication.ps1;"
        logStatusMessageToHTML "Starting SharePoint Install (Stage 2 of 3)" "[eQPS]" $amsEnabled
        $exportExistingSearchTopologyPath = $($getCurrentScriptLocation.Path + "\Installations\Configuration XML\")
        powershell.exe -noprofile -file "SP Scripts Source\CreateServiceApplication.ps1"  "'$xmlFinalConfigFile'" "'$exportExistingSearchTopologyPath'"  #| Out-Null
        LogInfo $((processExitCode $LASTEXITCODE "Create Service Applications") +  " (Exit Code: " + $LASTEXITCODE + ")")
        $LASTEXITCODE = 0
        #END STEP 5 - Configure Service Applications

        #################################################################################################
        #STEP 5.6 - Finalise farm
        LogStep "Finalizing SharePoint install"
        LogInfo "Calling FinaliseFarm.ps1; Finalise-Farm"
        logStatusMessageToHTML "Starting SharePoint Install (Stage 3 of 3)" "[eQPS]" $amsEnabled
        powershell.exe -noprofile -file "SP Scripts Source\FinaliseFarm.ps1"  "'$xmlFinalConfigFileNoPath'"  "All" #| Out-Null
        LogInfo $((processExitCode $LASTEXITCODE "Finalise Farm") +  " (Exit Code: " + $LASTEXITCODE + ")")
        $LASTEXITCODE = 0
        #END STEP 6 - Finalise Farm

        #################################################################################################

        #New for 2.7.1 + - Save the current topology
        saveCurrentTopologyXML -xMLConfigFile $xmlFinalConfigFile -configName $xmlCurrentTopologyConfigFileNoPath -newPath  $($getCurrentScriptLocation.Path + "\Installations\Configuration XML\") 
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
       logStatusMessageToHTML "ERROR: Install has failed"    "[eQPS]" $amsEnabled
       writeStatusPageUpdate "4" $amsEnabled
       exit 1;
    }
}
#Finish the logging.
logStatusMessageToHTML "Finished" "[eQPS]" $amsEnabled
LogEndServiceExecutionTracing