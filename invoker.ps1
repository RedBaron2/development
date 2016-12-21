
$Site = "http://www.videosoftdev.com/free-video-editor"
$Test = Invoke-WebRequest $Site
$Testy = $Test.parsedhtml.GetElementsByTagName('p')
$Testing = $Testy.parsedhtml.GetElementsByTagName('strong') | out-string
$i=0
Foreach ( $s in $Testing ) {
$i++
Write-host Testing -$i- -$s-
}
