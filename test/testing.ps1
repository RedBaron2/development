
$Stopwatch = [system.diagnostics.stopwatch]::StartNew()

function drpbx-compare {
	param(
		[string]$_version,
		[string]$build = 'stable',
		[bool]$_build
	)
    $releases = 'https://www.dropboxforum.com/t5/Desktop-client-builds/bd-p/101003016'
    $weblinks = "${env:temp}\${build}links.txt"
    $HTML = ( Invoke-WebRequest -UseBasicParsing -Uri $releases).Links`
     | where {($_ -match ($build) )} | Select -First 10 | Out-File $weblinks
    $hrefs = ( Get-Content $weblinks )

    $re_dash = '-'; $re_dot = '.'; $re_non = ''; $re_build = $build + "-Build-";
    $version = ( drpbx-builds -hrefs $hrefs -testVersion $_version -_build $_build )
    rm $weblinks
    return $version
}

function drpbx-builds {
	param(
		[string]$default = '27.3.21',
		[string]$hrefs,
		[string]$testVersion,
		[bool]$_build
	)
    $links = $hrefs
    $links = $links -split ( '\/' ); $build = @()
    $regex = @{$true=($re_build);$false=($re_build)}[ ($_build) ]
    foreach( $_ in $links ) {
        foreach( $G in $_ ) {
            if ( $G -match '([\d]{2}[\-]{1}[\d]{1,2}[\-]{1}[\d]{2})' ) {
                $G = $G -replace($regex,$re_non) -replace($re_dash, $re_dot)
                    if ( $G -ge $default ) {
                        if ($_build) {
                            if (( $G -ge $testVersion )) {
                            $build += $G;
                            if (( $build | measure ).Count -ge '6') { $build = ($build | measure -Maximum ).Maximum; break;}
                            }
                        } else {
                            if (( $G -le $testVersion )) {
                            $build += $G;
                            if (( $build | measure ).Count -ge '6') { $build = ($build | measure -Maximum ).Maximum; break;}
                            }
                        }
                    }
                }
            }
    }
	return $build | select -First 1
}

$stable = ( drpbx-compare -_version "29.4.20" )
$beta = ( drpbx-compare -_version "30.3.15" -build "beta" -_build $true )
Write-Host "Stable -$stable- Beta -$beta-"
Write-Host "17-06-07 stable 27.4.22"
Write-Host "17-06-07 beta 28.3.12"
$Stopwatch.Stop()

Write-Host "This script took $($Stopwatch.Elapsed.TotalMinutes) milliseconds to run"
