
  $releases = "https://get.adobe.com/en/flashplayer/?activex" # URL to for GetLatest
  $HTML = Invoke-WebRequest -Uri $releases
  $try = ($HTML.ParsedHtml.getElementsByTagName('p') | Where{ $_.className -eq 'NoBottomMargin' } ).innerText
  $try = $try  -split "\r?\n"
  $try = $try[0] -replace ' ', ' = '
  $try =  ConvertFrom-StringData -StringData $try
  $CurrentVersion = ( $try.Version )
  $majorVersion = ([version] $CurrentVersion).Major

  $url32 = "https://download.macromedia.com/pub/flashplayer/pdc/${CurrentVersion}/install_flash_player_${majorVersion}_active_x.msi"

  #$packageVersion = Get-Padded-Version $CurrentVersion $padVersionUnder

  return @{ URL32 = $url32; Version = $packageVersion; RemoteVersion = $CurrentVersion; majorVersion = $majorVersion; }
