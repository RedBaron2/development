
$start_time1 = Get-Date

$os = Get-WmiObject -Class Win32_OperatingSystem
$caption = $os.Caption
write-host $caption


# Get Operating System Info (no need for foreach)
$sServer = "."

$sOS =Get-WmiObject -class Win32_OperatingSystem

$sOS | Select-Object Description, Caption, OSArchitecture, ServicePackMajorVersion | Format-List

$releases = 'https://www.wps.com/office-free'

	  $download_page = Invoke-WebRequest -Uri $releases
	  $url = ( $download_page.ParsedHtml.getElementsByTagName('a') | Where { $_.className -match 'major transition_color ga-download-2016-free'} ).href
	  $search='innerHTML';$cpt=1;$resu=@{};
    $match='(?:Version:)[\d\.]{4,}'; $match_1 = '([WPS]{3}\s[a-zA-Z]{1,}\s\d+\s[Free]{4})';
    $replace='Version:';
	  $download_page.ParsedHtml.getElementsByTagname("a") |%{
    if ($_.id -eq $null){ $_.id="p$cpt";$cpt++};$resu[$($_.id)]=$_.$search
    #$resu
    if ( $_.$search -match($match) ) { $version= $_.$search; }
    if ( $_.$search -match($match_1) ) { $product = $_.$search; }    }
    $description = ( $download_page.ParsedHtml.getElementsByTagName('div') | Where { $_.className -match 'product'} ).innertext
    $description = $description -replace('WPS Office for ','')
    $description = '<![CDATA[' + $description + ']]>'
    Write-Host $description
	  $version = $version -match($match);$version = $matches[0];
    $version = $version -replace($replace)
    $product = $product -match($match_1);$product = $matches[0]; 
    $productName = $product -replace('\s[\d+]{4}\s',' ')
    $productName = $productName -replace('\s','-')

    return @{ URL32 = $url; Version = $version; packageName = $productName.ToLower() ; softwareName = $product.ToLower() ; description = $description }

Write-host "Time taken: $((Get-Date).Subtract($start_time1).Seconds) second(s)"
