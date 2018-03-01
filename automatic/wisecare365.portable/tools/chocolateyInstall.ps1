$packageArgs = @{
  packageName    = 'wisecare365'
  fileType       = 'zip'
  url            = 'https://downloads.wisecleaner.com/soft/WiseCare365.zip'
  UnzipLocation	 = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
  checksum       = 'a37a9091e57d3d28844cc157f761df572a10b0a5ecf8d6dc6d2fed6341265e48'
  checksumType   = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
  softwareName   = 'Wise Care 365'
}
Install-ChocolateyZipPackage @packageArgs
