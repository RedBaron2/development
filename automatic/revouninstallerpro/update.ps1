
import-module au

$releases = 'http://www.revouninstaller.com/revo_uninstaller_free_download.html'

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(^\s*url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
      "(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      "(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
  }
}

function global:au_GetLatest {
$HTML = Invoke-WebRequest -UseBasicParsing -Uri $releases
$vlink = $HTML.Links | where{ ($_.href -match "revo_uninstaller_pro_full_version_history" ) } | select-object -first 1
$dlink = $HTML.Links | where{ ($_.href -match "download-professional" ) } | select-object -first 1
$url = 'http://' + (([System.Uri] $releases ).Host) + '/' + $dlink.href
$regex = '(\d(\.\d)*)'
$vlink -match $regex
$version = $Matches[0]
$HTML.close
  return @{ URL32 = $url; Version = $version; }
}

update -ChecksumFor 32
