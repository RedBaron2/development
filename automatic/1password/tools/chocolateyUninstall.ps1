$ErrorActionPreference = 'Stop'

[array]$key = ( Get-UninstallRegistryKey -SoftwareName "1Password" ).QuietUninstallString

$packageArgs    = @{
    packageName = $env:ChocolateyPackageName
    fileType    = 'exe'
    File        = $key
}

Uninstall-ChocolateyPackage @packageArgs