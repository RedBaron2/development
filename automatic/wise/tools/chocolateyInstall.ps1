$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = 'wisejetsearch'
  fileType       = 'zip'
  url            = 'https://downloads.wisecleaner.com/soft/WiseCare365.zip'
  UnzipLocation	 = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
  checksum       = '6e2ddf6336de9f79e59534d5f7522e75ab0460dd0de8667a8237a4edf6bbf179'
  checksumType   = 'sha256'
  silentArgs     = '/S /VERYSILENT /SUPPRESSMSGBOXES /NORESTART'
  validExitCodes = @(0)
  softwareName   = 'Wise Jet Search'
}
if ( $packageArgs.filetype -eq 'zip' ) {
Install-ChocolateyZipPackage @packageArgs
} else {
Install-ChocolateyPackage @packageArgs
}