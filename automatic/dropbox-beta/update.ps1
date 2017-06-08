
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

$betaVersionRegEx = '.*Beta-Build-([0-9\.\-]+).*'
$HTML = Invoke-WebRequest -UseBasicParsing -Uri $releases
$beta_builds = @()
$HTML.Links | foreach {
    if ($_.href -match "beta" ) {
    $beta_builds += $_.href
    }
}
$Beta_latestVersion = $beta_builds
$Beta_latestVersion = $Beta_latestVersion -split ( '\/' )
$beta = @()
foreach( $_ in $Beta_latestVersion ) {
$_ = $_ -replace ('Beta-Build-', '' ) 
$_ = $_ -replace ("\-\D+",'')
$_ = $_ -replace ('-', '.')
$_ = $_ -replace ('t5','')
$_ = $_ -replace ('[a-z]\w+','')
$_ = $_ -replace ('\d+\#[M]\d+','')
   if ( $_ -ge '27.3.21' ) {
        if ( $_ -match '(\d+\.)?(\d+\.)?(\*|\d+)') {
        $beta = $_
        break;
        }
    }
}
$HTML.close
$url = "https://dl-web.dropbox.com/u/17/Dropbox%20${beta}.exe"

 return @{ URL32 = $url; Version = $beta; }

}

update -ChecksumFor 32
