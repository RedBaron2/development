
$Site = "http://www.videosoftdev.com/free-video-editor"
$Test = Invoke-WebRequest $Site
$Testy = $Test.parsedhtml.GetElementsByTagName('p')  | out-string
#$Testing = $Testy.parsedhtml.GetElementsByTagName('strong')
$i=0
Foreach ( $s in $Testy ) {
$i++
Write-host Testy -$i- -$s-
}

function Test( $releases ) {

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /t REG_DWORD /v 1A10 /f /d 0 | out-null
    #$releases = 'http://www.videosoftdev.com/free-video-editor/download'
    $download_page = Invoke-WebRequest -Uri $releases
    
$cpt=1                                                                                                                                                                                                             
$resu=@{}
$download_page.ParsedHtml.getElementsByTagname("p") |%{
    if ($_.id -eq $null){ $_.id="p$cpt";$cpt++}
    $resu[$($_.id)]=$_.innerHTML
}                                                                                       
#$resu   
    
    $version = $resu.p4
    write-host A version is -$version-
    $version = $version -replace '<STRONG slick-uniqueid="256">',''
    write-host B version is -$version-
    $version = $version -replace '<STRONG slick-uniqueid="255">',''
    write-host B1 version is -$version-
    $version = $version -replace '</STRONG>',''
    write-host C version is -$version-
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v 1A10 /f | out-null
    $download_page.close

}

Test -releases 'http://www.videosoftdev.com/free-video-editor/download'
