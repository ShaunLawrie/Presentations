Import-Module "$PSScriptRoot\assets\OpenF1.psm1" -Force

$accentColor = "Red"
Set-SpectreColors -AccentColor $accentColor

Get-F1Logo | Format-SpectrePanel -Color White -Expand

$meetings = Get-F1Meetings
Write-SpectreHost ""
$selectedMeeting = Read-SpectreSelection -Title "What session are you interested in?" -Choices $meetings -ChoiceLabelProperty meeting_name

Write-SpectreHost "You selected meeting [$accentColor]$($selectedMeeting.meeting_name)[/]."
$sessions = Get-F1MeetingSessions -MeetingKey $selectedMeeting.meeting_key

Write-SpectreHost ""
$sessions | Format-SpectreTable

Write-SpectreHost ""
$selectedSession = Read-SpectreSelection -Title "What session are you interested in?" -Choices $sessions -ChoiceLabelProperty session_name

Write-SpectreHost "You selected session [$accentColor]$($selectedSession.session_name)[/] for meeting [$accentColor]$($selectedMeeting.meeting_name)[/]."

$teams = Get-F1SessionDrivers -SessionKey 9488 $selectedSession.session_key | Group-Object -Property team_name

Write-SpectreHost ""
Write-SpectreRule "Race Details"
Write-SpectreHost ""
$drivers = $teams | ForEach-Object { $_.Group } | Sort-Object -Property full_name
$teamsTree = @{
  Value = "Teams"
  Children = @()
}
foreach ($team in $teams) {
  $teamName = $null
  $driverDetails = @()
  foreach ($driver in $team.Group) {
    if ($null -eq $teamName) {
      $teamName = "[black on #$($driver.team_colour)] [/][#$($driver.team_colour)] $($driver.team_name)[/]"
    }
    $driverDetails += @{
      Value = "$($driver.full_name) (#$($driver.driver_number))"
    }
  }
  $teamsTree.Children += @{
    Value = $teamName
    Children = $driverDetails
  }
}
$teamsTree | Format-SpectreTree -Color Grey35

Write-SpectreHost ""
$selectedDriver = Read-SpectreSelection -Title "What driver are you interested in?" -Choices $drivers -ChoiceLabelProperty full_name -EnableSearch

Write-SpectreHost "You selected driver [$accentColor]$($selectedDriver.full_name)[/] for session [$accentColor]$($selectedSession.session_name)[/] in meeting [$accentColor]$($selectedMeeting.meeting_name)[/]."

$driverLaps = Get-F1SessionDriverLaps -SessionKey $selectedSession.session_key -DriverNumber $selectedDriver.driver_number
$lapsWithTimes = $driverLaps | Where-Object { $_.lap_duration }
$slowestLap = $lapsWithTimes | Sort-Object -Property lap_duration -Descending | Select-Object -First 1
$fastestLap = $lapsWithTimes | Sort-Object -Property lap_duration | Select-Object -First 1
$lapChartItems = $lapsWithTimes | ForEach-Object {
  $color = if ($_.lap_duration -eq $slowestLap.lap_duration) { "Red" } elseif ($_.lap_duration -eq $fastestLap.lap_duration) { "Green" } else { "Grey35" }
  New-SpectreChartItem -Label "Lap $($_.lap_number)" -Color $color -Value $_.lap_duration
}
$lapChartItems | Format-SpectreBarChart -Label "Lap Durations"

# Use spectre live display to show the drivers sector times for each lap

$lapData = Get-F1SessionDriverCarData -SessionKey $selectedSession.session_key -DriverNumber $selectedDriver.driver_number
$sortedLapData = $lapData | Sort-Object -Property date
$mapData = Get-F1SessionDriverLocations -SessionKey $selectedSession.session_key -DriverNumber $selectedDriver.driver_number
$sortedMapData = $mapData | Sort-Object -Property date
$startDate = $selectedSession.date_start
$filteredLapData = $sortedLapData | Where-Object { $_.date -ge $startDate }
$filteredMapData = $sortedMapData | Where-Object { $_.date -ge $startDate }

# for the map data it needs to rescale from centered around zero to: x >= 0, y >= 0
$xLimits = $filteredMapData | Measure-Object -Property x -Minimum -Maximum
$yLimits = $filteredMapData | Measure-Object -Property y -Minimum -Maximum
$xOffset = $xLimits.Minimum * -1
$yOffset = $yLimits.Minimum * -1
$xMax = $xLimits.Maximum + $xOffset
$yMax = $yLimits.Maximum + $yOffset

Write-SpectreHost ""
$answer = Read-SpectreConfirm -Message "Start the live [red]race data[/] display?"
if (!$answer) {
  return
}

$rootLayout = New-SpectreLayout -Name "root" -Rows @(
  (New-SpectreLayout -Name "frame" -Data "empty" -Ratio 1 -MinimumSize 11),
  (New-SpectreLayout -Name "toprow" -Ratio 3 -Columns @(
    (New-SpectreLayout -Name "gauges" -Data "empty" -Ratio 8),
    (New-SpectreLayout -Name "gear" -Data "empty" -Ratio 2)
  ))
  (New-SpectreLayout -Name "bottomrow" -Ratio 7 -Columns @(
    (New-SpectreLayout -Name "map" -Data "empty" -Ratio 9)
  ))
)

function Get-RpmRows {
  param (
    [int] $rpm
  )
  $rpmMax = 13000
  $rpmGreenLimit = 8000
  $rpmOrangeLimit = 10000
  $rpmRedLimit = 12000

  $rpmGreen = if ($rpm -ge $rpmGreenLimit) { $rpmGreenLimit } else { $rpm }
  $rpmOrange = if ($rpm -ge $rpmOrangeLimit) { $rpmOrangeLimit - $rpmGreenLimit } else { [Math]::Max(0, $rpm - $rpmGreenLimit) }
  $rpmRed = if ($rpm -ge $rpmRedLimit) { $rpmRedLimit - $rpmOrangeLimit } else { [Math]::Max(0, $rpm - $rpmOrangeLimit) }
  $rpmGrey = $rpmMax - $rpmRed - $rpmOrange - $rpmGreen

  $chartItems = @(
    (New-SpectreChartItem -Label "RpmGreen" -Value $rpmGreen -Color "Green"),
    (New-SpectreChartItem -Label "RpmOrange" -Value $rpmOrange -Color Orange1),
    (New-SpectreChartItem -Label "RpmRed" -Value $rpmRed -Color "Red"),
    (New-SpectreChartItem -Label "RpmGrey" -Value $rpmGrey -Color Grey35)
  )
  return @(
    ("RPM: $rpm / $rpmMax"),
    ($chartItems | Format-SpectreBreakdownChart -HideTags),
    ""
  ) | Format-SpectreRows
}

function Get-SpeedRows {
  param (
    [int] $speed
  )
  $speedMax = 300
  $speedGreenLimit = 200
  $speedOrangeLimit = 250
  $speedRedLimit = 280
  
  $speedGreen = if ($speed -ge $speedGreenLimit) { $speedGreenLimit } else { $speed }
  $speedOrange = if ($speed -ge $speedOrangeLimit) { $speedOrangeLimit - $speedGreenLimit } else { [Math]::Max(0, $speed - $speedGreenLimit) }
  $speedRed = if ($speed -ge $speedRedLimit) { $speedRedLimit - $speedOrangeLimit } else { [Math]::Max(0, $speed - $speedOrangeLimit) }
  $speedGrey = $speedMax - $speedRed - $speedOrange - $speedGreen

  $chartItems = @(
    (New-SpectreChartItem -Label "SpeedGreen" -Value $speedGreen -Color "Green"),
    (New-SpectreChartItem -Label "SpeedOrange" -Value $speedOrange -Color Orange1),
    (New-SpectreChartItem -Label "SpeedRed" -Value $speedRed -Color "Red"),
    (New-SpectreChartItem -Label "SpeedGrey" -Value $speedGrey -Color Grey35)
  )

  return @(
    ("Speed: $speed / $speedMax"),
    ($chartItems | Format-SpectreBreakdownChart -HideTags),
    ""
  ) | Format-SpectreRows
}

function Get-PedalsRows {
  param (
    [int] $throttle,
    [int] $brake
  )
  $throttleMax = 100
  $brakeMax = 100

  $throttleGreen = if ($throttle -gt 0) { $throttle } else { 0 }
  $throttleGrey = $throttleMax - $throttleGreen

  $brakeGreen = if ($brake -gt 0) { $brake } else { 0 }
  $brakeGrey = $brakeMax - $brakeGreen

  $chartItemsThrottle = @(
    (New-SpectreChartItem -Label "ThrottleGreen" -Value $throttleGreen -Color "Green"),
    (New-SpectreChartItem -Label "ThrottleGrey" -Value $throttleGrey -Color Grey35)
  )
  
  $chartItemsBrake = @(
    (New-SpectreChartItem -Label "BrakeGreen" -Value $brakeGreen -Color "Red"),
    (New-SpectreChartItem -Label "BrakeGrey" -Value $brakeGrey -Color Grey35)
  )

  return @(
    ("Throttle: $throttle / $throttleMax"),
    ($chartItemsThrottle | Format-SpectreBreakdownChart -HideTags),
    "",
    ("Brake: $brake / $brakeMax"),
    ($chartItemsBrake | Format-SpectreBreakdownChart -HideTags),
    ""
  ) | Format-SpectreRows
}

function Get-GearRows {
  param (
    [int] $gear,
    [bool] $drs
  )
  
  $drsLabel = switch ($drs) {
    8 { "DRS: [white on orange1] Ready [/]" }
    9 { "DRS: [white on orange1] Ready [/]" }
    10 { "DRS: [white on green] Open [/]" }
    12 { "DRS: [white on green] Open [/]" }
    14 { "DRS: [white on green] Open [/]" }
    default { "DRS: [white on red] Off [/]" }
  }

  return @(
    "",
    "",
    (Write-SpectreFigletText -Alignment Center -Text "$gear" -FigletFontPath ".\assets\ansi-regular.flf" -PassThru),
    (Write-SpectreHost $drsLabel -Justify Center -PassThru)
  ) | Format-SpectreRows
}

function Get-MapCanvas {
  param (
    [hashtable] $mapData,
    [int] $x,
    [int] $y,
    [int] $xOffset,
    [int] $yOffset,
    [int] $xMax,
    [int] $yMax,
    [bool] $braking
  )

  $scaledX = [Math]::Floor((($x + $xOffset) / $xMax) * ($mapData.Track.Width - 4))
  $scaledY = [Math]::Floor((($y + $yOffset) / $yMax) * ($mapData.Track.Height - 4))

  if ($mapData.PreviousX -ne -1 -and $mapData.PreviousY -ne -1) {
    $color = ($braking) ? [Spectre.Console.Color]::Grey15 : [Spectre.Console.Color]::Grey35
    $mapData.Track = $mapData.Track.SetPixel($mapData.PreviousX, $mapData.PreviousY, $color)
  }

  for ($j = 0; $j -le $height; $j++) {
    for ($i = 0; $i -le $width; $i++) {
      if ($i -eq $scaledX -and $j -eq $scaledY) {
        $mapData.Track = $mapData.Track.SetPixel($i, $j, [Spectre.Console.Color]::Red)
        $mapData.PreviousX = $i
        $mapData.PreviousY = $j
      }
    }
  }

  return $mapData
}

Invoke-SpectreLive -Data $rootLayout -ScriptBlock {
  param ($Context)

  $frameCount = 0

  # Use a smaller than real size canvas for a bit of speed
  $width = [int](($Host.UI.RawUI.BufferSize.Width / 2) - 2)
  $height = [int]($Host.UI.RawUI.WindowSize.Height / 2)
  $track = [Spectre.Console.Canvas]::new($width, $height)
  for ($j = 0; $j -lt $height; $j++) {
    for ($i = 0; $i -lt $width; $i++) {
      $track = $track.SetPixel($i, $j, [Spectre.Console.Color]::DarkSeaGreen4)
    }
  }
  $mapData = @{
    Track = $track
    PreviousX = -1
    PreviousY = -1
  }

  foreach ($frame in $filteredLapData) {
    $mapFrame = $filteredMapData[$frameCount]

    $framePanel = @(
      (Get-F1Logo | Format-SpectrePanel -Color White -Expand -Height 8),
      ("Frame: $([int]$frameCount++), Date: $($frame.date)")
    ) | Format-SpectreRows | Format-SpectrePanel -Border None -Expand

    $rpmRows = Get-RpmRows -rpm $frame.rpm  
    $pedalsRows = Get-PedalsRows -throttle $frame.throttle -brake $frame.brake
    $speedRows = Get-SpeedRows -speed $frame.speed
    $gearRows = Get-GearRows -gear $frame.n_gear -drs $frame.drs
    $dataPanel = @( $rpmRows, $pedalsRows, $speedRows ) | Format-SpectreRows | Format-SpectrePanel -Border None -Expand

    $mapData = Get-MapCanvas -mapData $mapData -x $mapFrame.x -y $mapFrame.y -xOffset $xOffset -yOffset $yOffset -xMax $xMax -yMax $yMax -braking ($frame.brake -gt 90)
    $mapPanel = $mapData.Track | Format-SpectrePanel -Border None -Expand

    $rootLayout["frame"].Update($framePanel) | Out-Null
    $rootLayout["gauges"].Update($dataPanel) | Out-Null
    $rootLayout["gear"].Update($gearRows) | Out-Null
    $rootLayout["map"].Update($mapPanel) | Out-Null

    $Context.Refresh()

    Start-Sleep -Milliseconds 50
  }

  [Console]::ReadKey($true) | Out-Null
}