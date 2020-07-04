
import-module au
$releases = 'https://www.wagnardsoft.com/forums/viewforum.php?f=5&sid=103e37af8e874ed0b0c2966afa5edac4'
$headers = @{ "Accept-Encoding"="gzip, deflate, br"; "Accept-Language"="en-US,en;q=0.9"
  "Cookie"="has_js=1; cookie-agreed=2; phpbbwagnardsoft_u=1; phpbbwagnardsoft_k=; phpbbwagnardsoft_sid=dd0e2f5bcec548ecf35a899aafb05f81"
  }
  
function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(^\s*\s*url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
      "(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      "(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
      "(^\s*\s*referer\s*=\s*)('.*')" = "`$1'$($Latest.Referer)'"
    }
  }
}

function global:au_GetLatest {
  $regex = '(\d+\.\d+\.\d+\.\d+)'
  $HTML =  (Invoke-WebRequest -UseBasicParsing -Uri $releases).Links | where {($_ -match $regex)} | select -First 1
  $version = $Matches[0];
  $HTML -match "(?:t=)\d+" | Out-Null; $thread= $Matches[0];
  $referer = "https://www.wagnardsoft.com/forums/viewtopic.php?f=5&${thread}"
  $headers.Add( "Referer", $referer )
  $url = "https://www.wagnardsoft.com/DDU/download/DDU%20V${version}.exe"
  $CheckSum = Get-RemoteChecksum -Url $url -Headers $headers
	
  return @{ 
            CheckSum32     = $CheckSum
            ChecksumType32 = "sha256"
            Referer        = $referer
            URL32          = $url
            Version        = $version
	}
}

update -CheckSumFor none
