$ErrorActionPreference = 'Stop';

$fileName32 = ''
$fileName64 = ''
$fileName = @{$true=($fileName32);$false=($fileName64)}[ ((Get-OSBitness) -eq 32) ]
$filename = $fileName -split('/')
$filename = ( $filename[-1] )
$extension = $filename -split('\.') | select -Last 1
$filename = ( $filename -replace( "\.$extension", '' ) )

$pp = Get-PackageParameters
# Checking for Package Parameters
if (!$pp['UnzipLocation']) { $pp['UnzipLocation'] = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)\\$filename" }
if (!$pp['WorkingDirectory']) { $pp['WorkingDirectory'] = $pp.UnzipLocation }
if (!$pp['TargetPath']) { $pp['TargetPath'] = $pp['WorkingDirectory']+"\bin\${env:ChocolateyPackageTitle}.exe" }
if (!$pp['IconLocation']) { $pp['IconLocation'] = $pp['TargetPath'] }
if (!$pp['Arguments']) { $pp['Arguments'] = "" }
if (!$pp['ShortcutFilePath']) { $pp['ShortcutFilePath'] = ( [Environment]::GetFolderPath('Desktop') )+"\${env:ChocolateyPackageTitle}.lnk" }
if (!$pp['Shortcut']) { $pp['Shortcut'] = $true }
if (!$pp['WindowStyle']) { $pp['WindowStyle'] = 1 }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = '7z'
  url            = 'https://github.com/FreeCAD/FreeCAD/releases/download/0.19_pre/FreeCAD_0.19.16653_x86_LP_11.11_PY2QT4-WinVS2013.7z'
  url64          = 'https://github.com/FreeCAD/FreeCAD/releases/download/0.19_pre/FreeCAD_0.19.16653_x64_Conda_Py3QT5-WinVS2015.7z'
  UnzipLocation	 = $pp.UnzipLocation
  softwareName   = 'FreeCAD*'
  checksum       = '73d82746dae8b5d228cd769e7d75c0dcef735cacf4c8978850ebfd072a2326b3'
  checksumType   = 'sha256'
  checksum64     = '0c7fbfed56d428b4572584ee34c9ab1d3473fe69f1856f122fec80ecfe19e083'
  checksumType64 = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

$packageParams = @{
  ShortcutFilePath = $pp.ShortcutFilePath
  TargetPath = $pp.TargetPath
  WorkingDirectory = $pp.WorkingDirect
  Arguments = $pp.Arguments
  IconLocation = $pp.IconLocation
  Description = "FreeCAD Development ${env:ChocolateyPackageVersion}"
  WindowStyle = $pp.WindowStyle
}
if ($pp['Taskbar']) { $packageParams.Add('PinToTaskbar', '') }
if ($pp['Admin']) {  $packageParams.Add('RunAsAdmin','') }

if ( $packageArgs.filetype -eq '7z' ) {
Install-ChocolateyZipPackage @packageArgs
if ( $pp.Shortcut ) { Install-ChocolateyShortcut @packageParams }
} else {
Install-ChocolateyPackage @packageArgs
}
