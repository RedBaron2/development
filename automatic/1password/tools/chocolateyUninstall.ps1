$ErrorActionPreference = 'Stop'

if (${env:ChocolateyPackageName} -ne "1password4") {
[array]$key = ( Get-UninstallRegistryKey -SoftwareName "${env:ChocolateyPackageName}*" ).UninstallString
$file = ($key -split " ")[0]

Write-Warning "This will stop $env:ChocolateyPackageName before Chocolatey Auto Uninstall completes."
$proc = ( Get-Process $env:ChocolateyPackageName ).Id
Stop-Process -Id $proc
$filepath,$arguments = ($key -split " ")[0]
if ($arguments -eq $null) { Write-Warning "arguments is null"; $arguments = "uninstall" }
sleep 10; Start-Process -FilePath $filepath -ArgumentList $arguments
}
