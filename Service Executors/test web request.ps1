$workingFolder = "C:\Scripts\3.5.2"
$response = Invoke-WebRequest -UseDefaultCredentials -Uri "http://localhost:123/?command= cd '$workingFolder';powershell.exe -noprofile -file '$workingFolder\Service Executors\AzurePowerShell_CreateServerImportXML.ps1' '' '' '' '' '' '' '' "
$response.RawContent

Start-HttpListenerSharedSecret -Debug -Port 12341 -Verbose


$workingFolder = "C:\Scripts\3.5.2"
$response = Invoke-WebRequest -UseDefaultCredentials -Uri "http://localhost:12341/?command=exit"
$response.RawContent
