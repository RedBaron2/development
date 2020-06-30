[CmdletBinding()]
param($IncludeStream, [switch]$Force)
import-module au

$releases = 'https://owncloud.org/download/#install-clients'
$softwareName = 'ownCloud'

function global:au_BeforeUpdate { 
[System.Net.ServicePointManager]::SecurityProtocol = 'Tls13' #https://github.com/chocolatey/chocolatey-coreteampackages/issues/366
Get-RemoteFiles -Purge -NoSuffix
}

function global:au_SearchReplace {
  @{
    ".\legal\VERIFICATION.txt"        = @{
      "(?i)(^\s*location on\:?\s*)\<.*\>" = "`${1}<$releases>"
      "(?i)(\s*1\..+)\<.*\>"              = "`${1}<$($Latest.URL32)>"
      "(?i)(^\s*checksum\s*type\:).*"     = "`${1} $($Latest.ChecksumType32)"
      "(?i)(^\s*checksum(32)?\:).*"       = "`${1} $($Latest.Checksum32)"
    }
    ".\tools\chocolateyInstall.ps1"   = @{
      "(?i)^(\s*softwareName\s*=\s*)'.*'"       = "`${1}'$softwareName'"
      "(?i)(^\s*file\s*=\s*`"[$]toolsPath\\).*" = "`${1}$($Latest.FileName32)`""
    }
  }
}

function global:au_AfterUpdate {
  Update-Metadata -key "title" -value $Latest.Title
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = 'ownCloud\-.*\.msi$'
  $urls32 = $download_page.Links | ? href -match $re | select -expand href

  $streams = @{}
  $urls32 | % {
    $verRe = '([\d\.]+)-(alpha)\d?'
    $ver = '([\d\.]+)\.msi'
    $version = $_ -split "$verRe" | select -last 1 -skip 1
    if ( $_ -match $verRe ) {
    $version = $Matches[0]
    $r = $Matches[1] -split("\.")
    $t = $r[4]
    #Write-Host "t -$t-"
    $version = ( $Matches[0] ) -replace("\.${t}",'')
    #Write-Host "A version -$version-"
    } else {
    $version = $_ -split "$ver" | select -Last 2
    #Write-Host "B version -$version-"
    }
    $version = Get-Version "$version"
    #Write-Host "C version -$version-"
    $kind = $_ -split '\/' | select -last 1 -skip 1

    if (!($streams.ContainsKey($kind))) {
      $streams.Add($kind, @{
          Version = $version.ToString()
          URL32   = $_
          Title   = if ($_ -match 'testing') { "ownCloud Windows Client (Technical Preview)" } else { "ownCloud Windows Client" }
        })
    }
  }

  return @{ Streams = $streams }
}

update -ChecksumFor none -IncludeStream $IncludeStream -Force:$Force
