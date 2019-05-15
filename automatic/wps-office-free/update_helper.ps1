

function Get-PackageName() {
param(
    [string]$a
)

switch -w ( $a ) {

	'wps-office-free' {
		$PackageUrl = "https://www.wps.com/en-US/office/windows/"
	}
	
}

return $PackageUrl

}

function Get-JavaSiteUpdates {
# $wait number can be adjusted per the package needs
 param(
  [string]$package,
  [string]$Title,
  [string]$padVersionUnder = '10.2.1',
  [string]$wait = 4
 )
 
$regex = '([\d]{0,2}[\.][\d]{0,2}[\.][\d]{0,2}[\.][\d]{0,5})'
$url = Get-PackageName $package
$ie = New-Object -comobject InternetExplorer.Application
$ie.Navigate2($url) 
$ie.Visible = $false
while($ie.ReadyState -ne $wait) {
 start-sleep -Seconds 20
}
  
    foreach ( $_ in $ie.Document.getElementsByTagName("a") ) {
     $url = $_.href;
         if ( $url -match $regex) {
            $yes = $url | select -last 1
            $version = $Matches[0]
            break;
        }
    }
$ie.quit()
$version = $version

	@{    
		PackageName = $package
		Title       = $Title
		fileType    = 'exe'
		Version		= Get-FixVersion $version -OnlyFixBelowVersion $padVersionUnder
		URL32		= $yes
    }

}
