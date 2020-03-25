
import-module au
    $releases = 'https://chromium.woolyss.com/api/v5/?os=win<bit>&type=<type>&out=json'
		$releases_dev = 'https://chromium.woolyss.com/api/v2/?os=windows&bit=<bit>&out=json'
    $ChecksumType = 'sha256'

function global:au_SearchReplace {
  @{
    ".\legal\verification.txt" = @{
    "(?i)(\s*32\-Bit Software.*)\<.*\>"        = "`${1}<$($Latest.URL32)>"
    "(?i)(\s*64\-Bit Software.*)\<.*\>"        = "`${1}<$($Latest.URL64)>"
    "(?i)(^\s*checksum\s*type\:).*"            = "`${1} $($Latest.ChecksumType32)"
    "(?i)(^\s*checksum32\:).*"                 = "`${1} $($Latest.Checksum32)"
    "(?i)(^\s*checksum64\:).*"                 = "`${1} $($Latest.Checksum64)"
    }
    ".\tools\chocolateyInstall.ps1" = @{
    '(^[$]version\s*=\s*)(".*")'               = "`$1""$($Latest.Version)"""
		"(?i)(^\s*file\s*=\s*`"[$]toolsdir\\).*"   = "`${1}$($Latest.FileName32)`""
		"(?i)(^\s*file64\s*=\s*`"[$]toolsdir\\).*" = "`${1}$($Latest.FileName64)`""
    }
    ".\chromium.nuspec" = @{
    "(?i)(^\s*\<title\>).*(\<\/title\>)"       = "`${1}$($Latest.Title)`${2}"
    }
  }
}

function global:au_BeforeUpdate {
    Get-RemoteFiles -Purge -FileNameBase "$($Latest.PackageName)"
}

function Get-Chromium {
param(
	[string]$releases,
	[string]$Title,
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('dev-official','stable-sync','stable-nosync-arm')]
    [string]$type = 'dev-official'
)
    $releases = $releases -replace('<type>', $type )
    $releases_x32 = $releases -replace('<bit>','32')
    $releases_x64 = $releases -replace('<bit>','64')
    $download_page32 = Invoke-WebRequest -Uri $releases_x32
    $download_page64 = Invoke-WebRequest -Uri $releases_x64
    
    $chromium32 = $download_page32 | ConvertFrom-Json
    $chromium64 = $download_page64 | ConvertFrom-Json

    $version32 = $chromium32.chromium.windows.version
    $version64 = $chromium64.chromium.windows.version
    $revision32 = $chromium32.chromium.windows.revision
    $revision64 = $chromium64.chromium.windows.revision
    
    $build = @{$true="-snapshots";$false=""}[ $type -eq 'dev-official' ]

    $version = $version64 + $build
    if (($type -eq 'dev-official') -and ($revision32 -ne $revision64)) {
    $url32 = $chromium64.chromium.windows.download -replace('_x64','')
    } else {
    $url32 = $chromium32.chromium.windows.download
    }
    $url64 = $chromium64.chromium.windows.download
    
    $Pre_Url = 'https://storage.googleapis.com/chromium-browser-snapshots/'
    if ( [string]::IsNullOrEmpty($url32) ) { 
    $url32 = $Pre_Url+"Win/<revision>/mini_installer.exe"
    $url32 = $url32 -replace '<revision>', $revision32
    }
    if ( [string]::IsNullOrEmpty($url64) ) {
    $url64 = $Pre_Url+"Win_x64/<revision>/mini_installer.exe"
    $url64 = $url64 -replace '<revision>', $revision64
    }
    
	@{
		Title = $Title
		URL32 = $url32
		URL64 = $url64
		Version = $version
		ChecksumType32 = $ChecksumType
		ChecksumType64 = $ChecksumType
	}
}

function global:au_GetLatest {
  $streams = [ordered] @{
    stable = Get-Chromium -releases $releases -Title "Chromium" -type "stable-sync"
    snapshots = Get-Chromium -releases $releases_dev -Title "Chromium Snapshots"
  }

  return @{ Streams = $streams }
}


update -ChecksumFor none
