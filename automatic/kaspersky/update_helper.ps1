
function Get-KasperskyPackageName() {
param(
    [string]$a
)

$PreURL = 'https://usa.kaspersky.com/downloads/thank-you'
switch -w ( $a ) {

    'kfa' {
        $PackageUrl = "${PreURL}/free-antivirus-download"
    }
    'kav' {
        $PackageUrl = "${PreURL}/antivirus"
    }
    'kts' {
        $PackageUrl = "${PreURL}/total-security"
    }
    'kis' {
        $PackageUrl = "${PreURL}/internet-security"
    }



}

return $PackageUrl

}
