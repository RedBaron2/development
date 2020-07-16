$ErrorActionPreference = 'Stop'

[array]$key = ( Get-UninstallRegistryKey -SoftwareName "${env:ChocolateyPackageName}*" ).UninstallString

$packageArgs    = @{
    packageName = $env:ChocolateyPackageName
    fileType    = 'exe'
    File        = $key
}

if ($packageArgs.packageName -ne "1password4") { Uninstall-ChocolateyPackage @packageArgs }
