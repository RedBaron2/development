# Name of the Chocolatey Package
$packageName = 'revouninstallerpro'
# Remove Characters / Add Spaces to $packageName
# for matching Name listed in Progams & Features
$regName = 'Revo Uninstaller Pro*'
# Using Chocolatey Helper to find related Registry Keys
$registry = Get-UninstallRegistryKey -SoftwareName $regName
# Any Silent Arguments for the Uninstall String
$silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP'

# All arguments for the Uninstallation of this package
$packageArgs = @{
PackageName = $registry.DisplayName
FileType = 'exe'
SilentArgs = $silentArgs
validExitCodes =  @(0)
File = $registry.UninstallString
}

# Now to Uninstall the Package
Uninstall-ChocolateyPackage @packageArgs
