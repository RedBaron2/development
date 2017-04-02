
import-module au

$releases = 'https://www.dropboxforum.com/t5/Desktop-client-builds/bd-p/101003016'


function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(^[$]version\s*=\s*)('.*')"= "`$1'$($Latest.Version)'"
      "(?i)(^\s*url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
      "(?i)(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
  }
}

function global:au_GetLatest {


$HTML = Invoke-WebRequest -UseBasicParsing -Uri $releases
$links = $HTML.Links | where{ ($_.href -match "stable" ) } | Select -first 1
$link = $links.href -split ( '\/' ) | Select -Last 3 -Skip 2
$ver = $link -replace('(([A-Z])\w+\-)','') | Select -Last 1
$stable = $ver -replace ('-', '.')
$HTML.close
$url = "https://dl-web.dropbox.com/u/17/Dropbox%20${stable}.exe"

  return @{ URL32 = $url; Version = $stable; }
}

update
