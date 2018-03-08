import-module au
 
function global:au_BeforeUpdate {
    cp "$PSScriptRoot\README.$($Latest.PackageName).md" "$PSScriptRoot\README.md" -Force
}

function global:au_SearchReplace {
    @{
        "$PSScriptRoot\tools\chocolateyInstall.ps1" = @{
            "(^\s*url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
            "(^\s*fileType\s*=\s*)('.*')" = "`$1'$($Latest.fileType)'"
            "(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
		".\wise.nuspec" = @{
			"(?i)(^\s*\<title\>).*(\<\/title\>)" = "`${1}$($Latest.Title)`${2}"
        }
     }
}

  $releases = 'http://www.wisecleaner.com/download.html'
  $url = 'https://downloads.wisecleaner.com/soft'
function Wiggins {
param(
	[string]$fileName,
	[string]$exactName,
	[string]$Title,
    [string]$place,
    [string]$regex
)
$null = .{
	$pos = $fileName.IndexOf(".")
	$URL = "$url/$fileName"
	$HTML = Invoke-WebRequest $releases -UseBasicParsing
	$newt = ( $HTML.links | Where { ($_.href -match $exactName )} ).outerHTML | select -Last 3
    $step = $newt[$place]
	$HTML.close; $ver = $step -match $regex; $version = $Matches[0]
	$portable = @{$true=".portable";$false=".install"}[ ($fileName.Substring($pos+1)) -eq 'zip' ]
	$propername = @{$true=($fileName.Substring(0,$pos) -replace 'Setup');$false=($fileName.Substring(0,$pos))}[ ($fileName.Substring(0,$pos)) -match 'setup' ]
}
   	@{    
		PackageName = $propername + $portable
		Title       = $Title
		fileType    = $fileName.Substring($pos+1)
		Version     = $version
		URL32       = $url
    }
}

function global:au_GetLatest {
  $streams = [ordered] @{
    wisecare365 = Wiggins -fileName 'WiseCare365.exe' -exactName 'wise-care-365' -Title 'Wise Care 365' -place '0' -regex '(\d+\.\d+\.\d+)'
    wisecare365portable = Wiggins -fileName 'WiseCare365.zip' -exactName 'wise-care-365' -Title 'Wise Care 365 Portable' -place '0' -regex '(\d+\.\d+\.\d+)'
    wjs = Wiggins -fileName 'WJSSetup.exe' -exactName 'JetSearch' -Title 'Wise JetSearch' -place '1' -regex '((\d+\.?){3})'
    wjsportable = Wiggins -fileName 'WJS.zip' -exactName 'JetSearch' -Title 'Wise JetSearch Portable' -place '1' -regex '((\d+\.?){3})'
    wpu = Wiggins -fileName 'WPUSetup.exe' -exactName 'wise-program-uninstaller' -Title 'Wise Program Uninstaller' -place '1' -regex '((\d+\.?){3})'
    wpuportable = Wiggins -fileName 'WPU.zip' -exactName 'wise-program-uninstaller' -Title 'Wise Program Uninstaller' -place '1' -regex '((\d+\.?){3})'
  }

  return @{ Streams = $streams }
}

update -ChecksumFor 32