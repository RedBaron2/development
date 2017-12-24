import-module au
 
function global:au_SearchReplace {
    @{
        "$PSScriptRoot\tools\chocolateyInstall.ps1" = @{
            "(^\s*url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
            "(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
     }
}

function global:au_GetLatest {
$releases = 'http://www.wisecleaner.com/download.html'
$url = "http://downloads.wisecleaner.com/soft/WJS.zip"

$HTML = (Invoke-WebRequest -UseBasicParsing -Uri $releases)
$HTML | foreach { $_ -match '(\d+\.\d+\.\d+)'} | select -first 14 | select -Last 1 
$version = $Matches[0]
$HTML.close

  @{ URL32 = $url -replace 'http:','https:'; Version = $version }
}

update -ChecksumFor 32
