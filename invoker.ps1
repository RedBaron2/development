
$Site = "http://www.videosoftdev.com/free-video-editor"
$Test = Invoke-WebRequest $Site
$Testy = $Test.parsedhtml.GetElementsByTagName('p')
#$Testing = $Testy.parsedhtml.GetElementsByTagName('strong') | out-string
$i=0
Foreach ( $s in $Testy ) {
$i++
Write-host Testy -$i- -$s-
}
