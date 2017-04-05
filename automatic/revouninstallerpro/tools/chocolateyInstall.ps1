$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName            = 'revouninstallerpro'
  fileType               = 'exe'
  url                    = 'http://www.revouninstaller.com/download-professional-version.php'
  checksum               = 'c227b962eb3798a68b8ef07238269701c9e9c8d1a9198fe527e4165c9cf3c84d'
  checksumType           = 'sha256'
  silentArgs             = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes         = @(0)
  softwareName           = 'Revo Uninstaller Pro'
}
Install-ChocolateyPackage @packageArgs
