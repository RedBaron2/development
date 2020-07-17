
<#
This is the options for updateall AU
modified on 2017-12-16
#>

param(
[Parameter(Position = 0)]
[string[]]$queue,
[string]$timeout = 200,
[string]$updatetimeout = 1300,
[bool]$rbz_force = $false,
[bool]$whatif = $false,
[bool]$push = $false,
[bool]$chocochk = $false
)

function posh-tee () {
param(
    [string]$a
)
    $a | Out-File -Append $AUmove_log
    write-host $a
}

# Set-Alias posh-tee Write-Host
$Date = (Get-Date -format "yyyy-MM-dd HH:mm:ss")
$Time = $Date + " "
$orgDir = Get-Location
$au_Root = '.\automatic';
$rbz_dir = '.\Queue'
	. (Join-Path $rbz_dir '.\Reset-Log.ps1')
# $Global:NoCheckChocoVersion=$Global:AU_NoCheckChocoVersion = $true;
$myDir = "${env:temp}\AU_Updates"
$myAU_report = "AU_update_report.log"
$myAU_report_xml = "AU_update_report.xml"

if ( $me -eq $null ) { $me=(${env:computername}) }
$AUdiag_log = "$myDir\$me" + "_$myAU_report"
$AUdiag_xml = "$myDir\$me" + "_$myAU_report_xml"
$AUmove_log = "$myDir\$me" + "_AU_simple.log"

if (!(Test-Path $AUmove_log)) {
	posh-tee "We are testing for $AUmove_log now`r`n"
		New-Item -ItemType "file" -Force -Path $AUmove_log
	}
if (!(Test-Path $AUdiag_log)) {
	write-host "We are testing for $AUdiag_log now`r`n"
		New-Item -ItemType "file" -Force -Path $AUdiag_log
	}
if (!(Test-Path $AUdiag_xml)) {
	write-host "We are testing for $AUdiag_xml now`r`n"
		New-Item -ItemType "file" -Force -Path $AUdiag_xml
	}

# $Options = [ordered]@{
        # Timeout = 100
        # Threads = 15
        # Push    = $false
          
        # Save text report in the local file report.txt
        # Report = @{
            # Type = 'text'
            # Path = "$AUdiag_log"
        # }
        
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
        # RunInfo = @{
            # Path = "$AUdiag_xml"
        # }

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
    # }
	
# AU Packages Template: https://github.com/majkinetor/au-packages-template

if (Test-Path $PSScriptRoot/update_vars.ps1) { . $PSScriptRoot/update_vars.ps1 }

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
    
function MoveIt() {
param(
    [string]$sourceDir = "$PSScriptRoot\automatic",
    [string]$destDir = "$PSScriptRoot\packages",
    [string]$format = "*.nupkg"
)
posh-tee "We are running the command now"
posh-tee "PSScriptRoot -$PSScriptRoot- sourceDir -$sourceDir- destDir -$destDir-"
Get-ChildItem -Path $sourceDir -Filter $format -Recurse | Foreach {$_} | Tee -File $AUmove_log -Append | Move-Item -Destination $destDir -force
posh-tee "Moved all the Packages to $destDir"
Get-ChildItem -Path $sourceDir -Filter "*.exe" -Recurse | Foreach {$_} | Tee -File $AUmove_log -Append | remove-item -force
posh-tee "Removed all the *.exe from $sourceDir"
Get-ChildItem -Path $sourceDir -Filter "*.msi" -Recurse | Foreach {$_} | Tee -File $AUmove_log -Append | remove-item -force
posh-tee "Removed all the *.msi from $sourceDir"
#added 2018-04-04 for removal of .zip files
Get-ChildItem -Path $sourceDir -Filter "*.zip" -Recurse | Foreach {$_} | Tee -File $AUmove_log -Append | remove-item -force
posh-tee "Removed all the *.zip from $sourceDir"
posh-tee "we are through running the command.`n`r Ending the script.`r`n"
}

posh-tee "`r`n$Time Starting $queue"  
cd $au_Root
"au_NoCheckChocoVersion -$au_NoCheckChocoVersion-" | Out-File -Append $AUmove_log
"NoCheckChocoVersion -$NoCheckChocoVersion-" | Out-File -Append $AUmove_log
sleep 5
updateall $queue -Options $Options
MoveIt
# Test-Package -Nu "$PSScriptRoot\packages" -Install -Uninstall
cd $orgDir
sleep 5
posh-tee "$Time Finishing $queue`r`n"
sleep 5
$AUdiag_log = Reset-Log -fileName $AUdiag_log -filesize 10kb -logcount 5
$AUdiag_xml = Reset-Log -fileName $AUdiag_xml -filesize 10kb -logcount 5
$AUmove_log = Reset-Log -fileName $AUmove_log -filesize 10kb -logcount 5
