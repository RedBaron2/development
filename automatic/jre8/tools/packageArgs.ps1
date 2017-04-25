# Due to a big in AU. This package requires that all package Arguments be in this hashtable

$packageArgs = @{
	oldVersion		= ''
	version			= '8.0.1210.13'
	packageName		= 'jre8'
	fileType		= 'exe'
	url			= 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=220313_d54c1d3a095b4ff2b6607d096fa80163'
	url64bit		= 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=220315_d54c1d3a095b4ff2b6607d096fa80163'
	silentArgs		= '/s REBOOT=0 SPONSORS=0 REMOVEOUTOFDATEJRES=1'
	validExitCodes	= @(0)
	softwareName  	= 'Java SE Runtime Environment'
	checksum		= '73BF9257E2F4CA73318D3C23181CBE1E93665BF13FDA7B956252A70B975BCF8B'
	checksumType	= 'sha256'
	checksum64		= '5083590A30BF069E947DCE8968221AF21B39836FE013B111DE70D6107B577CD3'
	checksumType64	= 'sha256'
}
