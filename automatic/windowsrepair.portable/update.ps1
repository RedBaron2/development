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

	# $fileName = @{$true="tweaking.com_windows_repair_aio.zip";$false="tweaking.com_windows_repair_aio_setup.exe"}[ $Latest.PackageName -match 'portable' ]
        $fileName = "tweaking.com_windows_repair_aio.zip"
        $HTML = Invoke-WebRequest 'http://www.tweaking.com/articles/pages/tweaking_com_windows_repair_change_log,1.html'
        $newt = ( $HTML.ParsedHtml.getElementsByTagName('div') | Where { $_.className -eq 'content'} ).innertext
        $HTML.close
        $i=0; foreach ($toad in $newt) { $i++; if ( $i -eq '8') { $log = ( $toad | Select -First 1 ) } }
        $vers = $log -split "`n"
        $version = $vers[0] | where { $_ -match "(\d+\.?){3}" } | foreach { $matches[0] }
        $verst = ( $version -replace('v',''))
        $url = "http://www.tweaking.com/files/setups/${fileName}"
        # $current_checksum = (gi "$PSScriptRoot\tools\chocolateyInstall.ps1" | sls '\bchecksum\b') -split "=|'" | Select -Last 1 -Skip 1
        # if ($current_checksum.Length -ne 64) { 
        # Write-Host "Can't find current checksum defaulting to null";
        # $current_checksum = $null;
        # }
        # $remote_checksum  = Get-RemoteChecksum $url
        # if ($current_checksum -ne $remote_checksum) {
        # Write-Host 'Remote checksum is different then the current one, forcing update'
        # $global:au_old_force = $global:au_force
        # $global:au_force = $true
        # }
    
    $Latest = @{
        Version             = $verst
        # Checksum32          = $remote_checksum
		URL32				= $url
        # ChecksumType32      = 'sha256'
    };

    return $Latest;
}

update -ChecksumFor 32