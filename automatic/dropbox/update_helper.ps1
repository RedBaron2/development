
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
	$version = ( $build | Select -First 1 )
	write-host "version -$version-"
	write-host "zero of version" + $version[0] + "OO"
	return $version
}

