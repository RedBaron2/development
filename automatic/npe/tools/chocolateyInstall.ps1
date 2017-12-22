$packageName = 'npe'
$url = 'http://liveupdate.symantec.com/upgrade/NPE/1033/NPE.exe'
$checksum = 'ef6a3a4e0ebe368e3adc3716c1dd71e00ad562cc71a79b9732dbc11bf81f807a'
$checksumType = 'sha256'
$toolsPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installFile = Join-Path $toolsPath "npe.exe"
try {
  Get-ChocolateyWebFile -PackageName "$packageName" `
                        -FileFullPath "$installFile" `
                        -Url "$url" `
                        -Checksum "$checksum" `
                        -ChecksumType "$checksumType"

  # create empty sidecars so shimgen only creates one shim
  Set-Content -Path ("$installFile.ignore") `
              -Value $null

  # create batch to start executable
  $batchStart = Join-Path $toolsPath "npe.bat"
  'start %~dp0\npe.exe -accepteula' | Out-File -FilePath $batchStart -Encoding ASCII
  Install-BinFile "npe" "$batchStart"
} catch {
  throw $_.Exception
}
