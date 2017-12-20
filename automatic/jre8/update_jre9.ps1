
    $releases = 'http://www.oracle.com/technetwork/java/javase/downloads/index.html'
	$regex = '(Java\sSE\s\d{1,3}\.\d\.\d)'
	$download_page = Invoke-WebRequest -UseBasicParsing $releases
	$download_page | foreach { $_ -match $regex } | Select -First 1 -skip 1
	$version = $Matches[0]
	$version = $version -replace('Java SE ','')
$preUrl = 'http://download.oracle.com/otn-pub/java/jdk/'
# http://download.oracle.com/otn-pub/java/jdk/9.0.1+11/jre-9.0.1_windows-x64_bin.exe

Write-Host "-$version-"