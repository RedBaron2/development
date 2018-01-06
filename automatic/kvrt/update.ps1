
import-module au
 # . "$PSScriptRoot\..\kav\update_helper.ps1"

function global:au_BeforeUpdate {
	Remove-Item ".\tools\*.exe" -Force # Removal of downloaded files
}

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(^[$]url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
      "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
  }
}

function global:au_GetLatest {
 
$PreURL = 'https://usa.kaspersky.com/downloads/thank-you'
$PackageUrl = "${PreURL}/free-virus-removal-tool"
$regex = '(kvrt)'
$url = $PackageUrl
$ie = New-Object -comobject InternetExplorer.Application
$ie.Navigate2($url) 
$ie.Visible = $false
while($ie.ReadyState -ne 3) {
 start-sleep -Seconds 20
} 
	# The .IHTMLDocument3_ is only for windows server IE to read correctly
$url = $ie.Document.IHTMLDocument3_getElementsByTagName("a") | % { $_.href } | where { $_ -match $regex } | select -First 1
$ie.quit()
# Write-Host "this is the yes -$yes-"

	$fileName = "kvrt.exe"
	$url = $yes
	Invoke-WebRequest -Uri $url -OutFile ".\tools\$fileName"
	$regex = "((\d+.\d+.\d+.\d+))"
	$filer = Get-Item ".\tools\*.exe"
	$version = $filer.VersionInfo.FileVersion -replace '$regex*','$1'
	$version = $version -match $regex;
	$version = $Matches[0]
$current_checksum = (gi $PSScriptRoot\tools\chocolateyInstall.ps1 | sls '(^[$]checksum\s*=\s*)') -split "=|'" | Select -Last 1 -Skip 1
    if ($current_checksum.Length -ne 64) { throw "Can't find current checksum" }
    $remote_checksum  = Get-RemoteChecksum $url
    if ($current_checksum -ne $remote_checksum) {
        Write-Host 'Remote checksum is different then the current one, forcing update'
        $global:au_old_force = $global:au_force
        $global:au_force = $true
        }

	@{
		fileType	= 'exe'
		URL32		= $url
		Version		= $version
        Checksum32 = $remote_checksum
    }
}
update -ChecksumFor 32
