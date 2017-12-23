$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName       =   'tronscript'
  url               =   'https://bmrf.org/repos/tron/Tron%20v10.4.2%20(2017-12-11).exe'
  unziplocation     =   "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
  # SpecificFolder    =   ''
  checksum          =   '1AF6EC2B5A44356AE89C91D14027E26EE43F52693F01ACCE175B9D19981AA7BE'
  checksumType      =   'sha256'
}

Install-ChocolateyZipPackage @packageArgs
