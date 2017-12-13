
import-module au

function global:au_BeforeUpdate {
  if ($Latest.Title -like '*essential*') {
    cp "$PSScriptRoot\README_tse.md" "$PSScriptRoot\README.md" -Force
  } else {
    cp "$PSScriptRoot\README_ts.md" "$PSScriptRoot\README.md" -Force
  }
}

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(^\s*packageName\s*=\s*)('.*')" = "`$1'$($Latest.PackageName)'"
      "(^\s*url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
      "(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      "(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
      "(^\s*softwareName\s*=\s*)('.*')" = "`$1'$($Latest.Title)'"
    }
    ".\360ts.nuspec" = @{
      "(?i)(^\s*\<title\>).*(\<\/title\>)" = "`${1}$($Latest.Title)`${2}"
    }
  }
}

function Get360Version {
param(
	[string]$releases,
	[string]$PackageName,
	[string]$Title
)
  $HTML = Invoke-WebRequest -UseBasicParsing -Uri $releases
  $url = $HTML.Links | ? href -match "\.exe$" | select -first 1 -expand href
  $version = $url -split '_|(\.exe)' | select -last 1 -skip 2

  $url = 'https:' + $url
 @{
    PackageName = $PackageName
    Title = $Title
    Version = $version
    URL32   = $url
  }
}

$360tsURL = 'https://www.360totalsecurity.com/en/download-free-antivirus/360-total-security/?offline=1'
$360tseURL = 'https://www.360totalsecurity.com/en/download-free-antivirus/360-total-security-essential/?offline=1'

function global:au_GetLatest {
  $streams = [ordered] @{
    tse = Get360Version -releases $360tseURL -PackageName "360tse" -Title "360 Total Security Essential"
    ts = Get360Version -releases $360tsURL -PackageName "360ts" -Title "360 Total Security"
  }

  return @{ Streams = $streams }
}

update -ChecksumFor 32
