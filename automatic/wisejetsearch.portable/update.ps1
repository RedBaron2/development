import-module au
 
function global:au_SearchReplace {
    @{
        "$PSScriptRoot\tools\chocolateyInstall.ps1" = @{
            "(^\s*url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
            "(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
     }
}

  $releases = 'http://www.wisecleaner.com/download.html'
  $url = 'https://downloads.wisecleaner.com/soft'
function Wiggins {
param(
	[string]$fileName,
	[string]$exactName,
	[string]$Title
)
$null = .{
	$pos = $fileName.IndexOf(".")
	$URL = "$url/$fileName"
	$HTML = Invoke-WebRequest $releases
	$newt = ( $HTML.ParsedHtml.getElementsByTagName('a') | Where { ($_.className -eq 'product-name') -and ($_.href -match "$exactName" )} | select -Last 1 ).innertext
	$HTML.close
	$version = $newt -replace('([A-Z]\w+\s+)|([\d+]{3}\s)','')
	}
   	@{    
		PackageName = $fileName.Substring(0, $pos)
		Title       = $Title
		fileType    = $fileName.Substring($pos+1)
		Version	    = $version
		URL32	    = $url
    }
}

function global:au_GetLatest {
  $streams = [ordered] @{
   # wisecare365 = Wiggins -fileName 'WiseCare365.zip' -exactName 'wise-care-365' -Title 'Wise Care 365'
    wisejetsearch = Wiggins -fileName 'WJS.zip' -exactName 'jetsearch' -Title 'Wise JetSearch'
  }

  return @{ Streams = $streams }
}

update -ChecksumFor 32
