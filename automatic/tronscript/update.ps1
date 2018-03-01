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

 $preURL = 'https://bmrf.org/repos/tron/'
 $chk_file = 'sha256sums.txt'
 $myURL = $preURL + $chk_file
 $tron_file = "${env:temp}\wc365_tron.txt"
 $HTML = Invoke-WebRequest $myURL -OutFile $tron_file
 $newt = ( Get-Content $tron_file | Select-Object -last 1 )
 $tron_file | Remove-Item -Force
 $HTML.close
 $data = $newt -split( ',' )
 $fileName = $data[2]
 $ver = $fileName -replace( 'Tron v', '' );
 $fileName = [uri]::EscapeDataString($fileName)
 $vers = $ver -replace( '.exe', '' );
 $vers = $vers -replace( '\s', '' );
 $versy = ( $vers -replace( '[(][0-9]{4}\-[0-9]{2}\-[0-9]{2}[)]', '' ) );
 $checksum = $data[1].ToUpper();
 $version = $versy;
    
    $Latest = @{
        Version             = $version
        Checksum32          = $checksum
		URL32				= $preURL + $fileName
        ChecksumType32      = 'sha256'
    };

    return $Latest;
}

update -ChecksumFor none