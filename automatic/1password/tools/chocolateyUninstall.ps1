$ErrorActionPreference = 'Stop'

[array]$key = ( Get-UninstallRegistryKey -SoftwareName "1Password*" ).UninstallString

$packageArgs    = @{
    packageName = $env:ChocolateyPackageName
    fileType    = 'exe'
    File        = $key
}

Uninstall-ChocolateyPackage @packageArgs
