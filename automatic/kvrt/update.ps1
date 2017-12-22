
import-module au
 # . "$PSScriptRoot\..\kav\update_helper.ps1"


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

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(^[$]url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
      "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
  }
}

function global:au_GetLatest {
 
$PreURL = 'https://usa.kaspersky.com/downloads/thank-you'
$PackageUrl = "${PreURL}/free-virus-removal-tool"
$regex = '(kvrt)'
$url = $PackageUrl
$ie = New-Object -comobject InternetExplorer.Application
$ie.Navigate2($url) 
$ie.Visible = $false
while($ie.ReadyState -ne 3) {
 start-sleep -Seconds 20
} 
    foreach ( $_ in $ie.Document.getElementsByTagName("a") ) {
     $url = $_.href;
         if ( $url -match $regex) {
            $yes = $url | select -last 1
            # $version = $Matches[0]
            # $the_match = $yes -match( $rev_regex );
            # $revision = $Matches[0];
            break;
        }
    }
$ie.quit()
# Write-Host "this is the yes -$yes-"

$version = (Get-FileVersion -url $url)
# write-host "D version -$version-"
	@{
		fileType	= 'exe'
		URL32		= $yes
		Version		= $version
    }
    # Write-Host "heading to before update, eh"
}
update
