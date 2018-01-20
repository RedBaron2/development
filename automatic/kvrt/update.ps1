
import-module au
 . "$PSScriptRoot\..\kaspersky\update_helper.ps1"

function global:au_BeforeUpdate {
	Remove-Item ".\tools\*.exe" -Force # Removal of downloaded files
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
  $streams = [ordered] @{
    kvrt = Get-KasperskyUpdates -package kvrt -Title "Kaspersky Virus Removal Tool" -wait 3
  }

  return @{ Streams = $streams }
}
update -ChecksumFor none
