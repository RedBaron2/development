$ErrorActionPreference = 'Stop';

$year = ''
[array]$key = Get-UninstallRegistryKey -SoftwareName "Visual Studio*"

if ($key.DisplayName -match "$year") {
$toolsPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = ''
  fileType       = 'vsix'
  VsixUrl        = "file://$toolsPath/test.exe"
}

Install-ChocolateyVsixPackage @packageArgs
} else {
Write-Warning "Visual Studio not found installed on the system. This package will not be installed."
}
