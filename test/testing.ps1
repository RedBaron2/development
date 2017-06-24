
$Stopwatch = [system.diagnostics.stopwatch]::StartNew()


function global:au_GetLatest {
    $releases = 'https://www.dropboxforum.com/t5/Desktop-client-builds/bd-p/101003016'
    $HTML = Invoke-WebRequest -UseBasicParsing -Uri $releases
    $stable_builds = @()
    $beta_builds = @()
    $HTML.Links | foreach {
  	  if ($_.href -match "stable" ) { $stable_builds += $_.href }
  	  if ($_.href -match "beta" ) { $beta_builds += $_.href }
    }
    $re_dash = '-'; $re_dashndigits = "\-\D+"; $re_t5 = 't5'; $re_abc = '[a-z]\w+'; $re_num_M = '\d+\#[M]\d+';
    $re_dot = '.'; $re_non = ''; $re_stable = 'Stable-'; $re_beta = 'Beta-'; $re_build = 'Build-';
	$beta_version =  ( drpbx-builds -hrefs $beta_builds -beta_build $true )
	$stable_version = ( drpbx-builds -hrefs $stable_builds -beta_version $beta_version )
    $downloadUrl = "https://dl-web.dropbox.com/u/17/Dropbox%20${stable_version}.exe"
    $beta_downloadUrl = "https://dl-web.dropbox.com/u/17/Dropbox%20${beta_version}.exe"

    return @{ URL32 = $downloadUrl; Version = $stable_version; URL32_b = $beta_downloadUrl; Version_b = $beta_version }
}

function drpbx-builds {
	param(
		[string]$hrefs,
		[string]$beta_version,
		[bool]$beta_build
	)
    $links = $hrefs
    $links = $links -split ( '\/' ); $build = @()
	$build_version = @{$true=($re_beta + $re_build);$false=($re_stable + $re_build)}[( ($beta_build) )]
    foreach( $_ in $links ) {
     $_ = $_ -replace ( ($build_version), $re_non ) -replace ( $re_dashndigits , $re_non ) -replace ($re_dash , $re_dot ) -replace ( $re_t5 , $re_non ) -replace ($re_abc  , $re_non ) -replace ( $re_num_M , $re_non )
		if (( $beta_build )) {
	    if ( $_ -ge '27.3.21' ) {
			if ( $_ -match '(\d+\.)?(\d+\.)?(\*|\d+)') {
			$build = $_
			break;
			}
		}
		} else {
            $_ = $_  -replace ('m', $re_non )
			if (( $_ -ge '27.3.21' ) -and ( $_ -le $beta_version )) {
			$build = $_
			break;
			}
		}
    }
	return $build
}
global:au_GetLatest
Write-Host "17-06-07 stable 27.4.22"
Write-Host "17-06-07 beta 28.3.12"
$Stopwatch.Stop()

Write-Host "This script took $($Stopwatch.Elapsed.TotalMinutes) milliseconds to run"
