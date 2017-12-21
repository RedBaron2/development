
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
        }
  }
}


function Get-KasperskyUpdates {
 param(
	[string]$package,
    [string]$Title
 )
 
# terminator ielowutil
# sleep 5
# terminator iexplore
 
$regex = '([\d]{0,2}[\.][\d]{0,2}[\.][\d]{0,2}[\.][\d]{0,3})'
$rev_regex = '([\d+]{5})';
$url = Get-KasperskyPackageName $package
if ( $url -match 'free' ) { $wait = 3 } else { $wait = 4 }
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
            $the_match = $yes -match( $rev_regex );
            $revision = $Matches[0];
            break;
        }
    }
# $clnt = new-object System.Net.WebClient
# $clnt.OpenRead($yes) | Out-Null
# $filesize = $clnt.ResponseHeaders["Content-Length"]

# if ( $filesize -lt 104857600 ) { write-host "$package -$filesize-"; $clnt.quit(); break; }
$ie.quit()
$version = $version + $revision


	@{    
		PackageName = $package
		Title       = $Title
		fileType    = 'exe'
		Version		= $version
		URL32		= $yes
    }

}

function global:au_GetLatest {
  $streams = [ordered] @{
    kav = Get-KasperskyUpdates -package kav -Title "Kaspersky Anti-Virus"
    kis = Get-KasperskyUpdates -package kis -Title "Kaspersky Internet Security"
    kts = Get-KasperskyUpdates -package kts -Title "Kaspersky Total Security"
    # kfa = Get-KasperskyUpdates -package kfa -Title "Kaspersky Free"
  }

  return @{ Streams = $streams }
}

update