$ErrorActionPreference = "silentlycontinue"

#cd .\automatic
#updateall
# Get-ChildItem */* | 
# where {$_.name -eq "update.ps1"} | 
# foreach { cd $_.DirectoryName; .\update.ps1; cd ..}

#cd ..
#cd .\test
#.\drpbx_timer.ps1
#.\testing.ps1
# updateall
<#
This is the options for updateall AU

#>

Set-Alias posh-tee Write-Host
$au_Root = '.\automatic';
$au_NoCheckChocoVersion = $true;
$myDir = "${env:temp}\AU_Updates"
$myAU_report = "AU_update_report.log"
$myAU_report_xml = "AU_update_report.xml"

if ( $me -eq $null ) { $me=(${env:computername}) }
$AUdiag_log = "$myDir\$me\" + "$myAU_report"
$AUdiag_xml = "$myDir\$me\" + "$myAU_report_xml"

if (!(Test-Path $AUdiag_log)) {
	posh-tee "We are testing for $AUdiag_log now`r`n"
		New-Item -ItemType "file" -Force -Path $AUdiag_log
	}
if (!(Test-Path $AUdiag_xml)) {
	posh-tee "We are testing for $AUdiag_xml now`r`n"
		New-Item -ItemType "file" -Force -Path $AUdiag_xml
	}

$Options = [ordered]@{
        Timeout = 100
        Threads = 15
        Push    = $false
          
        # Save text report in the local file report.txt
        Report = @{
            # Type = 'text'
            Path = "$AUdiag_log"
        }
        
        # Then save this report as a gist using your api key and gist id
        # Gist = @{
            # ApiKey = $Env:github_api_key
            # Id     = $Env:github_gist_id
            # Path   = "$PSScriptRoot\report.txt"
        # }

        # Persist pushed packages to your repository
        # Git = @{
            # User = ''
            # Password = $Env:github_api_key
        # }
        
        # Then save run info which can be loaded with Import-CliXML and inspected
        RunInfo = @{
            Path = "$AUdiag_xml"
        }

        # Finally, send an email to the user if any error occurs and attach previously created run info
        # Mail = if ($Env:mail_user) {
                # @{
                   # To          = $Env:mail_user
                   # Server      = 'smtp.gmail.com'
                   # UserName    = $Env:mail_user
                   # Password    = $Env:mail_pass
                   # Port        = 587
                   # EnableSsl   = $true
                   # Attachment  = "$PSScriptRoot\$update_info.xml"
                   # UserMessage = 'Save attachment and load it for detailed inspection: <code>$info = Import-CliXCML update_info.xml</code>'
                # }
        # } else {}
    }
    
cd $au_Root
$package = "360ts"
sleep 10
updateall $package -Options $Options
sleep 5
cinst KB2919442 360ts -y
