
$Site = "http://www.videosoftdev.com/free-video-editor"
$Test = Invoke-WebRequest $Site
$Testy= $Test.parsedhtml.GetElementsByTagName('p') | Where { $_ -match '<p><strong>Version' }
Write-host Testy  -$Testy-
