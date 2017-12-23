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

function global:au_GetLatest {
  $releases = 'http://www.wisecleaner.com/download.html'

Set-Alias posh-tee Write-Host
  $url = "http://downloads.wisecleaner.com/soft/WJS.zip"

 $HTML = Invoke-WebRequest $releases
 $newt = ( $HTML.ParsedHtml.getElementsByTagName('a') | Where { $_.className -eq 'product-name'} | select -first 14 | select -Last 1 ).innertext
 posh-tee $newt
 $HTML.close
 $version = $newt -replace('([A-Z]\w+\s+)|([\d+]{3}\s)','')

  @{ URL32 = $url -replace 'http:','https:'; Version = $version }
}

# update -ChecksumFor 32
update