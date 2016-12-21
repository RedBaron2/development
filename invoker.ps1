
$Site = "http://www.videosoftdev.com/free-video-editor"
$Test = Invoke-WebRequest $Site
$Testy = $Test.parsedhtml.GetElementsByTagName('p')  | out-string
#$Testing = $Testy.parsedhtml.GetElementsByTagName('strong')
$i=0
Foreach ( $s in $Testy ) {
$i++
Write-host Testy -$i- -$s-
}
