
$Site = "http://www.videosoftdev.com/free-video-editor/download"
$Test = Invoke-WebRequest $Site
Write-host content -$Test.Content-
