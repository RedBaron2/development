﻿$packageName = ''
$installerType = 'exe'
$instLog = Join-Path $env:Temp kis-$(Get-Date -Format yyyyMMddHHmm)
$instLog = $instLog + '.log'
$silentArgs = "/s /t$instLog /g1"
$url = ''
$checksum = ''
$checksumType = 'sha256'
$validExitCodes = @(0,3010)

Install-ChocolateyPackage -PackageName "$packageName" `
                          -FileType "$installerType" `
                          -SilentArgs "$silentArgs" `
                          -Url "$url" `
                          -ValidExitCodes $validExitCodes `
                          -Checksum "$checksum" `
                          -ChecksumType "$checksumType"
