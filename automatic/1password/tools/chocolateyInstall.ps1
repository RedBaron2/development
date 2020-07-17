$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = ''
  softwareName   = '1Password*'
  checksum       = ''
  checksumType   = ''
  silentArgs     = ''
  validExitCodes = @(1)
}

if ([string]::IsNullOrEmpty($packageArgs.silentArgs)) { $packageArgs.silentArgs = "--silent" }

do { Install-ChocolateyPackage @packageArgs }

while (!( Get-Process "1password" ) )
