$ErrorActionPreference = 'Stop'

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
Import-Module (Join-Path $PSScriptRoot 'functions.ps1')
$version = '28.3.12'

$packageArgs = @{
  packageName   = 'dropbox'
  fileType      = 'exe'
  url           = 'https://dl-web.dropbox.com/u/17/Dropbox%2028.3.12.exe'
  silentArgs    = '/S'
  softwareName  = 'Dropbox'
  checksum      = ''
  checksumType  = ''
}

#installer automatically overrides existing PPAPI installation
# Install-ChocolateyPackage @packageArgs
# Variables for the AutoHotkey-script
$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
$ahkFile = "$scriptPath\dropbox.ahk"

$installedVersion = (getDropboxRegProps).DisplayVersion

  if ($installedVersion -ge $version) {
    Write-Host "Dropbox $installedVersion is already installed."
  } else {
	Install-ChocolateyPackage @packageArgs
    Start-Process 'AutoHotkey' $ahkFile
  }

