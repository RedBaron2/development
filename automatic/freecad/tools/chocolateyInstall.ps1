$ErrorActionPreference = 'Stop';

 if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
. "$PSScriptRoot\helper.ps1"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = '7z'
  url            = ''
  url64          = 'https://github.com/FreeCAD/FreeCAD/releases/download/0.19_pre/FreeCAD_0.19.19093_x64_Conda_Py3QT5-WinVS2015.7z'
  softwareName   = 'FreeCAD*'
  checksum       = ''
  checksumType   = ''
  checksum64     = '5F82D81FD6B2CC4CA898FF28F711FA360920E783BE408A6B0C885C19B0CFF754'
  checksumType64 = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

if ( $packageArgs.filetype -eq '7z' ) {
  # Checking for Package Parameters
  $pp = ( Get-UserPackageParams -scrawl )
  if ($pp.UnzipLocation) { $packageArgs.Add( "UnzipLocation", $pp.UnzipLocation ) }
  Install-ChocolateyZipPackage @packageArgs
  if ($pp.Shortcut) { Install-ChocolateyShortcut @pp }
  $files = get-childitem $pp.WorkingDirectory -Exclude $packageArgs.softwareName -include *.exe -recurse
  foreach ($file in $files) {
    # Generate an ignore file(s)
    New-Item "$file.ignore" -type file -force | Out-Null
  }
} else {
  Install-ChocolateyPackage @packageArgs
}
