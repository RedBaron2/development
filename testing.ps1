#function Get-Version( $URI ) {
#reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /t REG_DWORD /v 1A10 /f /d 0 | out-null
$URI = “https://www.360totalsecurity.com/en/features/360-total-security/“
$HTML = Invoke-WebRequest -Uri $URI
$try = $HTML.Content -split "`n" | sls 'Current version' -Context 2
#Write-Host -$try-
$try = $try -replace( ' : ',' = ')
$techy =  ConvertFrom-StringData -StringData $try
$CurrentVersion = ( $techy.Version )
Write-Host $techy.Version
#reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v 1A10 /f | out-null
#return $CurrentVersion
$HTML.close
#}


#Get-Version -URI "https://www.360totalsecurity.com/en/features/360-total-security/"
