param 
(
    [string]$ResourceGroup,
    [string]$ServiceName,
    [string]$SubscriptionID,
    [string]$BuildAccountName,
    [string]$BuildAccountPassword,
    [string]$ParamsJSON,
    [string]$ServerJSON
)

. ".\Common\TSPInstallerLogging.ps1"
. ".\Common\TSCommonFunctions.ps1"
. ".\Common\JSONFunctions.ps1"

$GLOBAL_scriptExitCode = 0


#Configure logging
$currentDate = Get-Date -format "yyyy-MMM-d-HH-mm-ss"
LogStartTracing $("c:\v4_Azure_CreateServerImportXML_" + $currentDate.ToString() + ".txt") $htmlUpdateFile $htmlAdminPageFile $htmlStatusFile


###############################################################################################
#Values to change:
$ResourceGroup = "OsbornTest4RG"
$ServiceName = "osazure12"
#$ParamsJSON = ""
#$ServerJSON = ""
$SubscriptionID = "d304809a-1d09-44fa-bd80-0a994e53941d"
$BuildAccountName = "osazure\sp-inst"
$BuildAccountPassword = "D1sabl3d281660"
#End of values to change.
###############################################################################################

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -Force -Confirm:$false -ErrorAction SilentlyContinue
$getCurrentScriptLocation = Get-Location

$secPassword = ConvertTo-SecureString $BuildAccountPassword -AsPlainText -Force
$buildAccountCredential = New-Object System.Management.Automation.PSCredential($BuildAccountName, $secPassword)

LogStep "Connect to Azure to get information about the subscription."    

try
{
    Import-Module azure -ErrorAction Stop
}
catch
{
    throw "You probably dont have the Azure PowerShell module installed on this server. Visit: 'http://azure.microsoft.com/en-us/documentation/articles/install-configure-powershell/' for instructions - install Web Platform Installer 5. IMPORTANT - YOU MUST RESTART THE POWERSHELL WINDOW AFTER THIS INSTALL."
}
#Add-AzureAccount
try
        {
        Select-AzureSubscription -SubscriptionId $SubscriptionID

        loginfo "Subscription loaded"

        Switch-AzureMode -Name AzureResourceManager

        $rg = Get-AzureResourceGroup -Name $ResourceGroup
        if ($rg -ne $null)
        {
            loginfo "RG Found"

            $classicVMs = $rg.Resources | Where-Object {$_.ResourceType -eq "Microsoft.ClassicCompute/virtualMachines" -and $_.Name -Match $serviceName}

            $serviceVMCount = $classicVMs.Count
            $spVMCount = $serviceVMCount - 1 #there is always 1 SQL Server

            loginfo $("Total VMs: " + $serviceVMCount.ToString())
            loginfo $("SP VMs: " + $spVMCount.ToString())

            LogStep "Copy Template File"    
            #Copy the template file.
            $xmlServerImportFileTemplate = $($getCurrentScriptLocation.Path + "\Server Import XML\2012\2016\sp_base_servers_import_16_" + $spVMCount + "+1_template.xml")
            $xmlServerImportFile = $($getCurrentScriptLocation.Path + "\Server Import XML\2012\2016\sp_base_servers_import_16.xml")

            [xml]$templateImportFile = Get-Content $xmlServerImportFileTemplate -Encoding UTF8
            $templateImportFile.Save($xmlServerImportFile)

            loginfo $("Template file saved: " + $xmlServerImportFile)
            Switch-AzureMode -Name AzureServiceManagement

            LogStep "Enter VM loop to get minRole."    

            foreach ($classicVM in $classicVMs)
            {
                $VMName = $classicVM.Name
                $vmDetails = Get-AzureVM -ServiceName $VMName
                $internalIP = $vmDetails.IpAddress    

                loginfo $("VM Name: " + $VMName)
                loginfo $("VM IP: " + $internalIP)

                $WinRMCert = $vmDetails.VM.DefaultWinRMCertificateThumbprint

                (Get-AzureCertificate -ServiceName $VMName -Thumbprint $WinRMCert -ThumbprintAlgorithm sha1).Data | Out-File ".\PoShCloud.cer"

                Import-Certificate -FilePath ".\PoShCloud.cer" -CertStoreLocation "Cert:\localmachine\root"
                loginfo $("Certificate Saved")

                $winRMURI = Get-AzureWinRMUri -ServiceName $VMName
    
                loginfo $("Win RM URI: " + $winRMURI.AbsoluteUri)
               # Invoke-Command -ConnectionUri $winRMURI -Credential $buildAccountCredential -ScriptBlock{
               #    Enable-WSManCredSSP -Role Server -Force
               # }

                #SP Code:
                $retVal = Invoke-Command -ConnectionUri $winRMURI -Credential $buildAccountCredential -Authentication Credssp -ScriptBlock{
                   Add-PSSnapin Microsoft.SharePoint.PowerShell
                   $server = Get-SPServer $env:computername
                   $server.Role
                }
                $minRole = $retVal.Value
        
                loginfo $("VM MinRole: " + $minRole)

                if (($minRole -eq "") -or ($minRole -eq $null))
                {
                    #SQL Server.
                    $minRole = "SQL"
                }
                else
                {

                }


                [xml]$importFile = Get-Content $xmlServerImportFile -Encoding UTF8
                $serverToWriteTo = $importFile.baseservers.server | where-object {$_.minrole -eq $minRole -and $_.ip -eq ""}
                $serverToWriteTo.name = $VMName
                $serverToWriteTo.ip = $internalIP
                $serverToWriteTo.name = $VMName
                $importFile.Save($xmlServerImportFile)

                loginfo $("XML Saved: " + $xmlServerImportFile)

            }




        }
        else
        {
            Loginfo "Resource Group not found." 
        }
    }
    catch
    {
        LogRuntimeError "Error" $_
        LogInfo $("Procesing completed with an error. Exit Code: " + $GLOBAL_scriptExitCode)
        $GLOBAL_scriptExitCode = 1     
    }
    finally
    {
        $errCount = GetRuntimeErrorCount
        $warnCount = GetWarningsCount
        if ($errCount -gt 0)
        {
            $GLOBAL_scriptExitCode = 1
        }
        if ($warnCount -gt 0)
        {
            $GLOBAL_scriptExitCode = -1
        }
        LogInfo $("Exit Code: " + $GLOBAL_scriptExitCode)
        
        LogEndTracing
        
      

        exit $GLOBAL_scriptExitCode
     }

