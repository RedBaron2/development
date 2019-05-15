$ErrorActionPreference = 'Stop';

$pp = Get-PackageParameters
# Checking for Package Parameters
if (!$pp['UnzipLocation']) { $pp['UnzipLocation'] = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = '7z'
  url            = ''
  url64          = ''
  UnzipLocation	 = $pp.UnzipLocation
  softwareName   = 'FreeCAD*'
  checksum       = ''
  checksumType   = 'sha256'
  checksum64     = ''
  checksumType64 = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

$fileName = @{$true=($packageArgs.url);$false=($packageArgs.url64)}[ ((Get-OSBitness) -eq 32) ]
$filename = $fileName -split('/')
$filename = ( $filename[-1] )
$extension = $filename -split('\.') | select -Last 1
$filename = ( $filename -replace( "\.$extension", '' ) )

if (!$pp['WorkingDirectory']) { $pp['WorkingDirectory'] = $pp.UnzipLocation+"\$filename" }
if (!$pp['TargetPath']) { $pp['TargetPath'] = $pp['WorkingDirectory']+"\bin\${env:ChocolateyPackageTitle}.exe" }
if (!$pp['IconLocation']) { $pp['IconLocation'] = $pp['TargetPath'] }
if (!$pp['Arguments']) { $pp['Arguments'] = "" }
if (!$pp['ShortcutFilePath']) { $pp['ShortcutFilePath'] = ( [Environment]::GetFolderPath('Desktop') )+"\${env:ChocolateyPackageTitle}.lnk" }
if (!$pp['Shortcut']) { $pp['Shortcut'] = $true }
if (!$pp['WindowStyle']) { $pp['WindowStyle'] = 1 }


$packageParams = @{
  ShortcutFilePath = $pp.ShortcutFilePath
  TargetPath = $pp.TargetPath
  WorkingDirectory = $pp.WorkingDirect
  Arguments = $pp.Arguments
  IconLocation = $pp.IconLocation
  Description = "FreeCAD Development ${env:ChocolateyPackageVersion}"
  WindowStyle = $pp.WindowStyle
}

if ($pp['Taskbar']) { $packageParams.Add( 'PinToTaskbar', $true ) }
if ($pp['Admin']) {  $packageParams.Add( 'RunAsAdmin', $true ) }

if ( $packageArgs.filetype -eq '7z' ) {
Install-ChocolateyZipPackage @packageArgs
if ( $pp.Shortcut ) { Install-ChocolateyShortcut @packageParams }
} else {
Install-ChocolateyPackage @packageArgs
}
