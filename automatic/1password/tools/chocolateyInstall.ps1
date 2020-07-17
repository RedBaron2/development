$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = ''
  softwareName   = '1Password*'
  checksum       = ''
  checksumType   = ''
  silentArgs     = ''
  validExitCodes = @(0 , 1)
}

if ([string]::IsNullOrEmpty($packageArgs.silentArgs)) { $packageArgs.silentArgs = "--silent" }
 Install-ChocolateyPackage @packageArgs -Verbose
 
 sleep 60
 $processID = ( Get-Process $packageArgs.packageName ).Id
 if ( $processID ) { Stop-Process -Id $processID }
