$ErrorActionPreference = 'Stop'

# $toolsDir = "C:\Users\CCtech\Desktop\mv_removers\apps\packages\roguekiller"
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
# Get-ChocolateyWebFile -PackageName 'bob' -FileFullPath "$toolsDir\bob.exe"roguekiller_portable.exe
  $osBitness = Get-ProcessorBits
$fileName = @{$true="roguekiller_portable32.exe";$false="roguekiller_portable64.exe"}[ $osBitness -eq 32 ]
$toolsFile = "$toolsDir\$fileName"

$packageArgs = @{
  packageName            = 'roguekiller'
  fileFullPath           = "$toolsFile"
  fileType               = 'EXE'
  url                    = 'http://download.adlice.com/api/?action=download&app=roguekiller&type=x86'
  url64bit               = 'http://download.adlice.com/api/?action=download&app=roguekiller&type=x64'
  checksum               = 'eedee3487b25a4b84a2ea3fedc0f8e2c1f14c9e3890af4bb1df5f29b1079de3d'
  checksum64             = 'c7f218d6d2af16f60e6f28f631eebb4641f491121b083d99e1a533f876fb90b5'
  checksumType           = 'sha256'
  checksumType64         = 'sha256'
  validExitCodes         = @(0)
}
Get-ChocolateyWebFile @packageArgs

