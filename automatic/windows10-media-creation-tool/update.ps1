
import-module au
. ".\update_helper.ps1"

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(^[$]url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
      "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
  }
}

function global:au_BeforeUpdate {
	Remove-Item ".\tools\*.exe" -Force # Removal of downloaded files
}

function global:au_GetLatest {

$url = 'http://go.microsoft.com/fwlink/?LinkId=691209'
$fileName = "MediaCreationTool.exe"


	@{
		fileType	= 'exe'
		URL32		= $url
		Version		= (Get-FileVersion -url $url -file $fileName)
    }
}
update
