$ErrorActionPreference = "silentlycontinue"
$releases = 'https://www.dropboxforum.com/t5/Desktop-client-builds/bd-p/101003016'

$drpbx_log = "${env:temp}\drpbx.log"
$HTML = ( Invoke-WebRequest -UseBasicParsing -Uri $releases ).Links | Out-File $drpbx_log
$stable_builds = @()
$beta_builds = @()
#$HTML.Links | foreach {
$file_links = ( Get-Content $drpbx_log )
$file_links | foreach {
if ($_ -match "stable" ) {
$stable_builds += $_
}
if ($_ -match "beta" ) {
$beta_builds += $_
}
}
$re_dash = '-'
$re_dashndigits = "\-\D+"
$re_t5 = 't5'
$re_abc = '[a-z]\w+'
$re_num_M = '\d+\#[M]\d+'
$re_dot = '.'
$re_non = ''
$re_stable = 'Stable-'
$re_beta = 'Beta-'
$re_build = 'Build-'
function stable-builds() {
$Stable_latestVersion = $stable_builds
$Stable_latestVersion = $Stable_latestVersion -split ( '\/' )
#$stable = $Stable_latestVersion[3]
$stable = @()
    foreach( $_ in $Stable_latestVersion ) {
    $_ = $_ -replace ( ($re_stable + $re_build), $re_non ) -replace ( $re_dashndigits , $re_non ) -replace ( $re_dash , $re_dot ) -replace ( $re_t5 , $re_non ) -replace ( $re_abc , $re_non ) -replace ( $re_num_M , $re_non ) -replace ('m', $re_non )
            if (( $_ -ge '27.3.21' ) -and ( $_ -le (beta-builds) )) {
            $stable = $_
            #Write-Host "we are .$_. "
            break;
            }
    }
	return $stable
}
function beta-builds() {
$Beta_latestVersion = $beta_builds
$Beta_latestVersion = $Beta_latestVersion -split ( '\/' )
$beta = @()
	foreach( $_ in $Beta_latestVersion ) {
	$_ = $_ -replace ( ($re_beta + $re_build), $re_non ) -replace ( $re_dashndigits , $re_non ) -replace ($re_dash , $re_dot ) -replace ( $re_t5 , $re_non ) -replace ($re_abc  , $re_non ) -replace ( $re_num_M , $re_non )
	   if ( $_ -ge '27.3.21' ) {
			if ( $_ -match '(\d+\.)?(\d+\.)?(\*|\d+)') {
			$beta = $_
			#Write-Host "we are .$_. "
			break;
			}
		}
	}
	return $beta
}

Write-Host stable (stable-builds) beta (beta-builds)

$HTML.close
Write-Host "17-06-07 stable 27.4.22"
Write-Host "17-06-07 beta 28.3.12"
