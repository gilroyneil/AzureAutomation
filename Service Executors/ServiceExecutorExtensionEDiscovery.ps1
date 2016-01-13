param 
(
    [string]$zimoryConfigurationFile,
    [string]$SkipEarlyStepsForDebugging,
    [string]$isDSIInstall,
    [string]$plugName    ,
    [int]$amsSessionID 
)
$useNewPlugs = $false
$currentVersion = "2.8.1"

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
$xmlMergedConfigFile = $($getCurrentScriptLocation.Path + "\SP Scripts\XML\MergedTransformed_" + $currentVersion + "_ES_JD.xml")
#This is the XML file which will be used by the scripted install.
$xmlFinalTempConfigFile = $($getCurrentScriptLocation.Path + "\SP Scripts\XML\FinalStage1Output_" + $currentVersion + "_ES_JD.xml")
#This is the XML file which holds several settings which are specific to the customer/environment (farm number, deployment sever name, media server name, search proxy).
$xmlFinalTempConfigFile = $($getCurrentScriptLocation.Path + "\SP Scripts\XML\FinalStage1Output_" + $currentVersion + "_ES_JD.xml")
#This is the XML file which holds several settings which are specific to the customer/environment (farm number, deployment sever name, media server name, search proxy).
$xmlCustomerEnvironmentTempConfigFile = $($getCurrentScriptLocation.Path + "\SP Scripts\XML\MergedCustomerEnvironmentTransformed_" + $currentVersion + "_ES_JD.xml")

#New for 2.7.1+ - a XML file to store the topology.
$xmlCurrentTopologyConfigFileNoPath = "Final_" + $currentVersion + "_ES_JD_CurrentTopology.xml"

#These next 2 entries are the name of the final XML files which are created in steps 1 - 4
$xmlFinalConfigFileBaseServiceNoPath = "Final_" + $currentVersion + "_ES_JD_BaseService.xml"
$xmlBaseConfigFile = $($getCurrentScriptLocation.Path + "\" + $xmlFinalConfigFileBaseServiceNoPath)


$xmlFinalConfigFileNoPath = "Final_" + $currentVersion + "_ES_JD_Extension_EDiscovery.xml"
$xmlFinalConfigFile = $($getCurrentScriptLocation.Path + "\" + $xmlFinalConfigFileNoPath)

$xsltEnvironmentAndZimory = $($getCurrentScriptLocation.Path + "\SAO_ES_CustomerAndEnvironment_Zimory_Transform.xsl")
if ($isDSIInstall -eq $false){$xsltEnvironmentAndZimory = $($getCurrentScriptLocation.Path + "\SAO_ES_CustomerAndEnvironment_Zimory_Transform_TEST.xsl")}

#New IF statement to support new plugs.
if ($useNewPlugs -eq $true)
{
    $xsltZimoryAndStatic = $($getCurrentScriptLocation.Path + "\SP Scripts\XSLT\SAO_ES_Extension_EDiscovery_Static_Zimory_Transform_newplug.xslt")
}
else
{
    $xsltZimoryAndStatic = $($getCurrentScriptLocation.Path + "\SP Scripts\XSLT\SAO_ES_Extension_EDiscovery_Static_Zimory_Transform.xslt")
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
#create a PS-Drive so that we can use credentials. Copy the SP Scripts and SQL Scripts
New-PSDrive -name $mediaServer -PsProvider FileSystem -root $spMediaLocation -credential $AccountCredentials -ErrorAction Stop                      
    Copy-Item $spMediaLocation -Destination $($getCurrentScriptLocation.Path) -Recurse -Force            
    Copy-Item $sqlMediaLocation -Destination $($getCurrentScriptLocation.Path) -Recurse -Force            
Remove-PSDrive -Name $mediaServer 

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
LogStartTracing $("c:\ServiceExecutorESExtensionEDiscovery" + $currentDate.ToString() + ".txt") $htmlUpdateFile $htmlAdminPageFile $htmlStatusFile

logStatusMessageToHTML "Configuring the Service Extension" "[EDISCOVERY]" $amsEnabled
writeStatusPageUpdate "1" $amsEnabled

if ($SkipEarlyStepsForDebugging -eq $false)
{
#################################################################################################
    #STEP 1 - Process XML (merge Zimory configuration with our static XML structure)
    LogStep "Merge customer specific metadata with our static XML"    
    try
    {
        #$zimoryConfigurationFile = getZimoryConfiguration $getCurrentScriptLocation #Connect to Zimmory API to get the deployment metadata
        mergeCustomerAndEnvironmentConfiguration $xsltZimoryAndStatic $xsltEnvironmentAndZimory $staticXmlConfigFile $zimoryConfigurationFile $xmlMergedConfigFile $xmlCustomerEnvironmentTempConfigFile #Merge the XML from Zimory with our raw XML. There are 2 transforms being done in here.
    }
    catch
    {
        LogRuntimeError "Error occurred getting Zimory Configuration or during merging Customer metadata with our Static/Environment Metadata. Stop Installation" $_
        exit 1;
    }
    #END STEP 0 - Process XML    
    


#################################################################################################
    #STEP 2 - Perform XSLT Transform
    LogStep "Transform XML" 
    try
    {   
        transformXMLToFinalSchema $xsltStage1 $xsltStage2 $xmlMergedConfigFile $xmlFinalTempConfigFile $xmlFinalConfigFile #perform XSLT transform (which contains logic) to the final XML schema.
        logStatusMessageToHTML "Configuration XML Processed" "[EDISCOVERY]" $amsEnabled
    }
    catch
    {
        LogRuntimeError "Error occurred during XSLT Transform. Stop Installation" $_
        exit 1;
    }
    #END STEP 2 - Transform

#################################################################################################   
    #STEP 3 - Sizing Calculator (for Extensions we copy from the Base XML rather than recalculate).
    LogStep "Sizing Calculator" 
    try
    {   
        processSizingInExtensionViaCopyFromBaseServiceXML $xmlFinalConfigFile $xmlBaseConfigFile #Calculate the number of servers etc and then write directly back to the XML.
        logStatusMessageToHTML "Sizing XML copied from Base Service XML" "[EDISCOVERY]" $amsEnabled
    }
    catch
    {
        LogRuntimeError "Error occurred during sizing calculator. Stop Installation" $_
        exit 1;
    }
    #END STEP 3 - Sizing Calculator  


#################################################################################################
    #STEP 4 - Provision Deployments
    LogStep "Ensure that the Deployment(s) are available"
    
    #Stage 1 - Provision the deployment(s) and wait for the deployment to be RUNNING.
    try
    {   
        logStatusMessageToHTML "Checking All Deployments are contactable" "[EDISCOVERY]" $amsEnabled
        configureLocalHostFileZimoryServer $xmlFinalConfigFile #In DSI we need a host entry to access Zimory API. This will add the host entry if its defined in the XML.
        configureLocalHostFile $xmlFinalConfigFile #To ensure that we only interact with the correct servers, we will modify the local host file. We need this because we are provisioning multiple VMs with identical Windows Computer names.        
    }
    catch
    {
        LogRuntimeError "[EDISCOVERY] Error occurred during ensuring that the Deployments are available and contactable. Stop Installation" $_
        exit 1;
    }
    
    #Stage 2 - now the deployment(s) are running, perform the initial Startup script configuration.
    try
    {   
        #The line below has been commented out because the DSI Appliance does not support remoting. We need to configure it in the Startup script.
        #waitForPSRemotingToBeAvailable $xmlFinalConfigFile #ensure that all the servers are available via PS Remoting.
        checkAllServersHaveRebooted $xmlFinalConfigFile #Check the Servers can be pinged
        startWinRMServiceAllServers $xmlFinalConfigFile $getCurrentScriptLocation #run script which sets the computer names of each deployment. This will trigger a reboot.                
        #checkPSRemotingIsAvailable $xmlFinalConfigFile #ensure that all the servers are available via PS Remoting.        
        waitForPSRemotingToBeAvailable $xmlFinalConfigFile #ensure that all the servers are available via PS Remoting.  
        logStatusMessageToHTML "Deployments are contactable" "[EDISCOVERY]" $amsEnabled
    }
    catch
    {
        LogRuntimeError "[EDISCOVERY] Error occurred during provisioning Deployments via Zimory API. Stop Installation" $_
        exit 1;
    }
    #END STEP 4 - Provision Deployments 

}
########################################################################################################################################################
#STEP 5 - Start Script Execution
#Now that the Deployments are provisioned, start executing the scripts.
LogStep "Start script execution against the Deployment(s)"    
try
{    

    #################################################################################################                
    #STEP 5.0 - Copy XML config to the sub folder.
    LogStep "Copy XML Config file to the SP Scripts sub folder."
    Copy-Item $xmlFinalConfigFile -Destination $($getCurrentScriptLocation.Path + "\SP Scripts\") -Force
    saveFinalXML -xMLConfigFile $xmlFinalConfigFile -configName $xmlFinalConfigFileNoPath -newPath  $($getCurrentScriptLocation.Path + "\Installations\Configuration XML\")   
    writeStatusPageUpdate "2" $amsEnabled
    #END STEP 0 - Copy XML Config file.

    #################################################################################################
    #STEP 5.1 - Create Web Applications - 
    LogStep "Creating SharePoint Web Applications"
    LogInfo "Calling CreateWebApplications.ps1;"
    logStatusMessageToHTML "Starting SharePoint Modifications (Stage 1 of 1)" "[EDISCOVERY]" $amsEnabled
    powershell.exe -noprofile -file "SP Scripts\CreateWebApplications.ps1"  $xmlFinalConfigFileNoPath #| Out-Null
    LogInfo $((processExitCode $LASTEXITCODE "Create Web Applications") +  " (Exit Code: " + $LASTEXITCODE + ")")
    $LASTEXITCODE = 0
    #END STEP 4 - Create Web Applications

    #################################################################################################
    #New for 2.7.1 + - Save the current topology
    saveFinalXML -xMLConfigFile $xmlFinalConfigFile -configName $xmlCurrentTopologyConfigFileNoPath -newPath  $($getCurrentScriptLocation.Path + "\Installations\Configuration XML\") 
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
   logStatusMessageToHTML "ERROR: Install has failed"    "[EDISCOVERY]" $amsEnabled
   writeStatusPageUpdate "4" $amsEnabled
   exit 1;
}

#Finish the logging.
logStatusMessageToHTML "Finished" "[EDISCOVERY]" $amsEnabled
LogEndServiceExecutionTracing