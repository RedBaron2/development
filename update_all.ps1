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
$au_NoCheckChocoVersion = $chocochk = $true;
$timeout = 200
$updatetimeout = 1300
$rbz_force = $false
$whatif = $false
$push = $false
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
    WhatIf        = $whatif                                 #Whatif all packages
    Force         = $rbz_force                              #Force all packages
    Timeout       = $timeout                                #Connection timeout in seconds (default 100)
    UpdateTimeout = $updatetimeout                          #Update timeout in seconds (default 1200)
    Threads       = 10                                      #Number of background jobs to use
    Push          = $push					                #Push to chocolatey
    PushAll       = $false                                  #Allow to push multiple packages at once
    PluginPath    = ''                                      #Path to user plugins
    NoCheckChocoVersion = $chocochk							#NoCheckChocoVersion All Packages
    IgnoreOn      = @(                                      #Error message parts to set the package ignore status
      'Could not create SSL/TLS secure channel'
      'Could not establish trust relationship'
      'The operation has timed out'
      'Internal Server Error'
      'Service Temporarily Unavailable'
      'Bad content type'
    )
    RepeatOn      = @(                                      #Error message parts on which to repeat package updater
      'Could not create SSL/TLS secure channel'             # https://github.com/chocolatey/chocolatey-coreteampackages/issues/718
      'Could not establish trust relationship'              # -||-
      'Unable to connect'
      'The remote name could not be resolved'
      'Choco pack failed with exit code 1'                  # https://github.com/chocolatey/chocolatey-coreteampackages/issues/721
      'The operation has timed out'
      'Internal Server Error'
      # 'An exception occurred during a WebClient request'
      'remote session failed with an unexpected state'
      'Unable to connect to the remote server'              # Update to recheck on this error
    )
    #RepeatSleep   = 250                                    #How much to sleep between repeats in seconds, by default 0
    #RepeatCount   = 2                                      #How many times to repeat on errors, by default 1

    Report = @{
        Type = 'markdown'                                   #Report type: markdown or text
        Path = "$AUdiag_log"						        #Path where to save the report
        # Params= @{                                          #Report parameters:
            # Github_UserRepo = $Env:github_user_repo         #  Markdown: shows user info in upper right corner
            # NoAppVeyor  = $false                            #  Markdown: do not show AppVeyor build shield
            # UserMessage = "[Ignored](#ignored) | [History](#update-history) | [Force Test](https://gist.github.com/$Env:gist_id_test) | [Releases](https://github.com/$Env:github_user_repo/tags) | **TESTING AU NEXT VERSION**"       #  Markdown, Text: Custom user message to show
            # NoIcons     = $false                            #  Markdown: don't show icon[Releases](https://github.com/$Env:github_user_repo/tags) 
            # IconSize    = 32                                #  Markdown: icon size
            # Title       = ''                                #  Markdown, Text: TItle of the report, by default 'Update-AUPackages'
        # }
    }

    # History = @{
        # Lines = 90                                          #Number of lines to show
        # Github_UserRepo = $Env:github_user_repo             #User repo to be link to commits
        # Path = "$PSScriptRoot\Update-History.md"            #Path where to save history
    # }

    # Gist = @{
        # Id     = $Env:gist_id                               #Your gist id; leave empty for new private or anonymous gist
        # ApiKey = $Env:github_api_key                        #Your github api key - if empty anoymous gist is created
        # Path   = "$PSScriptRoot\Update-AUPackages.md", "$PSScriptRoot\Update-History.md"       #List of files to add to the gist
    # }

    # Git = @{
        # User     = ''                                       #Git username, leave empty if github api key is used
        # Password = $Env:github_api_key                      #Password if username is not empty, otherwise api key
    # }

    # GitReleases = @{
      # ApiToken = $Env:github_api_key
      # ReleaseType = 'package'
    # }

    RunInfo = @{
        # Exclude = 'password', 'apikey', 'apitoken'          #Option keys which contain those words will be removed
        Path    = "$AUdiag_xml"                               #Path where to save the run info
    }

    # Mail = if ($Env:mail_user) {
            # @{
                # To         = $Env:mail_user
                # Server     = $Env:mail_server
                # UserName   = $Env:mail_user
                # Password   = $Env:mail_pass
                # Port       = $Env:mail_port
                # EnableSsl  = $Env:mail_enablessl -eq 'true'
                # Attachment = "$PSScriptRoot\update_info.xml"
                # UserMessage = "Update status: Update status: https://gist.github.com/choco-bot/$Env:gist_id"
                # SendAlways  = $false                        #Send notifications every time
             # }
           # } else {}
    }
    
cd $au_Root
sleep 15
updateall -Options $Options
sleep 30
