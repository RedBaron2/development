import-module au

$PreUrl = 'https://github.com'
$releases = "$PreUrl/FreeCAD/FreeCAD/releases"
$regex = "(\d+\.\d+\.\d+)"
$softwareName = 'FreeCAD*'

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*fileType\s*=\s*)('.*')"       = "`$1'$($Latest.fileType)'"
      "(?i)(^\s*url\s*=\s*)('.*')"            = "`$1'$($Latest.URL32)'"
      "(?i)(^\s*url64\s*=\s*)('.*')"          = "`$1'$($Latest.URL64)'"
      "(?i)(^\s*checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
      "(?i)(^\s*checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
      "(?i)(^\s*checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
      "(?i)(^\s*checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
      "(?i)^(\s*softwareName\s*=\s*)'.*'"     = "`${1}'$softwareName'"
    }
    ".\freecad.nuspec" = @{
      "\<releaseNotes\>.+" = "<releaseNotes>$($Latest.ReleaseNotes)</releaseNotes>"
    }
    ".\tools\chocolateyUninstall.ps1" = @{
      "(?i)^(\s*softwareName\s*=\s*)'.*'" = "`${1}'$softwareName'"
      "(?i)(^\s*fileType\s*=\s*)('.*')"       = "`$1'$($Latest.fileType)'"
    }
  }
}

function Get-FreeCad {
param(
    [string]$bitness,
    [string]$Title,
    [string]$kind
)


  $download_page = Invoke-WebRequest -UseBasicParsing -Uri $releases
  $try = (($download_page.Links | ? href -match "CAD\-|\.[\dA-Z]+\-WIN" | select -First 1 -expand href).Split("/")[-1]).Split(".")[-1]
  Write-Host "try -$try-"
  $ext = @{$true='7z';$false='exe'}[( $kind -match 'dev' )]
  #write-host "ext -$ext-"
  # $bit = @{$true='x86';$false='x64'}[( $bitness -match '32' )]

  $ver = @{$true="DEV";$false="CAD\-|\.[\dA-Z]+\-WIN"}[( $kind -match 'dev' )]
  #write-host "ver -$ver-"
  $re32 = "x86.*\.$ext$"
  $re64 =  @{$true="x64_dev_win.*\.$ext$";$false="x64.*\.$ext$"}[( $kind -match 'dev' )]
  #write-host "re32 -$re32-"
  #write-host "re64 -$re64-"
  $url32 = $download_page.Links | ? href -match $re32 | select -first 1 -expand href
  $url64 = $download_page.Links | ? href -match $re64 | select -first 1 -expand href
  #write-host "url64 -$url64-"
  #write-host "O ver -$ver-"
  if ( $ver -eq 'DEV' ) {
  #write-host "A ver -$ver-"
  $verRe32 = $verRe64 = "_"
  } else {
  #write-host "B ver -$ver-"
  $verRe32 = $verRe64 = "-"
  }
  #Write-Host "verRe32 -$verRe32-"
  #Write-Host "verRe64 -$verRe64-"
  ( Get-Version $url32 -Delimiter $verRe32 ) -match $regex | Out-Null
  $version32 = $Matches[0]
  #Write-Host "A version32 -$version32-"
  ( Get-Version $url64 -Delimiter $verRe64 ) -match $regex | Out-Null
  $version64 = $Matches[0]
  #Write-Host "A version64 -$version64-"

  if ( $version32 -eq $version64 ) {
  #write-host "we are equal"
  $version = $version32
  } 
  if ( $version32 -ne $version64 ) {
  #write-host "we aren't equal"
  $version = $version64
  }

  [version]$version32 = $url -split "$verRe32" | select -last 1 -skip 1

  if ( $kind -eq 'dev' ) {
    $vert = "$version-$kind";
    $Title = $Title + '-' + $kind
  } else {
    $vert = $version;
    $Title = $Title;
  }
  #Write-Host "vert -$vert-"
  

 	@{
		Title      = $Title
		URL32      = $PreUrl + $url32
		URL64      = $PreUrl + $url64
		Version    = $vert
        fileType   = ($url32.Split("/")[-1]).Split(".")[-1]
	}
} 

function global:au_GetLatest {
  $streams = [ordered] @{
    stable = Get-FreeCad -Title "FreeCAD" -kind "stable"
    dev = Get-FreeCad -Title "FreeCAD" -kind "dev"
  }
  return @{ Streams = $streams }
}

update
