
#Execute 2 commands which will ensure scripts run smoothly.
Set-ExecutionPolicy Bypass -Force
Get-PSSession | Remove-PSSession

#################################################################################################
# Define all plug names here. These much match the plug names in Zimory/DSI.
$ESBasePlugName = "SAO-ES-Base"
$ESEDiscoveryPlugName = "SAO-ES-EDiscovery____"
$ESeQPSPlugName = "SAO-ES-eQPS___"
$ESHAlugName = "SAO-ES-HA"

$currentVersion = "3.5.2"
#################################################################################################

#Skip Steps 1 - 4 if set to $true
$SkipEarlyStepsForDebugging = $false
#################################################################################################

#Use this variable to overide a few options to make the install work offline away from DSI/Zimory - if you set this to false make sure you edit the files ZIMORY_TEST.xml and SAO_ES_CustomerAndEnvironment_Zimory_Transform_TEST.xsl to suit your environment.
$isDSIInstall = $true


#################################################################################################
# Configure all the file locations.
#Get current script location.
$getCurrentScriptLocation = Get-Location

#Copy the SP and SQL Scripts from the Media Server.
$xsltEnvironmentAndZimory = $($getCurrentScriptLocation.Path + "\ES_CustomerAndEnvironment_Zimory_Transform.xsl")
if ($isDSIInstall -eq $false){$xsltEnvironmentAndZimory = $($getCurrentScriptLocation.Path + "\ES_CustomerAndEnvironment_Zimory_Transform_NON_TSYS.xsl")}

[xml]$environmentConfig = Get-Content $xsltEnvironmentAndZimory
$htmlStatusFile = ($environmentConfig.SelectSingleNode("//htmlstatuspage")).InnerText
$htmlAdminPageFile = ($environmentConfig.SelectSingleNode("//htmladminpage")).InnerText
$htmlFrontPageFile = ($environmentConfig.SelectSingleNode("//frontadminpage")).InnerText

$htmlUpdateFile = ($environmentConfig.SelectSingleNode("//htmlupdatefile")).InnerText
$mediaServer = ($environmentConfig.SelectSingleNode("//mediaserver")).InnerText
$spMediaLocation = ($environmentConfig.SelectSingleNode("//spscriptlocation")).InnerText
$sqlMediaLocation = ($environmentConfig.SelectSingleNode("//sqlscriptlocation")).InnerText

$importServersFromXML = ($environmentConfig.SelectSingleNode("//importservers")).InnerText        

#################################################################################################
#New for 3.0.0 - Seperate Variable to determine if use small SQL DBs (for DEV environments or a test install). Will pre-size DBs to be MUCH smaller than the actual Sizing Calculator would determine.
$preSizeDBsForDevInstall =  ($environmentConfig.SelectSingleNode("//useSmallDBPreSizingForDevInstalls")).InnerText 


#################################################################################################
#New for 3.0.0 - Get Deploy Server and Media Server UserName.
$deployServerUserName = ($environmentConfig.SelectSingleNode("//deploymentserverusername")).InnerText       
$deployServerPassword = ($environmentConfig.SelectSingleNode("//deploymentserverpassword")).InnerText       
$mediaServerUserName = ($environmentConfig.SelectSingleNode("//mediaserverusername")).InnerText       
$mediaServerPassword = ($environmentConfig.SelectSingleNode("//mediaserverpassword")).InnerText       
#################################################################################################


#################################################################################################
#New for 2.8.1+ - AMS integration (optional)
$amsUrl = ($environmentConfig.SelectSingleNode("//jsonurl")).InnerText
$amsProxy = ($environmentConfig.SelectSingleNode("//proxy")).InnerText
$amsAppKey = ($environmentConfig.SelectSingleNode("//applicationkey")).InnerText
$amsSessionTable = ($environmentConfig.SelectSingleNode("//sessiontable")).InnerText
$amsSessionDetailTable = ($environmentConfig.SelectSingleNode("//sessiondetailtable")).InnerText
$amsRegistrationsTable = ($environmentConfig.SelectSingleNode("//registrationstable")).InnerText
$amsSessionDetailServerTable = ($environmentConfig.SelectSingleNode("//sessiondetailservertable")).InnerText
$amsCustomerTable = ($environmentConfig.SelectSingleNode("//customertable")).InnerText
$amsCustomerID = ($environmentConfig.SelectSingleNode("//customerid")).InnerText

if ($amsUrl -ne "")
{
    $amsEnabled = $true
    #New for 3.0.1 - if AMS Proxy is provided then set it in the registry here. This should only be set for test installations - Delete from code once we have performed a single good test install.
    if (($isDSIInstall -eq $true) -and ($amsProxy -ne ""))
    {
        $amsProxyNoProtocol = $amsProxy.ToLower().Replace("http://", "")
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyEnable -Value 1 -Type DWord
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name AutoConfigURL -Value = -Type String
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name ProxyServer -Value $amsProxyNoProtocol -Type String                
    }
}
else
{
    $amsEnabled = $false
}
#################################################################################################

#Include common scripts.
#################################################################################################

. ".\Common\TSPInstallerLogging.ps1"
. ".\Common\TSCommonFunctions.ps1"
. ".\Common\JSONFunctions.ps1"


#################################################################################################


#Reset the error/warning counters. These are not used in this release but may be used in future for finer grained reporting.
$LASTEXITCODE = 0
$errCount = 0
$warningCount = 0

#Configure logging
$currentDate = Get-Date -format "yyyy-MMM-d-HH-mm-ss"
LogStartTracing $("c:\v3_ServiceExecutorES" + $currentDate.ToString() + ".txt")  $htmlUpdateFile $htmlAdminPageFile $htmlStatusFile

#Debug mode - default to $false for real installs.
if ($SkipEarlyStepsForDebugging -eq $false)
{
#################################################################################################
    #STEP 1 - Process XML (merge Zimory configuration with our static XML structure)
    LogStep "Get Customer Configuration"    
    try
    {
        #$zimoryConfigurationFile = getZimoryConfiguration $getCurrentScriptLocation $isDSIInstall #Connect to Zimmory API to get the deployment metadata PlugConfiguration
        $zimoryConfigurationFile = $($getCurrentScriptLocation.Path + "\Downloaded Configuration\PlugConfiguration.xml") #Connect to Zimmory API to get the deployment metadata PlugConfiguration
        $zimoryOnboardingConfigurationFile = $($getCurrentScriptLocation.Path + "\Downloaded Configuration\PlugConfiguration_On_Boarding.xml") #Customer On boarding data
        $arrayOfPlugsToInstall = getZimoryPlugsFromConfiguration $zimoryConfigurationFile #Get all the plugs which are in the XML.
        $proceedWithInstall = verifyZimoryLastModificationTimeStampv3 $zimoryConfigurationFile $getCurrentScriptLocation #Check the timestamp in the XML and that of a previous install (if any) to see whether or not to proceed.        
    }
    catch
    {
        LogRuntimeError "Error occurred getting Zimory Configuration or during merging Customer metadata with our Static/Environment Metadata. Stop Installation" $_
        exit;
    }
    #END STEP 0 - Process XML    
}

if (($proceedWithInstall) -and ((verifyPlugLastExecutionTimeStampForSuccessfullInstall $zimoryConfigurationFile $getCurrentScriptLocation $ESBasePlugName) -or (verifyPlugLastExecutionTimeStampForSuccessfullInstall $zimoryConfigurationFile $getCurrentScriptLocation $ESEDiscoveryPlugName)-or (verifyPlugLastExecutionTimeStampForSuccessfullInstall $zimoryConfigurationFile $getCurrentScriptLocation $ESeQPSPlugName) -or (verifyPlugLastExecutionTimeStampForSuccessfullInstall $zimoryConfigurationFile $getCurrentScriptLocation $ESHAlugName)))
{
    #Clear down HTML logging (update.html).
    clearDownHTMLFile
    clearDownAdminPageHTMLFile
    clearDownStatusHTMLPage
    #New for 2.8.1+ - AMS integration
    if ($amsUrl -ne "")
    {
        loginfo "AMS Enabled"
        $amsEnabled = $true
        Configure-AzureMobileServiceConfig $amsUrl $amsAppKey $amsSessionTable $amsSessionDetailTable $amsRegistrationsTable $amsCustomerTable $amsSessionDetailServerTable $amsProxy
        $sessionName = getSessionNameFromZimoryConfiguration $zimoryConfigurationFile $ESBasePlugName
        $shortCustomerName = getShortCustomerNameFromZimoryConfiguration $zimoryConfigurationFile $ESBasePlugName
        $longCustomerName = getLongCustomerNameFromZimoryConfiguration $zimoryConfigurationFile $ESBasePlugName
        #[int] $amsCustomerID = setUpAMSCustomer $shortCustomerName $longCustomerName
        LogInfo $("AMS Customer ID: " + $amsCustomerID.ToString())
        [int] $amsSessionID = setUpAMSSesion $sessionName $amsCustomerID $currentVersion
        LogInfo $("AMS Session ID: " + $amsSessionID.ToString())
    }
    else
    {
        loginfo "AMS Disabled"
        $amsEnabled = $false
        $amsSessionID = 0
    }


    logStatusMessageToHTML "Customer Configuration Processed" "EXECUTOR" $amsEnabled
    writeStatusPageUpdate "0" $amsEnabled



    ########################################################################################################################################################
    #STEP 2 - Start Script Execution
    #Look at the Plugs that we need to deploy and then run the scripts.
    LogStep "Start script execution against the Deployment(s)"    
    try
    {    
        #################################################################################################                
        #STEP 2.1 - Service Executor Base
        if ($arrayOfPlugsToInstall -contains $ESBasePlugName)
        {        
            if (verifyPlugLastExecutionTimeStampForSuccessfullInstall $zimoryConfigurationFile $getCurrentScriptLocation $ESBasePlugName)#Check if the last install timestamp exists, and if it does, in the XML from Zimory a newer date?
            {
                LogInfo "The Plug Data in the Customer Configuration XML is newer than the last successful install of this plug. Proceed with Install"
                #Todo - check the property in the Plug XML which defines that this plug should be deployed. As of 09/01/13 this has not yet been defined by Zimory.
                LogStep "Configure ES Base Service"

                #New for 3.0.0+ - If the XML says that we should import server names, tidy up AD.
                if (($importServersFromXML -eq $true) -and ($isDSIInstall -eq $false))
                {
                    logStatusMessageToHTML "Test Install - Clear Down AD" "EXECUTOR" $amsEnabled
                    #New - delete Server Objects from AD
                    $importServersFile = $($getCurrentScriptLocation.Path + "\base_servers_import.xml")
                    $importServersFileHA = $($getCurrentScriptLocation.Path + "\ha_servers_import.xml")
                    $dcIP = getDCIPFromZimoryConfiguration $zimoryConfigurationFile $ESBasePlugName
                    nonDSIInstallRemoveImportServerComputerObjects $dcip $importServersFile
                    nonDSIInstallRemoveImportServerComputerObjects $dcip $importServersFileHA
                }

                logStatusMessageToHTML "Base Plug found in XML. Starting Base Install" "EXECUTOR" $amsEnabled
                LogInfo "Calling .\ServiceExecutorBase_HA_Combo_ES.ps1;"
                powershell.exe -noprofile -file "Service Executors\ServiceExecutorBase_HA_Combo_ES.ps1" $zimoryConfigurationFile $zimoryOnboardingConfigurationFile $SkipEarlyStepsForDebugging $isDSIInstall "False" $importServersFromXML $preSizeDBsForDevInstall "False" "False" "False" "False" $amsSessionID #| Out-Null
                LogInfo $((processExitCode $LASTEXITCODE "Service Executor Base ES") +  " (Exit Code: " + $LASTEXITCODE + ")")
                if ($LASTEXITCODE -eq 0)
                {
                    loginfo "The Install was successful, so save the timestamp of the plug data to file system so that we can use this in logic to not re-run install later"
                    savePlugLastExecutionTimeStampForSuccessfullInstall $zimoryConfigurationFile $getCurrentScriptLocation $ESBasePlugName #As the install was successful, record the date of the Plug Data so that we dont re-run the same install again.                    
                }
                else
                {
                    loginfo "The Install was not successful, so dont save Plug timestamp."
                }
                $LASTEXITCODE = 0
            }
            else
            {
                LogInfo $("The Plug Data in Zimory is as old as the plug data for the last successful " + $ESBasePlugName + " install. Do not proceed with install")
            }
        }
        #END STEP 2.1 - Service Executor Base 
        #################################################################################################

        #################################################################################################                
        #STEP 2.2 - Service Executor for eDiscovery Extension
        if ($arrayOfPlugsToInstall -contains $ESEDiscoveryPlugName)
        {
            if (verifyPlugLastExecutionTimeStampForSuccessfullInstall $zimoryConfigurationFile $getCurrentScriptLocation $ESEDiscoveryPlugName)#Check if the last install timestamp exists, and if it does, in the XML from Zimory a newer date?
            {
                LogInfo "The Plug Data in Zimory is newer than the last successful install of this plug. Proceed with Install"
                #Todo - check the property in the Plug XML which defines that this plug should be deployed. As of 09/01/13 this has not yet been defined by Zimory.
                LogStep "Configure eDiscovery Service Extension"
                logStatusMessageToHTML "eDiscovery Extension Found in XML. Starting Install" "EXECUTOR" $amsEnabled
                LogInfo "Calling .\ServiceExecutorExtensionEDiscovery.ps1;"
                powershell.exe -noprofile -file "SP Scripts\ServiceExecutorExtensionEDiscovery.ps1" $zimoryConfigurationFile $SkipEarlyStepsForDebugging $isDSIInstall "False" $ESEDiscoveryPlugName  $amsSessionID #| Out-Null
                LogInfo $((processExitCode $LASTEXITCODE "eDiscovery Service Extension") +  " (Exit Code: " + $LASTEXITCODE + ")")
                if ($LASTEXITCODE -eq 0)
                {
                    loginfo "The Install was successful, so save the timestamp of the plug data to file system so that we can use this in logic to not re-run install later"
                    savePlugLastExecutionTimeStampForSuccessfullInstall $zimoryConfigurationFile $getCurrentScriptLocation $ESEDiscoveryPlugName #As the install was successful, record the date of the Plug Data so that we dont re-run the same install again.
                }
                else
                {
                    loginfo "The Install was not successful, so dont save Plug timestamp."
                }
                $LASTEXITCODE = 0
             }
            else
            {
                LogInfo $("The Plug Data in Zimory is as old as the plug data for the last successful " + $ESEDiscoveryPlugName + " install. Do not proceed with install")
            }
        }
        #END STEP 2.2 - Service Executor for eDiscovery Extension
        #################################################################################################

        if ($arrayOfPlugsToInstall -contains $ESHAlugName)
        {
            if (verifyPlugLastExecutionTimeStampForSuccessfullInstall $zimoryConfigurationFile $getCurrentScriptLocation $ESHAlugName)#Check if the last install timestamp exists, and if it does, in the XML from Zimory a newer date?
            {
                LogInfo "The Plug Data in Zimory is newer than the last successful install of this plug. Proceed with Install"
                #Todo - check the property in the Plug XML which defines that this plug should be deployed. As of 09/01/13 this has not yet been defined by Zimory.
                LogStep "Configure HA Service Extension"                
                    #New for 3.0.0+ - If the XML says that we should import server names, tidy up AD.
                if (($importServersFromXML -eq $true) -and ($isDSIInstall -eq $false))
                {
                    logStatusMessageToHTML "Test Install - Clear Down AD" "EXECUTOR" $amsEnabled
                    #New - delete Server Objects from AD        
                    $importServersFile = $($getCurrentScriptLocation.Path + "\ha_servers_import.xml")
                    $dcIP = getDCIPFromZimoryConfiguration $zimoryConfigurationFile $ESBasePlugName
                    nonDSIInstallRemoveImportServerComputerObjects $dcip $importServersFile
                }


                logStatusMessageToHTML "HA Extension Found in XML. Starting Extension Install" "EXECUTOR" $amsEnabled
                LogInfo "Calling Service Executors\ServiceExecutorExtensionES_HA.ps1;"
                powershell.exe -noprofile -file "Service Executors\ServiceExecutorExtensionES_HA.ps1" $SkipEarlyStepsForDebugging $isDSIInstall "False" $ESHAlugName $importServersFromXML $preSizeDBsForDevInstall $amsSessionID #| Out-Null
                LogInfo $((processExitCode $LASTEXITCODE "HA Service Extension") +  " (Exit Code: " + $LASTEXITCODE + ")")
                if ($LASTEXITCODE -eq 0)
                {
                    loginfo "The Install was successful, so save the timestamp of the plug data to file system so that we can use this in logic to not re-run install later"
                    savePlugLastExecutionTimeStampForSuccessfullInstall $zimoryConfigurationFile $getCurrentScriptLocation $ESHAlugName #As the install was successful, record the date of the Plug Data so that we dont re-run the same install again.
                }
                else
                {
                    loginfo "The Install was not successful, so dont save Plug timestamp."
                }
                $LASTEXITCODE = 0
             }
            else
            {
                LogInfo $("The Plug Data in Zimory is as old as the plug data for the last successful " + $ESHAlugName + " install. Do not proceed with install")
            }
        }
        #END STEP 2.3 - Service Executor for HA Extension
        #################################################################################################


        #################################################################################################                
        #STEP 2.4 - Service Executor for eQPS Extension
        if ($arrayOfPlugsToInstall -contains $ESeQPSPlugName)
        {
            if (verifyPlugLastExecutionTimeStampForSuccessfullInstall $zimoryConfigurationFile $getCurrentScriptLocation $ESeQPSPlugName)#Check if the last install timestamp exists, and if it does, in the XML from Zimory a newer date?
            {
                LogInfo "The Plug Data in Zimory is newer than the last successful install of this plug. Proceed with Install"
                #Todo - check the property in the Plug XML which defines that this plug should be deployed. As of 09/01/13 this has not yet been defined by Zimory.
                LogStep "Configure eQPS Service Extension"
                
                logStatusMessageToHTML "eQPS Extension Found in XML. Starting Install" "EXECUTOR" $amsEnabled
                LogInfo "Calling .\ServiceExecutorExtensionEQPS.ps1;"
                powershell.exe -noprofile -file "SP Scripts\ServiceExecutorExtensionEQPS.ps1" $zimoryConfigurationFile $SkipEarlyStepsForDebugging $isDSIInstall "False" $ESeQPSPlugName  $amsSessionID #| Out-Null
                LogInfo $((processExitCode $LASTEXITCODE "eQPS Service Extension") +  " (Exit Code: " + $LASTEXITCODE + ")")
                if ($LASTEXITCODE -eq 0)
                {
                    loginfo "The Install was successful, so save the timestamp of the plug data to file system so that we can use this in logic to not re-run install later"
                    savePlugLastExecutionTimeStampForSuccessfullInstall $zimoryConfigurationFile $getCurrentScriptLocation $ESeQPSPlugName #As the install was successful, record the date of the Plug Data so that we dont re-run the same install again.
                }
                else
                {
                    loginfo "The Install was not successful, so dont save Plug timestamp."
                }
                $LASTEXITCODE = 0
             }
            else
            {
                LogInfo $("The Plug Data in Zimory is as old as the plug data for the last successful " + $ESeQPSPlugName + " install. Do not proceed with install")
            }
        }
        #END STEP 2.4 - Service Executor for HA Extension
        #################################################################################################

        
    }
    catch
    {
       LogRuntimeError "Error occurred during script execution to deployment(s). Stop Installation" $_
       logStatusMessageToHTML "ERROR: Install has failed" "EXECUTOR" $amsEnabled
       writeStatusPageUpdate "4" $amsEnabled       
    }
    
    #Finish the logging.
    logStatusMessageToHTML "Finished" "EXECUTOR" $amsEnabled

}
else
{
    LogInfo "`nThe XML Last Modification date is the same as a preivous install. Stop install and do nothing"
    #logStatusMessageToHTML "The XML Last Modification date in the Zimory XML is the same as a preivous install. There is nothing new to install"
}

#Finish the logging.
LogEndServiceExecutionTracing