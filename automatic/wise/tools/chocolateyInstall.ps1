$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = 'wisejetsearch'
  fileType       = 'exe'
  url            = 'https://downloads.wisecleaner.com/soft/WiseCare365.exe'
  UnzipLocation	 = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
  checksum       = '9929295ddee53976b5d48e30a4e82258eeefe3c28e51654c126756c2c2c3f6c1'
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
