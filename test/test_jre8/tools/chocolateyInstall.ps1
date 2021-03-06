
  
try {

  $packageArgs = @{
  packageName            = 'jre8'
  fileType               = 'exe'
  url                    = 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=220313_d54c1d3a095b4ff2b6607d096fa80163'
  url64		         = 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=220315_d54c1d3a095b4ff2b6607d096fa80163'
  checksum               = '73BF9257E2F4CA73318D3C23181CBE1E93665BF13FDA7B956252A70B975BCF8B'
  checksum64             = '5083590A30BF069E947DCE8968221AF21B39836FE013B111DE70D6107B577CD3'
  checksumType           = 'sha256'
  checksumType64         = 'sha256'
  validExitCodes         = @(0)
  softwareName           = 'Java RE'
}
  # $packageName = 'jre8'
  # Modify these values -----------------------------------------------------
  # Find download URLs at http://www.java.com/en/download/manual.jsp
  $url = $packageArgs.url
  $checksum = $packageArgs.checksum
  $url64 = $packageArgs.url64
  $checksum64 = $packageArgs.checksum64
  $oldVersion = '8.0.1210.13'
  $version = '8.0.1310.11'
  #--------------------------------------------------------------------------
  
  # Now we can use the $env:chocolateyPackageParameters inside the Chocolatey package
  $packageParameters = $env:chocolateyPackageParameters

  # Default value
  $exclude = $null

  # Now parse the packageParameters using good old regular expression
  if ($packageParameters) {
	  $arguments = @{}
      $match_pattern = "\/(?<option>([a-zA-Z0-9]+)):(?<value>([`"'])?([a-zA-Z0-9- \(\)\s_\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
      $option_name = 'option'
      $value_name = 'value'

      if ($packageParameters -match $match_pattern ){
          $results = $packageParameters | Select-String $match_pattern -AllMatches
          $results.matches | % {
            $arguments.Add(
                $_.Groups[$option_name].Value.Trim(),
                $_.Groups[$value_name].Value.Trim())
        }
      }
      else
      {
          Throw "Package Parameters were found but were invalid (REGEX Failure)"
      }

      if($arguments.ContainsKey("exclude")) {
          Write-Host "exclude Argument Found"
          $exclude = $arguments["exclude"]
      }

  } else {
      Write-Debug "No Package Parameters Passed in"
  }

  # $scriptDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  # Import function to test if JRE in the same version is already installed
  # Import-Module (Join-Path $scriptDir 'thisJreInstalled.ps1')
  
		# This function checks if the same version of JRE is already installed on the computer.
		# It returns a hash map with a 'x86_32' and 'x86_64'. These values are not empty if the
		# same version and bitness of JRE is already installed.
		function thisJreInstalled() {
		param(
			[string]$version
		)
		  $productSearch = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -match '^Java \d+ Update \d+'}
		  
		  # The regexes for the name of the JRE registry entries (32- and 64 bit versions)
		  $nameRegex32 = '^Java \d+ Update \d+$'
		  $nameRegex64 = '^Java \d+ Update \d+ \(64-bit\)$'
		  $versionRegex = $('^' + $version + '\d*$')

		  $x86_32 = $productSearch | Where-Object {$_.Name -match $nameRegex32 -and $_.Version -match $versionRegex}
		  $x86_64 = $productSearch | Where-Object {$_.Name -match $nameRegex64 -and $_.Version -match $versionRegex}
		  if($x86_32 -eq $null)
		  {
			$x86_32 = $false
		  }
		  if($x86_64 -eq $null)
		  {
			$x86_64 = $false
		  } 
		  return $x86_32,$x86_64
		} 

  $homepath = $version -replace "(\d+\.\d+)\.(\d\d)(.*)",'jre1.$1_$2'
  $installerType = 'exe'
  $installArgs = "/s REBOOT=0 SPONSORS=0 REMOVEOUTOFDATEJRES=1 $32dir"
  $installArgs64 = "/s REBOOT=0 SPONSORS=0 REMOVEOUTOFDATEJRES=1 $64dir"
  # $packageArgs.Add("silentArgs","/s REBOOT=0 SPONSORS=0 REMOVEOUTOFDATEJRES=1 $32dir")
  # $packageArgs.Add("silentArgs64","/s REBOOT=0 SPONSORS=0 REMOVEOUTOFDATEJRES=1 $64dir")
  $osBitness = Get-ProcessorBits
   
  Write-Output "Searching if new version exists..."
  $thisJreInstalledHash = thisJreInstalled($version)

  # This is the code for both javaruntime and javaruntime-platformspecific packages.
  # If the package is javaruntime-platformspecific, only install the jre version
  # based on the OS bitness, otherwise install both 32- and 64-bit versions
  if ($packageName -match 'platformspecific') {

    if (($thisJreInstalledHash[0]) -or ($thisJreInstalledHash[1])) {
      Write-Output "Java Runtime Environment $version is already installed. Skipping download and installation to avoid 1603 errors."
    } else {
	  Install-ChocolateyPackage $packageArgs.packageName $installerType $installArgs $packageArgs.url $packageArgs.url64bit
      # Install-ChocolateyPackage $packageName $installerType $installArgs $url $url64
    }

  } else {
    # Otherwise it is the javaruntime package which installs by default both 32- and 64-bit jre versions on 64-bit systems.

    # Checks if JRE 32/64-bit in the same version is already installed and if the user excluded 32-bit Java.
    # Otherwise it downloads and installs it.
    # This is to avoid unnecessary downloads and 1603 errors.
    if ($thisJreInstalledHash[0]) 
    {
      Write-Output "Java Runtime Environment $version (32-bit) is already installed. Skipping download and installation"
    } 
    elseif ($exclude -ne "32") 
    {
	  Install-ChocolateyPackage $packageArgs.packageName $packageArgs.fileType $packageArgs.silentArgs $packageArgs.url -checksum $packageArgs.checksum -checksumtype $packageArgs.checksumType
      # Install-ChocolateyPackage $packageName $installerType $installArgs $url -checksum $checksum32 -checksumtype 'sha256'
    } 
    else 
    {
      Write-Output "Java Runtime Environment $Version (32-bit) excluded for installation"
    }

    # Only check for the 64-bit version if the system is 64-bit

    if ($osBitness -eq 64) 
    {
      if ($thisJreInstalledHash[1]) 
      {
        Write-Output "Java Runtime Environment $version (64-bit) is already installed. Skipping download and installation"
      } 
      elseif ($exclude -ne "64") 
      {
        # Here $url64 is used twice to obtain the correct message from Chocolatey
        # that it installed the 64-bit version, otherwise it would display 32-bit,
        # regardless of the actual bitness of the software.
		Install-ChocolateyPackage $packageArgs.packageName $packageArgs.installerType $packageArgs.silentArgs64 $packageArgs.url64bit $packageArgs.url64bit  -checksum64 $packageArgs.checksum64 -checksumtype64 $packageArgs.checksumType64
        # Install-ChocolateyPackage $packageName $installerType $installArgs64 $url64 $url64 -checksum64 $checksum64 -checksumtype64 'sha256'
      } 
      else 
      {
        Write-Output "Java Runtime Environment $Version (64-bit) excluded for installation"
      }
    }
  }
  #Uninstalls the previous version of Java if either version exists
  Write-Output "Searching if the previous version exists..."
  $oldJreInstalledHash = thisJreInstalled($oldVersion)

  if($oldJreInstalledHash[0]) 
  {
     Write-Warning "Uninstalling JRE version $oldVersion 32bit"
     $32 = $oldJreInstalledHash[0].IdentifyingNumber
     Start-ChocolateyProcessAsAdmin "/qn /norestart /X$32" -exeToRun "msiexec.exe" -validExitCodes @(0,1605,3010)
  }
  if($oldJreInstalledHash[1])
  {
     Write-Warning "Uninstalling JRE version $oldVersion 64bit"
     $64 = $oldJreInstalledHash[1].IdentifyingNumber
     Start-ChocolateyProcessAsAdmin "/qn /norestart /X$64" -exeToRun "msiexec.exe" -validExitCodes @(0,1605,3010)
  }
} catch {
  Write-ChocolateyFailure $packageName $($_.Exception.Message)
  throw
}
