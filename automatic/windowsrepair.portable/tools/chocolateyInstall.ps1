$packageArgs = @{
  packageName    = 'windowsrepair'
  fileType       = 'zip'
  url            = 'http://www.tweaking.com/files/setups/tweaking.com_windows_repair_aio.zip'
  UnzipLocation	 = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
  checksum       = '521776ad02dd690580bd6f322f1e2d36aea267cc1ce32df19aae4a2a8884431f'
  checksumType   = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
  softwareName   = 'Windows Repair All in One (Portable)'
}
Install-ChocolateyZipPackage @packageArgs
