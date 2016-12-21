
$Site = "http://www.videosoftdev.com/free-video-editor/download"
$Test = ( Invoke-WebRequest $Site ).Content
$Test = $Test | where { $_ -match '<p><strong>' }
Write-host content -$Test-
