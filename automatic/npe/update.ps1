
import-module au

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(^[$]url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
      "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
  }
}


function Get-FileVersion {
param(
    [string]$packageName = $($Latest.PackageName),
    [string]$url,
    [string]$file = "$($Latest.PackageName).exe"
)
    if (!(Test-Path "${env:temp}\chocolatey\$packageName" -PathType Container)) {
    New-Item -ItemType Directory "${env:temp}\chocolatey\$packageName" }
    Invoke-WebRequest -Uri $url -OutFile "${env:temp}\chocolatey\$packageName\$file"
	# write-host "we are going to wait for 10 seconds"
	# sleep 10
	# write-host "done waiting heading out"
    $filer = Get-Item "${env:temp}\chocolatey\$packageName\*.exe" | Select -First 1
	# write-host "filer -$filer-"
	$version = $filer.VersionInfo.FileVersion -replace '((\d+.\d+.\d+.\d+))*','$1'
	# write-host "A version -$version-"
    if (( $version -match " " )) { $like=$true;$version = $version -split(" ") }
	# write-host "B version -$version-"
    $version = @{$true=$version;$false=$version[0]}[ $version -isnot [system.array] ]
	# write-host "C version -$version-"
    return $version
}

function global:au_GetLatest {

$NPE_url = 'https://security.symantec.com/nbrt/npe.aspx'
$fileName = "NPE.exe"


$test = Invoke-WebRequest $NPE_url
$newt = ( $test.ParsedHtml.getElementsByTagName('a') | Where { $_.className -eq 'offset-btn-npenbrt'} ).href;
$toad = $newt | select -First 1
$url = $toad;
$test.close

$version = (Get-FileVersion -url $url -file $fileName)
$version = @{$true=$version;$false=$version[1]}[ $version -isnot [system.array] ]
# write-host "D version -$version-"

	@{
		fileType	= 'exe'
		URL32		= $url
		Version		= $version
    }
}
update -NoCheckChocoVersion
