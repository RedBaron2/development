
$Site = "http://www.videosoftdev.com/free-video-editor/download"
$Test = Invoke-WebRequest $Site | where { $_ -like '<p><strong>' } | select -first 1
Write-host content -$Test.Content-
