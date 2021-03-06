import-module au

function global:au_SearchReplace {
    @{
        "$PSScriptRoot\tools\chocolateyInstall.ps1" = @{
            "(^\s*url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
            "(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
		".\windowsrepair.nuspec" = @{
		  "(?i)(^\s*\<title\>).*(\<\/title\>)" = "`${1}$($Latest.Title)`${2}"
		}
     }
}

function Wiggins {
param(
	[string]$releases,
	[string]$PackageName,
	[string]$Title,
	[string]$fileExt
)
$null = .{
    $fileName = "tweaking.com_windows_repair_aio${fileExt}"
    $regex = '([\d]{0,4}[\.][\d]{0,4}[\.][\d]{0,4})';
    $test = Invoke-WebRequest $releases -UseBasicParsing
    $version = ( $test.Content -split $regex ) | select -First 10 | Select -last 7 | Select -First 1
    $test.close
    $url = "http://www.tweaking.com/files/setups/${fileName}"
    }
    @{
		PackageName = $PackageName
		Title = $Title
		Version = $version
		URL32 = $url
    }
	return
}
	
	$ChkUrl = 'https://www.tweaking.com/articles/pagesprinter/tweaking_com_windows_repair_change_log,1.html'

function global:au_GetLatest {

  $streams = [ordered] @{
    portable = Wiggins -releases $ChkUrl -PackageName "windowsrepair.portable" -Title "Windows Repair Portable" -fileExt ".zip"
    install = Wiggins -releases $ChkUrl -PackageName "windowsrepair" -Title "Windows Repair" -fileExt "_setup.exe"
  }

  return @{ Streams = $streams }
}

update -ChecksumFor 32
