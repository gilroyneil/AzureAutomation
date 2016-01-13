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


$getCurrentScriptLocation = Get-Location
$getCurrentScriptLocation | Out-File "c:\test3.txt"