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
# Download from an HTTPS location
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$filePath = Get-ChocolateyWebFile @packageArgs -FileFullPath "$toolsDir\PassWord_Install.exe"

Start-Process -FilePath $filePath -ArgumentList $packageArgs.silentArgs
sleep 12
Remove-Item "$toolsDir\PassWord_Install.exe" -force
