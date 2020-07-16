$ErrorActionPreference = 'Stop'

[array]$key = ( Get-UninstallRegistryKey -SoftwareName $env:ChocolateyPackageName ).UninstallString

$packageArgs    = @{
    packageName = $env:ChocolateyPackageName
    fileType    = 'exe'
    File        = $key
}

Uninstall-ChocolateyPackage @packageArgs
