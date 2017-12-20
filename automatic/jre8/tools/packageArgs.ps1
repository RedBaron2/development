# Due to a big in AU. This package requires that all package Arguments be in this hashtable

$packageArgs = @{
	oldVersion		= '8.0.1440.1'
	version			= '8.0.1510.12'
	packageName		= 'jre8'
	fileType		= 'exe'
	url				= 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=227550_e758a0de34e24606bca991d704f6dcbf'
	url64bit		= 'http://javadl.oracle.com/webapps/download/AutoDL?BundleId=227552_e758a0de34e24606bca991d704f6dcbf'
	silentArgs		= '/s REBOOT=0 SPONSORS=0 REMOVEOUTOFDATEJRES=1'
	validExitCodes	= @(0)
	softwareName  	= 'Java SE Runtime Environment'
	checksum		= '990FA41BD7A66C0402A6EDE43D51983CA0AC5F74B212FDD9F4AFE366CDE7A28D'
	checksumType	= 'sha256'
	checksum64		= '4378D712C510930D066BFA256B24E07DFEA5ED31AA514AFB7C7DD72FCCE9BB68'
	checksumType64	= 'sha256'
}
