
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

function Get-FileName {
param(
    [hashtable]$thePackage
)
$bits = ((Get-OSBitness) -eq 32)
$fileName = @{$true=($thePackage.url);$false=($thePackage.url64)}[ $bits ]
$fileName = ((($fileName -split('/'))[-1]) -replace( "\.$($thePackage.fileType)", '' ) )
return $fileName
}

function Get-UserPackageParams {
param(
    [hashtable]$pp = ( Get-PackageParameters ),
    [parameter(Mandatory=$false)][switch]$scrawl
)
$folderName = ( Get-FileName -thePackage $packageArgs )
$New_pp = @{}
        if ([string]::IsNullOrEmpty($pp.UnzipLocation)) {
          $New_pp.add( "UnzipLocation", "$toolsDir" )
        } else {
          $New_pp.add( "UnzipLocation", $pp.UnzipLocation )
        }
        if ([string]::IsNullOrEmpty($this.ShortcutFilePath)) {
          $New_pp.add( "ShortcutFilePath", ( [Environment]::GetFolderPath('Desktop') )+"\${ChocolateyPackageName}.lnk" )
        } else {
          $New_pp.add( "ShortcutFilePath", $pp.ShortcutFilePath )
        }
        if ([string]::IsNullOrEmpty($pp.WindowStyle)) {
          $New_pp.add( "WindowStyle", 1 )
        } else {
          $New_pp.add( "WindowStyle", $pp.WindowStyle )
        }
        if ([string]::IsNullOrEmpty($pp.WorkingDirectory)) {
          $New_pp.add( "WorkingDirectory", $New_pp.UnzipLocation+"\$folderName" )
        } else {
          $New_pp.add( "WorkingDirectory", $pp.WorkingDirectory )
        }
        if ([string]::IsNullOrEmpty($this.TargetPath)) {
          $New_pp.add( "TargetPath", $New_pp.WorkingDirectory+"\bin\${ChocolateyPackageName}.exe" )
        } else {
          $New_pp.add( "TargetPath", $pp.TargetPath )
        }
        if ([string]::IsNullOrEmpty($pp.IconLocation)) {
          $New_pp.add( "IconLocation", $New_pp.TargetPath )
        } else { 
          $New_pp.add( "IconLocation", $pp.IconLocation )
        }
        if ([string]::IsNullOrEmpty($pp.Description)) {
          $New_pp.add( "Description", "FreeCAD Development ${env:ChocolateyPackageVersion}" )
        } else { 
          $New_pp.add( "Description", $pp.Description )
        }
        # Null or False Defaults
        if (![string]::IsNullOrEmpty($pp.Arguments)) {
          $New_pp.add( "Arguments", $pp.Arguments )
        } 
        if (![string]::IsNullOrEmpty($pp.PinToTaskbar)) {
          $New_pp.add( "PinToTaskbar", $true )
        }
        if (![string]::IsNullOrEmpty($pp.RunAsAdmin)) {
          $New_pp.add( "RunAsAdmin", $true )
        }
        if (![string]::IsNullOrEmpty($pp.Shortcut)) {
          $New_pp.add( "Shortcut", $true )
        }
		if ($scrawl) {
        $New_pp | ConvertTo-Json | Out-File ( "$toolsDir\pp.json" )
		}

    return $New_pp
}
