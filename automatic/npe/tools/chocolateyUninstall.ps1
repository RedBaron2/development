$packageName = 'npe'
$toolsPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$batchStart = Join-Path $toolsPath "npe.bat"
Uninstall-BinFile "$packageName" "$batchStart"