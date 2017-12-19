$ErrorActionPreference = 'Stop'

$chromium_string = "\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Chromium"
$hive = "hkcu"
$Chromium = $hive + ":" + $chromium_string

if (Test-Path $Chromium) {
  $silentArgs = '--do-not-launch-chrome'
} else {
  $silentArgs = '--system-level --do-not-launch-chrome'
}


function Get-CompareVersion {
  param(
    [string]$version,
    [string]$notation,
    [string]$package
  )
    $version = $version -replace($notation,"")
    [array]$key = Get-UninstallRegistryKey -SoftwareName "$package*"
    if ($version -eq ( $key.Version )) {
      Write-Host "$package $version is already installed."
      return
    }
  }
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$version = "63.0.3239.108"
if ( Get-ProcessorBits -eq 32 ) {
$file = "chromium_x32.exe.ignore"
} else {
$file = "chromium_x64.exe.ignore" }
New-Item "$toolsDir\$file" -ItemType file
Get-CompareVersion -version $version -notation "-snapshots" -package "chromium"

$packageArgs = @{
  packageName   = 'chromium'
  file          = "$toolsdir\chromium_x32.exe"
  file64        = "$toolsdir\chromium_x64.exe"
  fileType      = 'exe'
  silentArgs    = $silentArgs
  validExitCodes= @(0)
  softwareName  = 'Chromium'
}

Install-ChocolateyInstallPackage @packageArgs
