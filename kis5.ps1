$start_time = Get-Date

function Get-KIS-parts ( $search , $URL , $a ) {
$urlHost = iwr -Uri $URL

    $Path_regex = '.*(kis[^"<]+)'
    #$File_regex = '.*(kis.*?en_\d+\.exe)'
    $File_regex = '(?:kis)[\d\.]{3,}(?:.en_)\d{5,}.exe'

    $cpt=1                                                                                                                                                                                                             
    $resu=@{}
    $urlHost.ParsedHtml.getElementsByTagname("a") |%{
        if ($_.id -eq $null){ $_.id="data$cpt";$cpt++}
        $resu[$($_.id)]=$_.$search
        #Write-Host $_.$search

    if (( $a -eq '0' ) -and ( $_.$search -match $Path_regex )) { 
    $test = $_.$search
    }
    if (( $a -eq '1' ) -and ( $_.$search -match $File_regex )) {
        Write-Host head ($URL+'/'+$_.$search)
        $response = ( iwr ( $URL+'\'+$_.$search ) ).headers
        $file_size = (($response['content-length'] -ge '2422304'))
        if (( $_.$search -match '.exe' ) -and ( $file_size -ne 'True') ) {
        Write-Host fl -$file_size-
        $test = $_.$search
        Write-Host test -$test-
    }
    }

    }
    return $test
}



$urlHost = 'http://products.kaspersky-labs.com/english/homeuser'

$urlPath = ( Get-KIS-parts -search "innerHTML" -URL $urlHost -a 0 )
Write-Host outside urlpath - $urlPath -
$myURL = $urlHost + '/' + $urlPath
Write-Host myurl -$myURL-
$urlFile = ( Get-KIS-parts -search "innerHTML" -URL $myURL -a 1 )
Write-Host outside urlfile -$urlFile-
$url = $urlHost+'/'+$urlPath+'/'+$urlFile
Write-Host outside url -$url-
$res = $urlFile -split('_')
$revision = $res[1] -replace('.exe','')
Write-Host outside revision -$revision-
$vers = $urlFile -match('[\d+\.]{3,}(?=en_)') # this (?=en_) is not needed to get the number we need
#$vers = $urlFile -match('(?<=en_)[\d]{5,\}')
$version = $matches[0]
Write-Host outside version -$version-

Write-host "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
