
import-module au
 . ".\update_helper.ps1"

function global:au_BeforeUpdate {
    cp "$PSScriptRoot\README.$($Latest.PackageName).md" "$PSScriptRoot\README.md" -Force
}

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(^[$]packageName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)'"
      "(^[$]installerType\s*=\s*)('.*')" = "`$1'$($Latest.fileType)'"
      "(^[$]url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
      "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
    ".\tools\chocolateyUninstall.ps1" = @{
      "(^[$]packageName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)'"
      "(^[$]packageSearch\s*=\s*)('.*')" = "`$1'$($Latest.Title)'"
      "(^[$]installerType\s*=\s*)('.*')" = "`$1'$($Latest.fileType)'"
    }
    ".\kaspersky.nuspec" = @{
      "(?i)(^\s*\<title\>).*(\<\/title\>)" = "`${1}$($Latest.Title)`${2}"
      "(\<dependency .+?`"$($Latest.packageName)`" version=)`"([^`"]+)`"" = "`$1`"$($Latest.baseVersion)`""
        }
  }
}


function global:au_GetLatest {
  $streams = [ordered] @{
    kav = Get-KasperskyUpdates -package kav -Title "Kaspersky Anti-Virus"
    kis = Get-KasperskyUpdates -package kis -Title "Kaspersky Internet Security"
    kts = Get-KasperskyUpdates -package kts -Title "Kaspersky Total Security"
    kfa = Get-KasperskyUpdates -package kfa -Title "Kaspersky Free"
    kvrt = Get-KasperskyUpdates -package kvrt -Title "Kaspersky Virus Removal Tool"
  }

  return @{ Streams = $streams }
}

update -ChecksumFor 32
