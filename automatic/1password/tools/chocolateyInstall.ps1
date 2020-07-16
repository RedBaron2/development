$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = ''
  softwareName   = '1Password*'
  checksum       = ''
  checksumType   = ''
  silentArgs     = ''
  validExitCodes = @(0)
}

if ([string]::IsNullOrEmpty($packageArgs.silentArgs)) { $packageArgs.silentArgs = "--silent --help" }

Install-ChocolateyPackage @packageArgs
