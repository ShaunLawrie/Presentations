#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Interactive Docker management demo using PwshSpectreConsole
    
.DESCRIPTION
    This demo showcases how to create beautiful, interactive console applications using the PwshSpectreConsole module.
    It provides a Docker management wizard that includes:
    - Container management (list, start, stop)
    - Image browsing from Docker Hub
    - Live log tailing
    - Beautiful UI components
    
.EXAMPLE
    .\DockerDemo.ps1
    
.NOTES
    Requires:
    - PwshSpectreConsole module
    - Docker installed and running
    - Internet connection for Docker Hub API
#>

#Requires -Module PwshSpectreConsole

[CmdletBinding()]
param()

#region Helper Functions

function Test-DockerAvailable {
    <#
    .SYNOPSIS
        Tests if Docker is available and running
    #>
    try {
        $null = docker version --format json 2>$null
        return $true
    }
    catch {
        return $false
    }
}

function Get-DockerContainers {
    <#
    .SYNOPSIS
        Gets a list of Docker containers
    #>
    param(
        # Include stopped containers
        [switch]$All
    )
    
    try {
        $dockerArgs = @('ps', '--format', 'json')
        if ($All) {
            $dockerArgs += '--all'
        }
        
        $output = docker @dockerArgs 2>$null
        if ($output) {
            $containers = $output | ForEach-Object { $_ | ConvertFrom-Json }
            return $containers | ForEach-Object {
                [PSCustomObject]@{
                    ID = $_.ID.Substring(0, 12)
                    Name = $_.Names
                    Image = $_.Image
                    Status = $_.Status
                    State = $_.State
                    Ports = $_.Ports -replace '0.0.0.0:', 'localhost:'
                }
            }
        }
        return @()
    }
    catch {
        Write-Warning "Failed to get Docker containers: $($_.Exception.Message)"
        return @()
    }
}

function Get-DockerHubPopularImages {
    <#
    .SYNOPSIS
        Gets popular images from Docker Hub
    #>
    param(
        # Number of images to retrieve
        [int]$Count = 10
    )
    
    try {
        $uri = "https://hub.docker.com/v2/repositories/library/?page=1&page_size=$Count"
        $response = Invoke-RestMethod -Uri $uri -Method Get
        
        $images = $response.results | ForEach-Object {
            [PSCustomObject]@{
                Name = $_.name
                Description = $_.description
                StarCount = $_.star_count
                PullCount = $_.pull_count
                LastUpdated = [DateTime]::Parse($_.last_updated)
                LogoUrl = $null  # Will be populated later
            }
        }
        
        # Get logo URLs
        foreach ($image in $images) {
            try {
                $logoUri = "https://hub.docker.com/api/media/repos_logo/v1/library%2F$($image.Name)"
                $logoResponse = Invoke-WebRequest -Uri $logoUri -Method Get -ErrorAction SilentlyContinue
                if ($logoResponse.StatusCode -eq 200) {
                    $image.LogoUrl = $logoUri
                }
            }
            catch {
                # Logo not available, continue without it
            }
        }
        
        return $images
    }
    catch {
        Write-Warning "Failed to get Docker Hub images: $($_.Exception.Message)"
        return @()
    }
}

function Start-DockerContainer {
    <#
    .SYNOPSIS
        Starts a Docker container
    #>
    param(
        # Container ID or name
        [string]$Container
    )
    
    try {
        docker start $Container 2>$null
        return $true
    }
    catch {
        return $false
    }
}

function Stop-DockerContainer {
    <#
    .SYNOPSIS
        Stops a Docker container
    #>
    param(
        # Container ID or name
        [string]$Container
    )
    
    try {
        docker stop $Container 2>$null
        return $true
    }
    catch {
        return $false
    }
}

function Get-DockerContainerLogs {
    <#
    .SYNOPSIS
        Gets logs from a Docker container
    #>
    param(
        # Container ID or name
        [string]$Container,
        # Number of lines to retrieve
        [int]$Lines = 50
    )
    
    try {
        $logs = docker logs --tail $Lines $Container 2>$null
        return $logs
    }
    catch {
        return @()
    }
}

#endregion

#region Main Demo Functions

function Show-WelcomeScreen {
    <#
    .SYNOPSIS
        Displays the welcome screen with title and introduction
    #>
    
    Clear-Host
    
    # Set theme colors
    Set-SpectreColors -AccentColor "Cyan1" -DefaultValueColor "Grey70"
    
    # Welcome header
    Write-SpectreFigletText -Text "Docker Wizard" -Alignment Center -Color "Cyan1"
    
    Write-SpectreRule -Title "PwshSpectreConsole Demo" -Alignment Center -Color "Cyan1"
    
    $welcomeText = @"
Welcome to the Docker Management Wizard!

This interactive demo showcases the power of PwshSpectreConsole for building
beautiful terminal user interfaces in PowerShell.

Features demonstrated:
• Container management with interactive selections
• Docker Hub image browsing with logos
• Live log tailing with dynamic layouts
• Beautiful tables, panels, and progress indicators
• Real-time status updates

Press any key to continue...
"@
    
    $welcomeText | Format-SpectrePanel -Header "Welcome" -Color "Blue" -Expand | Out-SpectreHost
    
    Read-SpectrePause -Message "Press [cyan1]any key[/] to start the demo..." -AnyKey
}

function Show-MainMenu {
    <#
    .SYNOPSIS
        Displays the main menu and returns the selected action
    #>
    
    Clear-Host
    Write-SpectreFigletText -Text "Docker Wizard" -Alignment Center -Color "Cyan1"
    Write-SpectreRule -Title "Main Menu" -Alignment Center -Color "Cyan1"
    
    $choices = @(
        "📦 Manage Containers",
        "🔍 Browse Docker Hub Images", 
        "📊 View Container Logs",
        "❌ Exit"
    )
    
    $selection = Read-SpectreSelection -Message "What would you like to do?" -Choices $choices -Color "Cyan1"
    
    return $selection
}

function Show-ContainerManagement {
    <#
    .SYNOPSIS
        Shows container management interface with enhanced visual feedback
    #>
    
    Clear-Host
    Write-SpectreRule -Title "📦 Container Management" -Color "Green"
    
    # Check if Docker is available
    if (-not (Test-DockerAvailable)) {
        "❌ Docker is not available or not running!`n`nPlease start Docker and try again." | Format-SpectrePanel -Color "Red" -Header "❌ Docker Error" | Out-SpectreHost
        Read-SpectrePause -Message "Press [red]any key[/] to return to main menu..." -AnyKey
        return
    }
    
    # Get containers with progress feedback
    $containers = Invoke-SpectreCommandWithProgress -ScriptBlock {
        param (
            [Spectre.Console.ProgressContext] $Context
        )
        
        $task = $Context.AddTask("Scanning for Docker containers...")
        $task.Increment(50)
        
        $allContainers = Get-DockerContainers -All
        $task.Increment(50)
        
        return $allContainers
    }
    
    if ($containers.Count -eq 0) {
        @"
No containers found on this system.

You can create containers by:
• Pulling images from Docker Hub
• Running: docker run hello-world
• Using Docker Compose
"@ | Format-SpectrePanel -Color "Yellow" -Header "ℹ️ Information" | Out-SpectreHost
        Read-SpectrePause -Message "Press [yellow]any key[/] to return to main menu..." -AnyKey
        return
    }
    
    # Enhance container display with status colors
    $enhancedContainers = $containers | ForEach-Object {
        $statusColor = switch ($_.State) {
            "running" { "[green]🟢 Running[/]" }
            "exited" { "[red]🔴 Stopped[/]" }
            "paused" { "[yellow]🟡 Paused[/]" }
            default { "[gray]⚪ Unknown[/]" }
        }
        
        $portsDisplay = if ($_.Ports) {
            $_.Ports -replace '0.0.0.0:', 'localhost:'
        } else {
            "[gray]No ports[/]"
        }
        
        [PSCustomObject]@{
            Name = $_.Name
            Image = $_.Image
            Status = $statusColor
            Ports = $portsDisplay
            ID = $_.ID
            State = $_.State
        }
    }
    
    # Display containers in a beautiful table
    $enhancedContainers | Format-SpectreTable -Title "🐳 Docker Containers" -Color "Green" -AllowMarkup -Expand | Out-SpectreHost
    
    # Container action menu
    $actions = @(
        "▶️ Start containers",
        "⏹️ Stop containers",
        "🔄 Refresh list",
        "⬅️ Back to main menu"
    )
    
    $action = Read-SpectreSelection -Message "Select an action:" -Choices $actions -Color "Green"
    
    switch ($action) {        "▶️ Start containers" {
            $stoppedContainers = $containers | Where-Object { $_.State -eq "exited" }
            if ($stoppedContainers.Count -eq 0) {
                "All containers are already running or in other states!" | Format-SpectrePanel -Color "Yellow" -Header "ℹ️ Information" | Out-SpectreHost
                Read-SpectrePause -AnyKey
                return
            }
            
            $selectedContainers = Read-SpectreMultiSelection -Message "Select containers to start:" -Choices $stoppedContainers -ChoiceLabelProperty "Name" -Color "Green"
            
            if ($selectedContainers.Count -gt 0) {
                Invoke-SpectreCommandWithProgress -ScriptBlock {
                    param (
                        [Spectre.Console.ProgressContext] $Context
                    )
                    
                    $task = $Context.AddTask("Starting containers...")
                    $processed = 0
                    
                    foreach ($container in $selectedContainers) {
                        $task.Description = "Starting $($container.Name)..."
                        
                        $result = Start-DockerContainer -Container $container.ID
                        
                        if ($result) {
                            Write-SpectreHost "✅ Started [green]$($container.Name)[/]"
                        } else {
                            Write-SpectreHost "❌ Failed to start [red]$($container.Name)[/]"
                        }
                        
                        $processed++
                        $task.Increment(100 / $selectedContainers.Count)
                    }
                }
                Write-SpectreHost "`n✅ Container start operations completed!"
            }
            Read-SpectrePause -AnyKey
        }
        
        "⏹️ Stop containers" {
            $runningContainers = $containers | Where-Object { $_.State -eq "running" }
            if ($runningContainers.Count -eq 0) {
                "No running containers to stop!" | Format-SpectrePanel -Color "Yellow" -Header "ℹ️ Information" | Out-SpectreHost
                Read-SpectrePause -AnyKey
                return
            }
            
            $selectedContainers = Read-SpectreMultiSelection -Message "Select containers to stop:" -Choices $runningContainers -ChoiceLabelProperty "Name" -Color "Red"
            
            if ($selectedContainers.Count -gt 0) {
                $confirm = Read-SpectreConfirm -Message "Are you sure you want to stop the selected containers?" -ConfirmSuccess "Proceeding with stop operation..." -ConfirmFailure "Stop operation cancelled"
                
                if ($confirm) {
                    Invoke-SpectreCommandWithProgress -ScriptBlock {
                        param (
                            [Spectre.Console.ProgressContext] $Context
                        )
                        
                        $task = $Context.AddTask("Stopping containers...")
                        $processed = 0
                        
                        foreach ($container in $selectedContainers) {
                            $task.Description = "Stopping $($container.Name)..."
                            
                            $result = Stop-DockerContainer -Container $container.ID
                            
                            if ($result) {
                                Write-SpectreHost "✅ Stopped [red]$($container.Name)[/]"
                            } else {
                                Write-SpectreHost "❌ Failed to stop [red]$($container.Name)[/]"
                            }
                            
                            $processed++
                            $task.Increment(100 / $selectedContainers.Count)
                        }
                    }
                    Write-SpectreHost "`n✅ Container stop operations completed!"
                }
            }
            Read-SpectrePause -AnyKey
        }
        
        "🔄 Refresh list" {
            Show-ContainerManagement
            return
        }
    }
}

function Show-DockerHubBrowser {
    <#
    .SYNOPSIS
        Shows Docker Hub image browser with logos and detailed information
    #>
    
    Clear-Host
    Write-SpectreRule -Title "🐳 Docker Hub Image Browser" -Color "Blue"
    
    # Show a progress bar while fetching data
    $images = Invoke-SpectreCommandWithProgress -ScriptBlock {
        param (
            [Spectre.Console.ProgressContext] $Context
        )
        
        $task = $Context.AddTask("Fetching popular images from Docker Hub...")
        $task.Increment(25)
        
        try {
            $uri = "https://hub.docker.com/v2/repositories/library/?page=1&page_size=10"
            $response = Invoke-RestMethod -Uri $uri -Method Get
            $task.Increment(50)
            
            $images = $response.results | ForEach-Object {
                [PSCustomObject]@{
                    Name = $_.name
                    Description = $_.description
                    StarCount = $_.star_count
                    PullCount = $_.pull_count
                    LastUpdated = [DateTime]::Parse($_.last_updated)
                    LogoUrl = $null
                }
            }
            $task.Increment(20)
            
            # Get logo URLs with progress
            $logoTask = $Context.AddTask("Fetching logo information...")
            $processed = 0
            foreach ($image in $images) {
                try {
                    $logoUri = "https://hub.docker.com/api/media/repos_logo/v1/library%2F$($image.Name)"
                    $logoResponse = Invoke-WebRequest -Uri $logoUri -Method Get -ErrorAction SilentlyContinue
                    if ($logoResponse.StatusCode -eq 200) {
                        $image.LogoUrl = $logoUri
                    }
                } catch {
                    # Logo not available
                }
                $processed++
                $logoTask.Increment(100 / $images.Count)
            }
            
            $task.Increment(5)
            return $images
        } catch {
            Write-Warning "Failed to get Docker Hub images: $($_.Exception.Message)"
            return @()
        }
    }
    
    if ($images.Count -eq 0) {
        "Failed to fetch images from Docker Hub! Check your internet connection." | Format-SpectrePanel -Color "Red" -Header "❌ Error" | Out-SpectreHost
        Read-SpectrePause -AnyKey
        return
    }
      # Create enhanced table data with images and formatted data
    $tableData = @()
    foreach ($image in $images) {
        # Try to get logo, but don't include it in table due to layout issues
        $logoStatus = if ($image.LogoUrl) { "�️" } else { "🐳" }
        
        $nameWithLink = "[link=https://hub.docker.com/_/$($image.Name)][blue]$($image.Name)[/][/]"
        $formattedPullCount = "{0:N0}" -f $image.PullCount
        $formattedStarCount = "⭐ {0:N0}" -f $image.StarCount
        
        # Truncate description intelligently
        $description = if ($image.Description.Length -gt 60) {
            $image.Description.Substring(0, 57) + "..."
        } else {
            $image.Description
        }
        
        $tableData += [PSCustomObject]@{
            Icon = $logoStatus
            Name = $nameWithLink
            Description = $description
            Stars = $formattedStarCount
            Pulls = $formattedPullCount
            Updated = $image.LastUpdated.ToString("yyyy-MM-dd")
        }
    }
    
    # Display images table
    $tableData | Format-SpectreTable -Property Icon, Name, Description, Stars, Pulls, Updated -Title "🐳 Popular Docker Images" -Color "Blue" -AllowMarkup -Expand | Out-SpectreHost
    
    # Show a sample logo if available
    if ($images[0].LogoUrl) {
        Write-SpectreHost "`n[gray]Sample logo for $($images[0].Name):[/]"
        try {
            Get-SpectreImage -ImagePath $images[0].LogoUrl -MaxWidth 30 | Out-SpectreHost
        } catch {
            Write-SpectreHost "[gray]Logo not available[/]"
        }
    }
    
    # Image selection
    $selectedImage = Read-SpectreSelection -Message "Select an image to pull:" -Choices $images -ChoiceLabelProperty "Name" -Color "Blue"
    
    if ($selectedImage) {
        $confirmPull = Read-SpectreConfirm -Message "Pull [blue]$($selectedImage.Name)[/] image?" -ConfirmSuccess "✅ Starting pull..." -ConfirmFailure "❌ Pull cancelled"
        
        if ($confirmPull) {
            $pullResult = Invoke-SpectreCommandWithStatus -Title "Pulling $($selectedImage.Name)..." -Spinner "Dots" -ScriptBlock {
                try {
                    docker pull $selectedImage.Name 2>$null
                    return $true
                } catch {
                    return $false
                }
            }
            
            if ($pullResult) {
                Write-SpectreHost "✅ Successfully pulled $($selectedImage.Name)"
            } else {
                Write-SpectreHost "❌ Failed to pull $($selectedImage.Name)"
            }
        }
    }
    
    Read-SpectrePause -AnyKey
}

function Show-ContainerLogs {
    <#
    .SYNOPSIS
        Shows container logs with live tailing
    #>
    
    Clear-Host
    Write-SpectreRule -Title "Container Logs Viewer" -Color "Yellow"
    
    # Check if Docker is available
    if (-not (Test-DockerAvailable)) {
        "❌ Docker is not available or not running!" | Format-SpectrePanel -Color "Red" -Header "Error" | Out-SpectreHost
        Read-SpectrePause -AnyKey
        return
    }
    
    # Get running containers
    $containers = Invoke-SpectreCommandWithStatus -Title "Loading containers..." -Spinner "Dots" -ScriptBlock {
        Get-DockerContainers
    }
    
    if ($containers.Count -eq 0) {
        "No running containers found!" | Format-SpectrePanel -Color "Yellow" -Header "Information" | Out-SpectreHost
        Read-SpectrePause -AnyKey
        return
    }
    
    # Select container
    $selectedContainer = Read-SpectreSelection -Message "Select a container to view logs:" -Choices $containers -ChoiceLabelProperty "Name" -Color "Yellow"
    
    if (-not $selectedContainer) {
        return
    }
    
    Clear-Host
    
    # Create layout for logs
    $layout = New-SpectreLayout -Name "root" -Rows @(
        (New-SpectreLayout -Name "header" -MinimumSize 3 -Ratio 1 -Data "Loading..."),
        (New-SpectreLayout -Name "logs" -Ratio 10 -Data "Loading logs...")
    )
    
    # Live log viewer
    Invoke-SpectreLive -Data $layout -ScriptBlock {
        param (
            [Spectre.Console.LiveDisplayContext] $Context
        )
        
        $logHistory = @()
        $refreshCount = 0
        
        while ($true) {
            $refreshCount++
            
            # Update header
            $headerText = "📋 Logs for $($selectedContainer.Name) - Press [red]Ctrl+C[/] to exit - Refresh #$refreshCount"
            $headerPanel = $headerText | Format-SpectrePanel -Header "Container Logs" -Color "Yellow" -Expand
            $layout["header"].Update($headerPanel) | Out-Null
            
            # Get latest logs
            try {
                $newLogs = Get-DockerContainerLogs -Container $selectedContainer.ID -Lines 20
                if ($newLogs) {
                    $logHistory = $newLogs | Select-Object -Last 50  # Keep last 50 lines
                }
            } catch {
                $logHistory = @("Error fetching logs: $($_.Exception.Message)")
            }
            
            # Format logs
            if ($logHistory.Count -gt 0) {
                $logText = ($logHistory | ForEach-Object { 
                    $timestamp = Get-Date -Format "HH:mm:ss"
                    "[$timestamp] $_" 
                }) -join "`n"
            } else {
                $logText = "No logs available"
            }
            
            $logPanel = $logText | Format-SpectrePanel -Header "Live Logs" -Color "Green" -Expand
            $layout["logs"].Update($logPanel) | Out-Null
            
            $Context.Refresh()
            
            # Check for exit condition
            if ([Console]::KeyAvailable) {
                $key = [Console]::ReadKey($true)
                if ($key.Key -eq "C" -and $key.Modifiers -eq "Control") {
                    break
                }
            }
            
            Start-Sleep -Seconds 2
        }
    }
}

#endregion

#region Main Script

function Start-DockerDemo {
    <#
    .SYNOPSIS
        Main entry point for the Docker demo
    #>
    
    try {
        # Show welcome screen
        Show-WelcomeScreen
        
        # Main loop
        while ($true) {
            $action = Show-MainMenu
            
            switch ($action) {
                "📦 Manage Containers" {
                    Show-ContainerManagement
                }
                "🔍 Browse Docker Hub Images" {
                    Show-DockerHubBrowser
                }
                "📊 View Container Logs" {
                    Show-ContainerLogs
                }
                "❌ Exit" {
                    Clear-Host
                    Write-SpectreFigletText -Text "Goodbye!" -Alignment Center -Color "Cyan1"
                    Write-SpectreHost "Thanks for trying the PwshSpectreConsole Docker Demo!"
                    Write-SpectreHost "Learn more at: [link]https://pwshspectreconsole.com[/]"
                    return
                }
            }
        }
    }
    catch {
        Write-SpectreHost "❌ [red]An error occurred:[/] $($_.Exception.Message)"
        Write-SpectreHost "Stack trace:"
        Write-SpectreHost ($_.ScriptStackTrace | Get-SpectreEscapedText)
    }
}

# Check for required module
if (-not (Get-Module -Name PwshSpectreConsole -ListAvailable)) {
    Write-Host "❌ PwshSpectreConsole module is required but not installed." -ForegroundColor Red
    Write-Host "Install it with: Install-Module PwshSpectreConsole -Scope CurrentUser" -ForegroundColor Yellow
    exit 1
}

# Import module if not already loaded
if (-not (Get-Module -Name PwshSpectreConsole)) {
    Import-Module PwshSpectreConsole
}

# Start the demo
Start-DockerDemo

#endregion
