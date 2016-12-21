Clear-Host
$Site = "http://www.computerperformance.co.uk"
$Test = Invoke-WebRequest $Site
$Test | Get-Member
