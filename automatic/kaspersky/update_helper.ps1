
function Get-KasperskyPackageName() {
param(
    [string]$a
)

$PreURL = 'https://usa.kaspersky.com/downloads/thank-you'
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



}

return $PackageUrl

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
	PackageName = $package
    URL32          = $url32
    Version        = $version
    Checksum32     = Get-FileHash $dest -Algorithm "SHA256" | Foreach Hash
    ChecksumType32 = 'sha256'
  }
  Remove-Item -Force $dest
  return $result
}

function Get-KasperskyUpdates {
 param(
	[string]$package,
    [string]$Title,
    [string]$wait = 4
 )

$null = .{
$OS_caption = ( Get-CimInstance win32_operatingsystem -Property Caption )
$check = @{$true=$true;$false=$false}[ ( $OS_caption -match 'Server' ) ]
$regex_kav = '([\d]{0,2}[\.][\d]{0,2}[\.][\d]{0,2}[\.][\d]{0,3})'
$regex_kvrt = '(kvrt)'
$regex = @{$true=$regex_kvrt;$false=$regex_kav}[ $package -eq 'kvrt' ]
$rev_regex = '([\d+]{5})';
$url = Get-KasperskyPackageName $package
$ie = New-Object -comobject InternetExplorer.Application
$ie.Navigate2($url)
$ie.Visible = $false
while($ie.ReadyState -ne $wait) {
 start-sleep -Seconds 20
}
	if ( $check ) {
		$url32 = $ie.Document.IHTMLDocument3_getElementsByTagName("a") | % { $_.href } | where { $_ -match $regex } | select -First 1
	} else {
		$url32 = $ie.Document.getElementsByTagName("a") | % { $_.href } | where { $_ -match $regex } | select -First 1
	}

	$base_version = $Matches[0]
	if ($package -ne 'kvrt') { 
	$the_match = $url32 -match( $rev_regex );
	$revision = $Matches[0];
	$ie.quit()
	$version = $base_version + $revision
		$result = @{    
			PackageName = $package
			Title       = $Title
			fileType    = 'exe'
			Version		= $version
			baseVersion	= $base_version
			URL32		= $url32
		}
	} else {
	  $etag = GetETagIfChanged $url32
	  if ($etag) {
		$result = GetResultInformation -url32 $url32 -file "${package}.exe"
		$result["ETAG"] = $etag
	  } else {
		$result = @{    
			PackageName = $package
			fileType = 'exe'
			URL32 = $url32
			Version = Get-Content "$PSScriptRoot\info" -Encoding UTF8 | select -First 1 | % { $_ -split '\|' } | select -Last 1
		}
	  }
	}
}
	  return $result


}
