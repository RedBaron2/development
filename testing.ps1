function Get-360TS-version( $URI ) {
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /t REG_DWORD /v 1A10 /f /d 0 | out-null
$URI = "https://www.360totalsecurity.com/en/features/360-total-security/"
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

$releases = 'http://www.videosoftdev.com/free-video-editor/download'

function Test {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    $version = $download_page.Content -split '\n' | sls 'Current version:' -Context 0,5 | out-string

}

Get-360TS-version -URI "https://www.360totalsecurity.com/en/features/360-total-security/"
Test
