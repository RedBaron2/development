$packageArgs = @{
  packageName    = 'wisejetsearch'
  fileType       = 'zip'
  url            = 'https://downloads.wisecleaner.com/soft/WJS.zip'
  UnzipLocation	 = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
  checksum       = 'f65e10cacc2d1b35351fc9ab827537d646740454f7d345df7a4b9478bc029428'
  checksumType   = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
  softwareName   = 'Wise Jet Search'
}
Install-ChocolateyZipPackage @packageArgs
