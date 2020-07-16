﻿[CmdletBinding()]
param($IncludeStream, [switch] $Force)

Import-Module AU

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)^(\s*url\s*=\s*)'.*'" = "`${1}'$($Latest.URL32)'"
      "(?i)^(\s*checksum\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum32)'"
      "(?i)^(\s*checksumType\s*=\s*)'.*'" = "`${1}'$($Latest.ChecksumType32)'"
      "(?i)^(\s*silentArgs\s*=\s*)'.*'" = "`${1}'$($Latest.silentArgs)'"
    }
  }
}

function global:au_AfterUpdate {
  . "$PSScriptRoot/update_helper.ps1"
  if ($Latest.PackageName -eq '1password4') {
    removeDependencies ".\*.nuspec"
  } else {
    addDependency ".\*.nuspec" 'dotnet4.6.2' '4.6.01590.20170129'
  }
}

function Get-LatestOPW {
param (
	[string]$url,
	[string]$kind

)

    $url32 = Get-RedirectedUrl $url
    $version = ( Get-Version $url32 ) -replace('exe','')
	if ($kind -eq '1password4') {
	$args = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
	} else {
	$args = ""
	}

		@{
			URL32 = $url32
			Version = $version.ToString()
			PackageName = $kind
			silentArgs = $args
		}
  }

  $releases_opw4 = 'https://app-updates.agilebits.com/download/OPW4'
  $kind_opw4     = '1password4'
  $releases_opw  = 'https://app-updates.agilebits.com/download/OPW7/Y'
  $kind_opw      = '1password'

function global:au_GetLatest {
  $streams = [ordered] @{
    OPW4 = Get-LatestOPW -url $releases_opw4 -kind $kind_opw4
    OPW  = Get-LatestOPW -url $releases_opw -kind $kind_opw
  }

  return @{ Streams = $streams }
}

update -ChecksumFor 32 -IncludeStream $IncludeStream -Force:$Force
