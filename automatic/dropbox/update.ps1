
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
$stable_builds = @() # Intialize Stable Array
$beta_builds = @() # Intialize Beta Array
$HTML.Links | foreach {
if ($_.href -match "stable" ) {
$stable_builds += $_.href # Build the Stable Array by Adding all matches
}
if ($_.href -match "beta" ) {
$beta_builds += $_.href # Build the Beta Array by Adding all matches
}
}
$Stable_latestVersion = $stable_builds[0]
$Stable_latestVersion = $Stable_latestVersion -split ( '\/' )
$stable = $Stable_latestVersion[3]
$Beta_latestVersion = $beta_builds[2]
$Beta_latestVersion = $Beta_latestVersion -split ( '\/' )
$beta = $Beta_latestVersion[3]
$stable = $stable -replace ('Stable-Build-', '' )
$stable = $stable -replace ('-', '.')
$beta = $beta -replace ('Beta-Build-', '' )
$beta = $beta -replace ('-', '.')
$HTML.close
$url = "https://dl-web.dropbox.com/u/17/Dropbox%20${stable}.exe"

  return @{ URL32 = $url; Version = $stable; }
}

update -ChecksumFor 32
