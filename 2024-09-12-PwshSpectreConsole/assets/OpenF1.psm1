function Get-F1SessionDriverCarData {
  param (
    [string] $SessionKey,
    [string] $DriverNumber
  )
  return Get-F1CachedApiResponse -Url "/car_data?session_key=$SessionKey&driver_number=$DriverNumber"
}

function Get-F1SessionDrivers {
  param (
    [string] $SessionKey
  )
  return Get-F1CachedApiResponse -Url "/drivers?session_key=$SessionKey"
}

function Get-F1SessionIntervals {
  param (
    [string] $SessionKey
  )
  return Get-F1CachedApiResponse -Url "/intervals?session_key=$SessionKey"
}

function Get-F1SessionDriverLaps {
  param (
    [string] $SessionKey,
    [string] $DriverNumber
  )
  return Get-F1CachedApiResponse -Url "/laps?session_key=$SessionKey&driver_number=$DriverNumber"
}

function Get-F1SessionDriverLocations {
  param (
    [string] $SessionKey,
    [string] $DriverNumber
  )
  return Get-F1CachedApiResponse -Url "/location?session_key=$SessionKey&driver_number=$DriverNumber"
}

function Get-F1Meetings {
  param (
    [string] $Year = (Get-Date).Year
  )
  return Get-F1CachedApiResponse -Url "/meetings?year=$Year"
}

function Get-F1SessionPitStops {
  param (
    [string] $SessionKey
  )
  return Get-F1CachedApiResponse -Url "/pit?session_key=$SessionKey"
}

function Get-F1SessionDriverPosition {
  param (
    [string] $SessionKey,
    [string] $DriverNumber
  )
  return Get-F1CachedApiResponse -Url "/positions?session_key=$Session&driver_number=$DriverNumber"
}

function Get-F1SessionRaceControl {
  param (
    [string] $SessionKey
  )
  return Get-F1CachedApiResponse -Url "/race_control?session_key=$SessionKey"
}

function Get-F1MeetingSessions {
  param (
    [string] $MeetingKey
  )
  return Get-F1CachedApiResponse -Url "/sessions?meeting_key=$MeetingKey"
}

function Get-F1SessionStints {
  param (
    [string] $SessionKey
  )
  return Get-F1CachedApiResponse -Url "/stints?session_key=$SessionKey"
}

function Get-F1SessionTeamRadio {
  param (
    [string] $SessionKey
  )
  return Get-F1CachedApiResponse -Url "/team_radio?session_key=$Session"
}

function Get-F1SessionWeather {
  param (
    [string] $SessionKey
  )
  return Get-F1CachedApiResponse -Url "/weather?meeting_key=$SessionKey"
}

function Get-F1KnownGoodLapData {
  return Get-F1CachedApiResponse -Url "/car_data?session_key=9161&driver_number=81"
}

function Get-F1KnownGoodLocationData {
  return Get-F1CachedApiResponse -Url "/location?session_key=9161&driver_number=81"
}

<#
  These functions are used to cache the responses from the OpenF1 API, I don't want to deal with a flaky api during the presentation.
#>

$script:BaseUrl = "https://api.openf1.org/v1"
if ($null -eq $global:F1CachedApiResponses) {
  $global:F1CachedApiResponses = @{}
}

function Get-F1CachedApiResponse {
  param (
    [string] $Url
  )

  $absoluteUrl = "$script:BaseUrl$Url"

  $response = Invoke-SpectreCommandWithStatus -Title "Fetching $Url" -Spinner Dots -ScriptBlock {

    if ($global:F1CachedApiResponses.ContainsKey($absoluteUrl)) {
      Start-Sleep -Seconds 3
      return $global:F1CachedApiResponses[$absoluteUrl]
    }

    $response = Invoke-RestMethod -Uri $absoluteUrl -Method Get
    if ($null -eq $response) {
      throw "Failed to fetch $absoluteUrl"
    }
    $global:F1CachedApiResponses[$absoluteUrl] = $response
    return $response
  }

  return $response
}

function Reset-F1CachedApiResponses {
  $global:F1CachedApiResponses.Clear()
}

function Show-F1CachedApiResponses {
  function Update-SpectreCachedApiResponses {
    param (
      $Context,
      $Layouts,
      $SelectedIndex,
      $PreviewOffset
    )

    # Update the list
    $selectedKey = @($global:F1CachedApiResponses.Keys)[$SelectedIndex]
    $listData = $global:F1CachedApiResponses.Keys | Foreach-Object {
      if ($_ -eq $selectedKey) {
        return $_
      } else {
        return "[Grey35]$_[/]"
      }
    } | Format-SpectreRows
    $Layouts["list"].MinimumSize = $global:F1CachedApiResponses.Keys.Count
    $Layouts["list"].Update($listData) | Out-Null

    # Update the data preview
    $selectedData = $global:F1CachedApiResponses[$selectedKey] | ConvertTo-Json -WarningAction SilentlyContinue
    $selectedDataAfterOffset = $selectedData.Split("`n")[$PreviewOffset..1000] -join "`n"
    $selectedDataPanel = $selectedDataAfterOffset | Get-SpectreEscapedText | Format-SpectrePanel -Expand -Header "Selected Index $SelectedIndex"
    $Layouts["responses"].Update($selectedDataPanel) | Out-Null

    $Context.Refresh()
  }

  $rootLayout = New-SpectreLayout -Name "root" -Rows @(
    (New-SpectreLayout -Name "list" -Data "empty" -Ratio 1),
    (New-SpectreLayout -Name "responses" -Data "empty" -Ratio 12),
    (New-SpectreLayout -Name "help" -Data (Write-SpectreHost "Press [red]UpArrow[/] and [red]DownArrow[/] to navigate, [red]PageUp[/] and [red]PageDown[/] to scroll, [red]Backspace[/] to remove an item, [red]Ctrl+C[/] to select" -PassThru) -Ratio 1 -MinimumSize 1)
  )

  $selectedIndex = Invoke-SpectreLive -Data $rootLayout -ScriptBlock {
    param ($Context)

    $selectedIndex = 0
    $previewOffest = 0

    while ($true) {
      $WarningPreference = "SilentlyContinue"
      Update-SpectreCachedApiResponses -Context $Context -Layouts $rootLayout -SelectedIndex $selectedIndex -PreviewOffset $previewOffest

      [Console]::TreatControlCAsInput = $true
      $keyPress = [Console]::ReadKey($true)
      if ($keyPress.Key -eq "UpArrow") {
        $selectedIndex = ($selectedIndex -eq 0) ? $global:F1CachedApiResponses.Count - 1 : $selectedIndex - 1
        $previewOffest = 0
      } elseif ($keyPress.Key -eq "DownArrow") {
        $selectedIndex = ($selectedIndex + 1) % $global:F1CachedApiResponses.Count
        $previewOffest = 0
      } elseif ($keyPress.Key -eq "PageUp") {
        $previewOffest = [Math]::Max(0, ($previewOffest - 10))
      } elseif ($keyPress.Key -eq "PageDown") {
        $previewOffest = $previewOffest + 10
      } elseif ($keyPress.Key -eq "Backspace") {
        $global:F1CachedApiResponses.Remove(@($global:F1CachedApiResponses.Keys)[$selectedIndex])
        $selectedIndex = [Math]::Min($selectedIndex, $global:F1CachedApiResponses.Count - 1)
        $previewOffest = 0
      } elseif ($keyPress.Key -eq "C" -and $keyPress.Modifiers -eq "Control" -or $keyPress.Key -eq "Enter") {
        [Console]::TreatControlCAsInput = $false
        if ($keyPress.Key -eq "Enter") {
          return $selectedIndex
        }
        return $null
      }
    }
  }

  if ($null -eq $selectedIndex) {
    return
  }

  Write-Host "Selected index was $selectedIndex"

  $selectedKey = @($global:F1CachedApiResponses.Keys)[$selectedIndex]
  Write-Host "Selected key was $selectedKey"
  
  return $global:F1CachedApiResponses[$selectedKey]
}

<#
  Dumb visuals
#>

function Get-F1Logo {
  return Write-SpectreHost -PassThru -Message @"
           [red]▄▄█████████████████▀ ▄███▀    [/]
        [red]▄██▀▀▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ▄███▀      [/]
      [red]▄██▀▄██▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▄███▀        [/]
    [red]▄██▀▄██▀[/]              [red]▄███▀          [/]
  [red]▄██▀▄██▀[/]              [red]▄███▀  tm        [/]
[white]  F o r m u l a  1                       [/]
"@
}
