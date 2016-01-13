param 
(
 [Parameter(Mandatory=$true)]
    [string]$logFolderLocation,
    [Parameter(Mandatory=$true)]
    [string]$xmlFileNoPath
    
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

#These next 2 entries are the name of the final XML files which are created in steps 1 - 4
$xmlFinalConfigFileNoPath = $xmlFileNoPath
$xmlFinalConfigFile = $($getCurrentScriptLocation.Path + "\" + $xmlFinalConfigFileNoPath)
$xmlFinalConfigFileNoPath_original = $xmlFileNoPath
$xmlFinalConfigFile_original = $($getCurrentScriptLocation.Path + "\" + $xmlFinalConfigFileNoPath)





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


# [TB] 3.1.5 - support copying all media locally
$localMediaLocation = ($environmentConfig.SelectSingleNode("//localmediapath")).InnerText

#Reset the error/warning counters. These are not used in this release but may be used in future for finer grained reporting.
$LASTEXITCODE = 0
$errCount = 0
$warningCount = 0



. ".\Common\TSPInstallerLogging.ps1"
. ".\Common\TSCommonFunctions.ps1"
. ".\Common\JSONFunctions.ps1"


    #Configure logging
$currentDate = Get-Date -format "yyyy-MMM-d-HH-mm-ss"
if ($logFolderLocation.EndsWith("\"))
{
    $logFolderLocation.Remove(0, $logFolderLocation.Length -1)  
}
LogStartTracing $($logFolderLocation + "\ServiceExecutorHelperMissingPiecesV2_" + $currentDate.ToString() + ".txt") "" "" ""

    
    #New for 2.7.1 - Add the optional to only run the Sizing Calculator. I may remove this for future releases.
    if (1 -eq 1)
    {    
        net use * /delete /y
        net stop dnscache
        net start dnscache
        net use * /delete /y



        ########################################################################################################################################################
        #New for v3 - Copy all packages (and XML) to all Servers                
#        copyCommonPackageToServers $($xmlFinalConfigFile) $getCurrentScriptLocation $spMediaLocation
        
 #       copyAllScriptPackagesToServers $xmlFinalConfigFile $getCurrentScriptLocation $spMediaLocation

   #     copyConfigurationXMLToEachServer $xmlFinalConfigFile $getCurrentScriptLocation          
   
   
        # [TB] 3.1.5 - copy all media to each server (if required)
        if ($localMediaLocation -ne $null -and $localMediaLocation -ne "")
        {
     #       copyMediaToEachServer $xmlFinalConfigFile
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
            
           
   
                #################################################################################################                
                #STEP 5.1 - Configure DC Script
                LogStep "Configure Domain Settings"
                LogInfo "Calling .\Packages\Domain Configuration\Manager_ConfigureDCAndAccounts.ps1; All"
                
                #Update the log file prefix
                $stepLogFilePrefix = "Manager_ConfigureDCAndAcounts"
                $stepLocalLogFilePrefix = "Local_ConfigureDCAndAcounts" 
                [datetime] $startOperationTime =  get-date   
                $p = start-process powershell -argument "& 'Packages\Domain Configuration\Manager_ConfigureDCAndAccounts_MissingPieces.ps1' '$xmlFinalConfigFileNoPath' 'All';" -Wait -PassThru
                $p.WaitForExit()
                $lExitCode = $p.ExitCode
                #powershell.exe -noprofile -file "Packages\Domain Configuration\Manager_ConfigureDCAndAccounts_MissingPieces.ps1" $xmlFinalConfigFileNoPath "All" #| Out-Null
                LogInfo $((processExitCode $lExitCode "Configure DC") +  " (Exit Code: " + $lExitCode + ")")
                $lExitCode = 0
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

           $LASTEXITCODE = 1
        }

    }

#Finish the logging.

LogEndServiceExecutionTracing

return $LASTEXITCODE