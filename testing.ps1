function Get-360TS-version( $URI ) {
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /t REG_DWORD /v 1A10 /f /d 0 | out-null

$HTML = Invoke-WebRequest -Uri $URI
$try = ($HTML.ParsedHtml.getElementsByTagName('span') | Where{ $_.className -eq 'version' } ).innerText

$try = $try -replace( ' : ',' = ')
$techy =  ConvertFrom-StringData -StringData $try
$CurrentVersion = ( $techy.Version )
#Write-Host $techy.Version
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v 1A10 /f | out-null
return $CurrentVersion
$HTML.close
}

function Test( $releases ) {

    $download_page = Invoke-WebRequest -Uri $releases
    $newt = ( $download_page.AllElements -split '`n'  ) | where{ $_ -match '<P slick-uniqueid="254"><STRONG slick-uniqueid="255">' } | select -first 1
    Write-Host newt -$newt-
    $version = $newt
    write-host A version is -$version-
    $version = $version -replace '<P slick-uniqueid="253">File size:</P></DIV>',''
    write-host B version is -$version-
    $version = $version -replace 'File size:',''
    write-host C version is -$version-

    $download_page.close
}

Get-360TS-version -URI "https://www.360totalsecurity.com/en/features/360-total-security/"
Test -releases 'http://www.videosoftdev.com/free-video-editor/download'

write-Host "This is the end Folks"
