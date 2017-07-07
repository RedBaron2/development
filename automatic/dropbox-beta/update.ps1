
import-module au
 . "$PSScriptRoot\..\dropbox\update_helper.ps1"

 # function au_BeforeUpdate() {
    # Download $Latest.URL32 / $Latest.URL64 in tools directory and remove any older installers.
    # Get-RemoteFiles
# }

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

$beta = ( drpbx-compare -_version "30.3.15" -build "beta" -_build $true )

$url = "https://dl-web.dropbox.com/u/17/Dropbox%20${beta}.exe"

 return @{ URL32 = $url; Version = $beta; }

}

update -ChecksumFor 32
