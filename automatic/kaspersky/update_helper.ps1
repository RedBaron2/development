
function Get-KasperskyPackageName() {
param(
    [string]$a
)

$Domain = 'https://usa.kaspersky.com'
$PreURL = '${Domain}/downloads/thank-you'
switch -w ( $a ) {

    'kfa' {
        $PackageUrl = "${PreURL}/free-antivirus-download"
    }
    'kav' {
        $PackageUrl = "${PreURL}/antivirus"
    }
    'kts' {
        $PackageUrl = "${PreURL}/total-security"
    }
    'kis' {
        $PackageUrl = "${PreURL}/internet-security"
    }
	'kvrt' {
		$PackageUrl = "${PreURL}/free-virus-removal-tool"
	}
	'kss' {
		$PackageUrl = "${Domain}/free-virus-scan"
	}



}

return $PackageUrl

}

$OS_caption = ( Get-CimInstance win32_operatingsystem -Property Caption )
$check = @{$true=$true;$false=$false}[ ( $OS_caption -match 'Server' ) ]

function Get-KasperskyUpdates {
 param(
	[string]$package,
    [string]$Title,
    [string]$wait = 4
 )

$null = .{
$regex = '([\d]{0,2}[\.][\d]{0,2}[\.][\d]{0,2}[\.][\d]{0,3})'
$rev_regex = '([\d+]{5})';
$url = Get-KasperskyPackageName $package
$ie = New-Object -comobject InternetExplorer.Application
$ie.Navigate2($url)
$ie.Visible = $false
while($ie.ReadyState -ne $wait) {
 start-sleep -Seconds 20
}
	if ( $check ) {
		$urls = $ie.Document.IHTMLDocument3_getElementsByTagName("a") | % { $_.href } | where { $_ -match $regex } | select -First 1
	} else {
		$urls = $ie.Document.getElementsByTagName("a") | % { $_.href } | where { $_ -match $regex } | select -First 1
	}

$base_version = $Matches[0]
	if (($base_version -eq '') -or ($base_version -eq '')) { 
	$the_match = $urls -match( $rev_regex );
	$revision = $Matches[0];
	$ie.quit()
	$version = $base_version + $revision
		$result = @{    
			PackageName = $package
			Title       = $Title
			fileType    = 'exe'
			Version		= $version
			baseVersion	= $base_version
			URL32		= $urls
		}
	} else {
	  $etag = GetETagIfChanged $url32
	  if ($etag) {
		$result = GetResultInformation -url32 $url32 -file "kvrt.exe"
		$result["ETAG"] = $etag
	  } else {
		$result = @{
			fileType	= 'exe'
			URL32   = $url32
			Version = Get-Content "$PSScriptRoot\info" -Encoding UTF8 | select -First 1 | % { $_ -split '\|' } | select -Last 1
		}
	  }
	}
	  return $result
}


}
function GetETagIfChanged() {
  param([string]$url)

  if (($global:au_Force -ne $true) -and (Test-Path $PSScriptRoot\info)) {
    $existingETag = Get-Content "$PSScriptRoot\info" -Encoding "UTF8" | Select -First 1 | Foreach { $_ -split '\|' } | Select -First 1
  }
  else {
    $existingETag = $null
  }

  $etag = Invoke-WebRequest -Method Head -Uri $url -UseBasicParsing
  $etag = $etag | Foreach { $_.Headers.ETag }
  if ($etag -eq $existingETag) { return $null }

  return $etag
}

function GetResultInformation() {
  param([string]$url32,[string]$file)

  $dest = "$env:TEMP\$file"
  Invoke-WebRequest -UseBasicParsing -Uri $url32 -OutFile $dest
  $version = Get-Item $dest | Foreach { $_.VersionInfo.ProductVersion -replace '^(\d+(\.[\d]+){1,3}).*', '$1' }

  $result = @{
    URL32          = $url32
    Version        = $version
    Checksum32     = Get-FileHash $dest -Algorithm "SHA256" | Foreach Hash
    ChecksumType32 = 'sha256'
  }
  Remove-Item -Force $dest
  return $result
}
