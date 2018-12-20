import-module au

$PreUrl = 'https://github.com'
$releases = "$PreUrl/FreeCAD/FreeCAD/releases"
$softwareName = 'FreeCAD*'

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
      "(?i)(^\s*url64\s*=\s*)('.*')"        = "`$1'$($Latest.URL64)'"
      "(?i)(^\s*fileType\s*=\s*)('.*')"     = "`$1'$($Latest.fileType)'"
      "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
      "(?i)(^\s*checksum64\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"
      "(?i)(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
      "(?i)(^\s*checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
      "(?i)^(\s*softwareName\s*=\s*)'.*'" = "`${1}'$softwareName'"
    }
    ".\freecad.nuspec" = @{
      "\<releaseNotes\>.+" = "<releaseNotes>$($Latest.ReleaseNotes)</releaseNotes>"
    }
    ".\tools\chocolateyUninstall.ps1" = @{
      "(?i)^(\s*softwareName\s*=\s*)'.*'" = "`${1}'$softwareName'"
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
  $ext = @{$true='7z';$false='exe'}[( $kind -match 'dev' )]
  #write-host "ext -$ext-"
  $bit = @{$true='x86';$false='x64'}[( $bitness -match '32' )]

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
  $verRe32 = "CAD_|(\d\.\d+\.\d+)+_x86_dev_win"
  $verRe64 = "CAD_|(\d\.\d+\.\d+)+_x64_dev_win"
  } else {
  #write-host "B ver -$ver-"
  $verRe32 = $ver
  $verRe64 = $ver
  }
  #Write-Host "verRe32 -$verRe32-"
  #Write-Host "verRe64 -$verRe64-"


  [version]$version32 = $url32 -split "$verRe32" | select -last 1 -skip 1
  #Write-Host "A version32 -$version32-"
  [version]$version64 = $url64 -split "$verRe64" | select -last 1 -skip 1
  #Write-Host "A version64 -$version64-"

  if ( $version32 -eq $version64 ) {
  #write-host "we are equal"
  $version = $version32
  } 
  if ( $version32 -ne $version64 ) {
  #write-host "we aren't equal"
  $version = $version64
  }

  #Write-Host "version -$version-"

  if ( $kind -eq 'dev' ) {
    $vert = "$version-$kind";
    $Title = $Title + '-' + $kind
  } else {
    $vert = $version;
    $Title = $Title;
  }
  #Write-Host "vert -$vert-"
  

 	@{
		Title = $Title
		URL32 = $PreUrl + $url32
		URL64 = $PreUrl + $url64
		Version = $vert
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
