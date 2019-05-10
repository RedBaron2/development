$packageArgs = @{
  packageName    = 'windowsrepair'
  fileType       = 'exe'
  url            = 'http://www.tweaking.com/files/setups/tweaking.com_windows_repair_aio.zip'
  checksum       = 'dcd45be99f0f31c8e8a6918efcc5f8421ff0fd5fac791ab972558f159c05ab9e'
  checksumType   = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
  softwareName   = 'Windows Repair All in One'
}
if ( $packageArgs.filetype -eq 'zip' ) {
Install-ChocolateyZipPackage @packageArgs
} else {
Install-ChocolateyPackage @packageArgs
}
