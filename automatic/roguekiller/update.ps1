import-module au


function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(^\s*url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
            "(^\s*url64Bit\s*=\s*)('.*')" = "`$1'$($Latest.URL64)'"
            "(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^\s*checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
            "(^\s*checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^\s*checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
        }
    }
}

function global:au_BeforeUpdate {
  $Latest.ChecksumType32 = 'sha256'
  $Latest.Checksum32 = Get-RemoteChecksum -Algorithm $Latest.ChecksumType32 -Url $Latest.URL32
  $Latest.ChecksumType64 = 'sha256'
  $Latest.Checksum64 = Get-RemoteChecksum -Algorithm $Latest.ChecksumType64 -Url $Latest.URL64
	Remove-Item ".\tools\*.exe" -Force # Removal of downloaded files
	
}

function global:au_GetLatest {

    $site = 'http://www.adlice.com/download/roguekiller/'
    $source = "http://download.adlice.com/api/?action=download&app=roguekiller&type=changelog"
    $RK_regex = '([\d]{0,4}[\.][\d]{0,4}[\.][\d]{0,4})';
    $destination = "${env:temp}\RK_changelog.txt"
    $dest_exists = @{$true="exists";$false="does NOT exist"}[ ( Test-Path $destination ) ]
    if (( Test-Path $destination )) { $run = 0;} else { $run++; }
    $test = Invoke-WebRequest $source -OutFile $destination
    $i=0;
    Get-Content $destination | Foreach-Object { $i++; if ( $i -eq '10' ) { $version=($_) } }
    $test.close
    $v = $version -match $RK_regex
    $vers = $Matches[0] + ".0"	

    @{
        Version      = $vers
        URL32        = "http://download.adlice.com/api/?action=download&app=roguekiller&type=x86"
        URL64        = "http://download.adlice.com/api/?action=download&app=roguekiller&type=x64"
    }
}

update -ChecksumFor all -NoCheckChocoVersion
