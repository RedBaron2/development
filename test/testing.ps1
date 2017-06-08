
$releases = 'https://www.dropboxforum.com/t5/Desktop-client-builds/bd-p/101003016'

$HTML = Invoke-WebRequest -UseBasicParsing -Uri $releases
$stable_builds = @()
$beta_builds = @()
$HTML.Links | foreach {
if ($_.href -match "stable" ) {
$stable_builds += $_.href
}
if ($_.href -match "beta" ) {
$beta_builds += $_.href
}
}
#Write-Host $beta_builds[2]
function stable-builds() {
$Stable_latestVersion = $stable_builds
$Stable_latestVersion = $Stable_latestVersion -split ( '\/' )
#$stable = $Stable_latestVersion[3]
$stable = @()
    foreach( $_ in $Stable_latestVersion ) {
    $_ = $_ -replace ('Stable-Build-', '' )
    $_ = $_ -replace ("\-\D+",'')
    $_ = $_ -replace ('-', '.')
    $_ = $_ -replace ('t5','')
    $_ = $_ -replace ('m','')
    $_ = $_ -replace ('[a-z]\w+','')
    $_ = $_ -replace ('\d+\#[M]\d+','')
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
	$_ = $_ -replace ('Beta-Build-', '' )
	$_ = $_ -replace ("\-\D+",'')
	$_ = $_ -replace ('-', '.')
	$_ = $_ -replace ('t5','')
	$_ = $_ -replace ('[a-z]\w+','')
	$_ = $_ -replace ('\d+\#[M]\d+','')
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
