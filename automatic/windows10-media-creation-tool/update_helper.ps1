function Get-FileVersion {
param(
    [string]$url,
    [string]$file
)
    $regex = "((\d+.\d+.\d+.\d+))"
    $packageName = $($Latest.PackageName)
    if (!(Test-Path "${env:temp}\chocolatey\$packageName" -PathType Container)) {
    New-Item -ItemType Directory "${env:temp}\chocolatey\$packageName" }
    Invoke-WebRequest -Uri $url -OutFile "${env:temp}\chocolatey\$packageName\$file"
    $filer = Get-Item "${env:temp}\chocolatey\$packageName\*.exe" | select -First 1
	$version = $filer.VersionInfo.FileVersion -replace '$regex*','$1' | out-file "${env:temp}\A1.log"
    if (( $version -match " " )) { $like=$true;$version = $version -split(" ") }
    $version = @{$true=$version;$false=$version[0]}[ $version -isnot [system.array] ] | out-file -filepath "${env:temp}\A2.log"
    $version = $version -match $regex | out-file -filepath "${env:temp}\A3.log"
    $version = $Matches[0] | out-file -filepath "${env:temp}\A4.log"
    return $version
}
