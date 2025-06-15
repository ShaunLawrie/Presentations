#!/usr/bin/env pwsh
<#
.SYNOPSIS
    PwshSpectreConsole Demo - Building Beautiful Terminal UIs with PowerShell
.DESCRIPTION
    This demo showcases how to create interactive console applications using PwshSpectreConsole.
    Features include Docker container management, image browsing, and various UI widgets.
.EXAMPLE
    .\PowerShell-Terminal-UI-Demo.ps1
#>

# Import required modules
Import-Module PwshSpectreConsole -Force

# Set color scheme for the demo
Set-SpectreColors -AccentColor "DeepSkyBlue2" -DefaultValueColor "Grey74"

# Main demo function
function Start-DockerDemo {
    <#
    .SYNOPSIS
        Main entry point for the Docker Terminal UI demo
    .DESCRIPTION
        Demonstrates various PwshSpectreConsole widgets while managing Docker containers
    #>
    
    Clear-Host
    
    # 1. Display header with figlet text
    Write-SpectreFigletText -Text "Docker UI" -Alignment "Center" -Color "DeepSkyBlue2"
    Write-SpectreHost ""
    
    # 2. Display horizontal rule with subtitle
    Write-SpectreRule -Title "PowerShell Terminal UI Demo" -Alignment "Center" -Color "DeepSkyBlue2"
    Write-SpectreHost ""
    
    # Welcome message in a panel
    $welcomeMessage = @"
Welcome to the Docker Terminal UI Demo!

This demonstration showcases various PwshSpectreConsole widgets:
• Beautiful text formatting and panels
• Interactive selection menus
• Progress indicators and status displays
• Dynamic layouts and live updates
• Integration with external APIs

Let's explore what we can build with PowerShell and Spectre Console!
"@
    
    Format-SpectrePanel -Data $welcomeMessage -Header "Welcome" -Border "Rounded" -Color "Green" | Out-SpectreHost
    Write-SpectreHost ""
    
    # Main menu loop
    do {
        $choice = Show-MainMenu
        
        switch ($choice) {
            "Docker Container Management" { Show-ContainerManagement }
            "Browse Docker Hub Images" { Show-DockerHubBrowser }
            "Widget Showcase" { Show-WidgetShowcase }
            "Exit" { return }
        }
        
        Read-SpectrePause -Message "Press [yellow]Enter[/] to return to main menu..."
        
    } while ($choice -ne "Exit")
}

function Show-MainMenu {
    <#
    .SYNOPSIS
        Displays the main menu and returns the user's selection
    #>
    
    Write-SpectreRule -Title "Main Menu" -Color "DeepSkyBlue2"
    
    $choices = @(
        "Docker Container Management",
        "Browse Docker Hub Images", 
        "Widget Showcase",
        "Exit"
    )
    
    return Read-SpectreSelection -Message "What would you like to do?" -Choices $choices -Color "DeepSkyBlue2"
}

function Show-ContainerManagement {
    <#
    .SYNOPSIS
        Demonstrates Docker container management with various UI widgets
    #>
    
    Write-SpectreRule -Title "Docker Container Management" -Color "Green"
    
    # Check if Docker is available
    if (-not (Test-DockerAvailable)) {
        Write-SpectreHost "[red]Docker is not available or not running.[/]" 
        Write-SpectreHost "[yellow]This section will show simulated data for demo purposes.[/]"
        Write-SpectreHost ""
        Show-SimulatedContainerManagement
        return
    }
    
    # Get actual Docker containers
    $containers = Get-DockerContainers
    
    if (-not $containers) {
        Write-SpectreHost "[yellow]No containers found. Creating some sample containers for demo...[/]"
        Create-SampleContainers
        $containers = Get-DockerContainers
    }
    
    if ($containers) {
        # 3. Display containers in a table
        $containers | Format-SpectreTable -Title "Docker Containers" -Color "Green" | Out-SpectreHost
        
        # 4. Action selection
        $action = Read-SpectreSelection -Message "What would you like to do?" -Choices @(
            "Start containers", 
            "Stop containers", 
            "View logs", 
            "Remove containers",
            "Back to main menu"
        ) -Color "Green"
        
        switch ($action) {
            "Start containers" { Start-SelectedContainers $containers }
            "Stop containers" { Stop-SelectedContainers $containers }
            "View logs" { Show-ContainerLogs $containers }
            "Remove containers" { Remove-SelectedContainers $containers }
        }
    }
}

function Show-SimulatedContainerManagement {
    <#
    .SYNOPSIS
        Shows simulated container management when Docker is not available
    #>
    
    # Create sample container data
    $containers = @(
        [PSCustomObject]@{
            Names = "nginx-web"
            Image = "nginx:latest"
            Status = "Up 2 hours"
            Ports = "80:8080"
            ID = "abc123"
        },
        [PSCustomObject]@{
            Names = "redis-cache"
            Image = "redis:alpine"
            Status = "Up 1 day"
            Ports = "6379:6379"
            ID = "def456"
        },
        [PSCustomObject]@{
            Names = "postgres-db"
            Image = "postgres:13"
            Status = "Exited (0) 3 hours ago"
            Ports = ""
            ID = "ghi789"
        }
    )
    
    # Display containers in a table
    $containers | Format-SpectreTable -Title "Docker Containers (Simulated)" -Color "Green" | Out-SpectreHost
    
    # Action selection
    $action = Read-SpectreSelection -Message "What would you like to do?" -Choices @(
        "Start containers", 
        "Stop containers", 
        "View logs", 
        "Back to main menu"
    ) -Color "Green"
    
    switch ($action) {
        "Start containers" { 
            # 5. Multi-selection for containers
            $selected = Read-SpectreMultiSelection -Message "Select containers to start:" -Choices $containers -ChoiceLabelProperty "Names" -Color "Green"
            if ($selected) {
                # 6. Progress spinner
                Invoke-SpectreCommandWithStatus -Title "Starting containers..." -Spinner "Dots" -Color "Green" -ScriptBlock {
                    Start-Sleep -Seconds 3
                    Write-SpectreHost "`n[green]✓[/] Started $($selected.Count) container(s)"
                }
            }
        }
        "Stop containers" {
            $selected = Read-SpectreMultiSelection -Message "Select containers to stop:" -Choices ($containers | Where-Object { $_.Status -like "Up*" }) -ChoiceLabelProperty "Names" -Color "Red"
            if ($selected) {
                Invoke-SpectreCommandWithStatus -Title "Stopping containers..." -Spinner "Dots" -Color "Red" -ScriptBlock {
                    Start-Sleep -Seconds 2
                    Write-SpectreHost "`n[red]✓[/] Stopped $($selected.Count) container(s)"
                }
            }
        }
        "View logs" {
            $selected = Read-SpectreSelection -Message "Select container to view logs:" -Choices $containers -ChoiceLabelProperty "Names" -Color "Blue"
            Show-SimulatedLogs $selected.Names
        }
    }
}

function Show-ContainerLogs {
    <#
    .SYNOPSIS
        Demonstrates live log viewing with layouts and live updates
    #>
    param(
        # The containers to choose from for log viewing
        $Containers
    )
    
    $selected = Read-SpectreSelection -Message "Select container to view logs:" -Choices $Containers -ChoiceLabelProperty "Names" -Color "Blue"
    
    if ($selected) {
        Show-LiveLogs $selected.Names
    }
}

function Show-SimulatedLogs {
    <#
    .SYNOPSIS
        Shows simulated live logs using layouts and live updates
    #>
    param(
        # The container name to show logs for
        [string]$ContainerName
    )
    
    Write-SpectreRule -Title "Live Logs - $ContainerName" -Color "Blue"
    
    # 7. Create layout for logs
    $layout = New-SpectreLayout -Name "root" -Rows @(
        (New-SpectreLayout -Name "header" -MinimumSize 3 -Ratio 1 -Data ("Loading...")),
        (New-SpectreLayout -Name "logs" -Ratio 10 -Data ("Connecting to container..."))
    )
    
    # 8. Live tailing with updates
    Invoke-SpectreLive -Data $layout -ScriptBlock {
        param([Spectre.Console.LiveDisplayContext] $Context)
        
        # Update header
        $headerPanel = "Container: [yellow]$ContainerName[/] | Status: [green]Running[/] | Time: [grey]$(Get-Date -Format 'HH:mm:ss')[/]" | 
            Format-SpectrePanel -Expand -Color "Blue"
        $layout["header"].Update($headerPanel) | Out-Null
        
        # Simulate log entries
        $logEntries = @()
        $logMessages = @(
            "Starting application server...",
            "Database connection established",
            "Loading configuration from /app/config.json",
            "HTTP server listening on port 8080",
            "Processing incoming request from 192.168.1.100",
            "Cache miss for key 'user_sessions'",
            "Executing database query: SELECT * FROM users",
            "Response sent: 200 OK (45ms)",
            "Memory usage: 234MB / 512MB",
            "GC cleanup completed in 12ms"
        )
        
        for ($i = 0; $i -lt 20; $i++) {
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $level = @("INFO", "DEBUG", "WARN", "ERROR")[(Get-Random -Maximum 4)]
            $message = $logMessages[(Get-Random -Maximum $logMessages.Count)]
            
            $levelColor = switch ($level) {
                "INFO" { "green" }
                "DEBUG" { "blue" }
                "WARN" { "yellow" }
                "ERROR" { "red" }
            }
            
            $logEntry = "[$levelColor]$timestamp $level[/] $message"
            $logEntries += $logEntry
            
            # Keep only last 15 entries
            if ($logEntries.Count -gt 15) {
                $logEntries = $logEntries[-15..-1]
            }
            
            $logsPanel = ($logEntries -join "`n") | Format-SpectrePanel -Header "Live Logs" -Expand -Color "Grey"
            $layout["logs"].Update($logsPanel) | Out-Null
            
            $Context.Refresh()
            Start-Sleep -Milliseconds 500
        }
        
        Start-Sleep -Seconds 2
    }
}

function Show-DockerHubBrowser {
    <#
    .SYNOPSIS
        Demonstrates browsing Docker Hub images with API integration
    #>
    
    Write-SpectreRule -Title "Docker Hub Image Browser" -Color "Orange1"
    
    # Get popular images with progress indicator
    $images = Invoke-SpectreCommandWithStatus -Title "Fetching popular images from Docker Hub..." -Spinner "Dots2" -Color "Orange1" -ScriptBlock {
        try {
            Get-PopularDockerImages
        }
        catch {
            Write-SpectreHost "`n[red]Error fetching images: $($_.Exception.Message)[/]"
            return $null
        }
    }
    
    if (-not $images) {
        Write-SpectreHost "[yellow]Unable to fetch images from Docker Hub. Using sample data...[/]"
        $images = Get-SampleDockerImages
    }
    
    if ($images) {
        # 9. Display images in table with logos and details
        Show-DockerImageTable $images
        
        # 10. Allow selection and pulling
        $selectedImage = Read-SpectreSelection -Message "Select an image to pull:" -Choices $images -ChoiceLabelProperty "Name" -Color "Orange1"
        
        if ($selectedImage -and (Read-SpectreConfirm -Message "Pull image '$($selectedImage.Name)'?" -ConfirmSuccess "[green]Starting pull...[/]" -ConfirmFailure "[yellow]Pull cancelled[/]")) {
            Pull-DockerImage $selectedImage
        }
    }
}

function Show-WidgetShowcase {
    <#
    .SYNOPSIS
        Showcases various PwshSpectreConsole widgets and features
    #>
    
    Write-SpectreRule -Title "PwshSpectreConsole Widget Showcase" -Color "Magenta1"
    
    $widgets = @(
        "Charts and Graphs",
        "Trees and Grids", 
        "Progress Bars",
        "Calendars and Text",
        "Back to main menu"
    )
    
    $choice = Read-SpectreSelection -Message "Which widgets would you like to see?" -Choices $widgets -Color "Magenta1"
    
    switch ($choice) {
        "Charts and Graphs" { Show-ChartsDemo }
        "Trees and Grids" { Show-TreesAndGridsDemo }
        "Progress Bars" { Show-ProgressDemo }
        "Calendars and Text" { Show-CalendarAndTextDemo }
    }
}

function Show-ChartsDemo {
    <#
    .SYNOPSIS
        Demonstrates chart widgets
    #>
    
    Write-SpectreRule -Title "Charts and Graphs" -Color "Green"
    
    # Sample data
    $data = @()
    $data += New-SpectreChartItem -Label "Docker Pulls" -Value 1500 -Color "Blue"
    $data += New-SpectreChartItem -Label "Kubernetes Deployments" -Value 800 -Color "Green" 
    $data += New-SpectreChartItem -Label "CI/CD Builds" -Value 1200 -Color "Orange1"
    $data += New-SpectreChartItem -Label "Monitoring Alerts" -Value 300 -Color "Red"
    
    Write-SpectreHost "Bar Chart:"
    Format-SpectreBarChart -Data $data -Label "Monthly DevOps Activity" -Width 60 | Out-SpectreHost
    Write-SpectreHost ""
    
    Write-SpectreHost "Breakdown Chart:"
    Format-SpectreBreakdownChart -Data $data -Width 60 | Out-SpectreHost
}

function Show-TreesAndGridsDemo {
    <#
    .SYNOPSIS
        Demonstrates tree and grid widgets
    #>
    
    Write-SpectreRule -Title "Trees and Grids" -Color "Purple"
    
    # Tree example
    $tree = @{
        Value = "Docker Infrastructure"
        Children = @(
            @{
                Value = "Production"
                Children = @(
                    @{ Value = "Web Servers (3)"; Children = @() },
                    @{ Value = "Database Cluster"; Children = @() },
                    @{ Value = "Load Balancers (2)"; Children = @() }
                )
            },
            @{
                Value = "Development" 
                Children = @(
                    @{ Value = "Test Environment"; Children = @() },
                    @{ Value = "CI/CD Pipeline"; Children = @() }
                )
            }
        )
    }
    
    Write-SpectreHost "Tree Structure:"
    Format-SpectreTree -Data $tree -Color "Purple" | Out-SpectreHost
    Write-SpectreHost ""
    
    # Grid example
    Write-SpectreHost "Grid Layout:"
    $gridData = @(
        @("Service", "Status", "Uptime"),
        @("nginx", "[green]Running[/]", "99.9%"),
        @("postgres", "[green]Running[/]", "99.8%"),
        @("redis", "[yellow]Warning[/]", "95.2%")
    )
    
    Format-SpectreGrid -Data $gridData -Padding 2 | Out-SpectreHost
}

function Show-ProgressDemo {
    <#
    .SYNOPSIS
        Demonstrates progress indicators
    #>
    
    Write-SpectreRule -Title "Progress Indicators" -Color "Yellow"
    
    # Multi-task progress
    Invoke-SpectreCommandWithProgress -ScriptBlock {
        param([Spectre.Console.ProgressContext] $Context)
        
        $task1 = $Context.AddTask("Downloading images...")
        $task2 = $Context.AddTask("Extracting layers...")
        $task3 = $Context.AddTask("Configuring container...")
        
        for ($i = 0; $i -le 100; $i += 10) {
            $task1.Increment(10)
            Start-Sleep -Milliseconds 200
            
            if ($i -gt 30) {
                $task2.Increment(8)
            }
            
            if ($i -gt 60) {
                $task3.Increment(15)
            }
        }
    }
}

function Show-CalendarAndTextDemo {
    <#
    .SYNOPSIS
        Demonstrates calendar and text formatting widgets
    #>
    
    Write-SpectreRule -Title "Calendar and Text Formatting" -Color "Cyan"
    
    # Calendar with events
    $events = @{
        (Get-Date).AddDays(2).ToString('yyyy-MM-dd') = 'Docker Meetup'
        (Get-Date).AddDays(5).ToString('yyyy-MM-dd') = 'K8s Workshop'
        (Get-Date).AddDays(10).ToString('yyyy-MM-dd') = 'DevOps Conference'
    }
    
    Write-SpectreCalendar -Date (Get-Date) -Events $events | Out-SpectreHost
    Write-SpectreHost ""
    
    # Formatted text path
    Write-SpectreHost "Current Directory:"
    Get-Location | Format-SpectreTextPath | Out-SpectreHost
}

# Helper functions for Docker integration
function Test-DockerAvailable {
    <#
    .SYNOPSIS
        Tests if Docker is available and running
    #>
    
    try {
        $null = docker version 2>$null
        return $?
    }
    catch {
        return $false
    }
}

function Get-DockerContainers {
    <#
    .SYNOPSIS
        Gets Docker containers using docker ps command
    #>
    
    try {
        $containers = docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.ID}}" | 
            ConvertFrom-Csv -Delimiter "`t"
        return $containers
    }
    catch {
        return $null
    }
}

function Create-SampleContainers {
    <#
    .SYNOPSIS
        Creates sample containers for demo purposes
    #>
    
    Write-SpectreHost "[yellow]Creating sample containers for demo...[/]"
    
    Invoke-SpectreCommandWithStatus -Title "Setting up demo containers..." -Spinner "Dots" -Color "Blue" -ScriptBlock {
        try {
            # Try to create some lightweight demo containers
            docker run -d --name demo-nginx nginx:alpine 2>$null
            docker run -d --name demo-redis redis:alpine 2>$null
            Start-Sleep -Seconds 2
        }
        catch {
            # Ignore errors if containers already exist or Docker isn't available
        }
    }
}

function Start-SelectedContainers {
    <#
    .SYNOPSIS
        Starts selected Docker containers
    #>
    param(
        # The containers to choose from
        $Containers
    )
    
    $stoppedContainers = $Containers | Where-Object { $_.Status -notlike "Up*" }
    
    if (-not $stoppedContainers) {
        Write-SpectreHost "[yellow]No stopped containers to start.[/]"
        return
    }
    
    $selected = Read-SpectreMultiSelection -Message "Select containers to start:" -Choices $stoppedContainers -ChoiceLabelProperty "Names" -Color "Green"
    
    if ($selected) {
        Invoke-SpectreCommandWithStatus -Title "Starting containers..." -Spinner "Dots" -Color "Green" -ScriptBlock {
            foreach ($container in $selected) {
                try {
                    docker start $container.Names 2>$null
                }
                catch {
                    Write-SpectreHost "`n[red]Error starting $($container.Names)[/]"
                }
            }
            Start-Sleep -Seconds 1
        }
        Write-SpectreHost "[green]✓[/] Started $($selected.Count) container(s)"
    }
}

function Stop-SelectedContainers {
    <#
    .SYNOPSIS
        Stops selected Docker containers
    #>
    param(
        # The containers to choose from
        $Containers
    )
    
    $runningContainers = $Containers | Where-Object { $_.Status -like "Up*" }
    
    if (-not $runningContainers) {
        Write-SpectreHost "[yellow]No running containers to stop.[/]"
        return
    }
    
    $selected = Read-SpectreMultiSelection -Message "Select containers to stop:" -Choices $runningContainers -ChoiceLabelProperty "Names" -Color "Red"
    
    if ($selected) {
        Invoke-SpectreCommandWithStatus -Title "Stopping containers..." -Spinner "Dots" -Color "Red" -ScriptBlock {
            foreach ($container in $selected) {
                try {
                    docker stop $container.Names 2>$null
                }
                catch {
                    Write-SpectreHost "`n[red]Error stopping $($container.Names)[/]"
                }
            }
            Start-Sleep -Seconds 1
        }
        Write-SpectreHost "[red]✓[/] Stopped $($selected.Count) container(s)"
    }
}

function Remove-SelectedContainers {
    <#
    .SYNOPSIS
        Removes selected Docker containers
    #>
    param(
        # The containers to choose from
        $Containers
    )
    
    $selected = Read-SpectreMultiSelection -Message "Select containers to remove:" -Choices $Containers -ChoiceLabelProperty "Names" -Color "Red"
    
    if ($selected -and (Read-SpectreConfirm -Message "Are you sure you want to remove $($selected.Count) container(s)?" -ConfirmFailure "[yellow]Remove cancelled[/]")) {
        Invoke-SpectreCommandWithStatus -Title "Removing containers..." -Spinner "Dots" -Color "Red" -ScriptBlock {
            foreach ($container in $selected) {
                try {
                    docker rm -f $container.Names 2>$null
                }
                catch {
                    Write-SpectreHost "`n[red]Error removing $($container.Names)[/]"
                }
            }
            Start-Sleep -Seconds 1
        }
        Write-SpectreHost "[red]✓[/] Removed $($selected.Count) container(s)"
    }
}

function Show-LiveLogs {
    <#
    .SYNOPSIS
        Shows live logs for a Docker container
    #>
    param(
        # The container name to show logs for
        [string]$ContainerName
    )
    
    Write-SpectreRule -Title "Live Logs - $ContainerName" -Color "Blue"
    
    # Create layout for logs
    $layout = New-SpectreLayout -Name "root" -Rows @(
        (New-SpectreLayout -Name "header" -MinimumSize 3 -Ratio 1 -Data ("Loading...")),
        (New-SpectreLayout -Name "logs" -Ratio 10 -Data ("Connecting to container..."))
    )
    
    # Live tailing with actual Docker logs
    Invoke-SpectreLive -Data $layout -ScriptBlock {
        param([Spectre.Console.LiveDisplayContext] $Context)
        
        # Update header
        $headerPanel = "Container: [yellow]$ContainerName[/] | Status: [green]Running[/] | Time: [grey]$(Get-Date -Format 'HH:mm:ss')[/]" | 
            Format-SpectrePanel -Expand -Color "Blue"
        $layout["header"].Update($headerPanel) | Out-Null
        
        try {
            # Try to get actual Docker logs
            $logEntries = @()
            $logs = docker logs --tail 20 $ContainerName 2>&1
            
            if ($logs) {
                foreach ($line in $logs) {
                    $logEntries += "[grey]$(Get-Date -Format 'HH:mm:ss')[/] $line"
                }
            }
            else {
                # Fallback to simulated logs
                $logEntries = @(
                    "[grey]$(Get-Date -Format 'HH:mm:ss')[/] Container started",
                    "[grey]$(Get-Date -Format 'HH:mm:ss')[/] Application initialized",
                    "[grey]$(Get-Date -Format 'HH:mm:ss')[/] Ready to accept connections"
                )
            }
            
            $logsPanel = ($logEntries -join "`n") | Format-SpectrePanel -Header "Container Logs" -Expand -Color "Grey"
            $layout["logs"].Update($logsPanel) | Out-Null
            $Context.Refresh()
            
            Start-Sleep -Seconds 3
        }
        catch {
            # Show error in logs panel
            $errorPanel = "[red]Error accessing container logs: $($_.Exception.Message)[/]" | 
                Format-SpectrePanel -Header "Error" -Expand -Color "Red"
            $layout["logs"].Update($errorPanel) | Out-Null
            $Context.Refresh()
            Start-Sleep -Seconds 2
        }
    }
}

function Get-PopularDockerImages {
    <#
    .SYNOPSIS
        Fetches popular Docker images from Docker Hub API
    #>
    
    try {
        $uri = "https://hub.docker.com/v2/repositories/library/?page=1&page_size=10"
        $response = Invoke-RestMethod -Uri $uri -TimeoutSec 10
        
        $images = @()
        foreach ($repo in $response.results) {
            $imageData = [PSCustomObject]@{
                Name = $repo.name
                Description = $repo.description
                Stars = $repo.star_count
                Pulls = $repo.pull_count
                LastUpdated = $repo.last_updated
            }
            
            # Try to get logo
            try {
                $logoUri = "https://hub.docker.com/api/media/repos_logo/v1/$([System.Web.HttpUtility]::UrlEncode($repo.name))"
                $logoResponse = Invoke-RestMethod -Uri $logoUri -TimeoutSec 5
                $imageData | Add-Member -NotePropertyName "LogoUrl" -NotePropertyValue $logoResponse.logo_url
            }
            catch {
                $imageData | Add-Member -NotePropertyName "LogoUrl" -NotePropertyValue $null
            }
            
            $images += $imageData
        }
        
        return $images
    }
    catch {
        throw "Failed to fetch images from Docker Hub: $($_.Exception.Message)"
    }
}

function Get-SampleDockerImages {
    <#
    .SYNOPSIS
        Returns sample Docker image data when API is not available
    #>
    
    return @(
        [PSCustomObject]@{
            Name = "nginx"
            Description = "Official build of Nginx"
            Stars = 15000
            Pulls = 1000000000
            LastUpdated = (Get-Date).AddDays(-1)
            LogoUrl = $null
        },
        [PSCustomObject]@{
            Name = "redis"
            Description = "Redis is an open source key-value store"
            Stars = 9000
            Pulls = 500000000
            LastUpdated = (Get-Date).AddDays(-2)
            LogoUrl = $null
        },
        [PSCustomObject]@{
            Name = "postgres"
            Description = "PostgreSQL object-relational database"
            Stars = 8500
            Pulls = 300000000
            LastUpdated = (Get-Date).AddDays(-3)
            LogoUrl = $null
        },
        [PSCustomObject]@{
            Name = "node"
            Description = "Node.js is a JavaScript runtime"
            Stars = 7000
            Pulls = 800000000
            LastUpdated = (Get-Date).AddDays(-1)
            LogoUrl = $null
        },
        [PSCustomObject]@{
            Name = "python"
            Description = "Python is an interpreted programming language"
            Stars = 6500
            Pulls = 600000000
            LastUpdated = (Get-Date).AddDays(-2)
            LogoUrl = $null
        }
    )
}

function Show-DockerImageTable {
    <#
    .SYNOPSIS
        Displays Docker images in a formatted table
    #>
    param(
        # The images to display
        $Images
    )
    
    Write-SpectreHost "Popular Docker Hub Images:" 
    Write-SpectreHost ""
    
    # Create table data with enhanced formatting
    $tableData = @()
    foreach ($image in $Images) {
        $starsFormatted = "{0:N0}" -f $image.Stars
        $pullsFormatted = Format-Number $image.Pulls
        $lastUpdated = if ($image.LastUpdated) { 
            ([DateTime]$image.LastUpdated).ToString("MMM dd") 
        } else { 
            "Unknown" 
        }
        
        $tableData += [PSCustomObject]@{
            "Image" = "[yellow]$($image.Name)[/]"
            "Description" = $image.Description.Substring(0, [Math]::Min(50, $image.Description.Length)) + "..."
            "⭐ Stars" = "[yellow]$starsFormatted[/]"
            "📥 Pulls" = "[green]$pullsFormatted[/]"
            "Updated" = "[grey]$lastUpdated[/]"
        }
    }
    
    $tableData | Format-SpectreTable -Title "Docker Hub - Popular Images" -Color "Orange1" -AllowMarkup | Out-SpectreHost
}

function Format-Number {
    <#
    .SYNOPSIS
        Formats large numbers in a human-readable format
    #>
    param(
        # The number to format
        [long]$Number
    )
    
    if ($Number -ge 1000000000) {
        return "{0:N1}B" -f ($Number / 1000000000)
    }
    elseif ($Number -ge 1000000) {
        return "{0:N1}M" -f ($Number / 1000000)
    }
    elseif ($Number -ge 1000) {
        return "{0:N1}K" -f ($Number / 1000)
    }
    else {
        return "{0:N0}" -f $Number
    }
}

function Pull-DockerImage {
    <#
    .SYNOPSIS
        Pulls a Docker image with progress indication
    #>
    param(
        # The image to pull
        $Image
    )
    
    if (-not (Test-DockerAvailable)) {
        Write-SpectreHost "[yellow]Docker not available. Simulating pull...[/]"
        
        Invoke-SpectreCommandWithProgress -ScriptBlock {
            param([Spectre.Console.ProgressContext] $Context)
            
            $task = $Context.AddTask("Pulling $($Image.Name)...")
            
            for ($i = 0; $i -le 100; $i += 5) {
                $task.Increment(5)
                Start-Sleep -Milliseconds 100
            }
        }
        
        Write-SpectreHost "[green]✓[/] Successfully pulled [yellow]$($Image.Name)[/] (simulated)"
        return
    }
    
    # Real Docker pull with progress
    Invoke-SpectreCommandWithStatus -Title "Pulling $($Image.Name)..." -Spinner "Dots2" -Color "Orange1" -ScriptBlock {
        try {
            $result = docker pull $Image.Name 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-SpectreHost "`n[green]✓[/] Successfully pulled [yellow]$($Image.Name)[/]"
            }
            else {
                Write-SpectreHost "`n[red]✗[/] Failed to pull [yellow]$($Image.Name)[/]"
                Write-SpectreHost "[red]$result[/]"
            }
        }
        catch {
            Write-SpectreHost "`n[red]✗[/] Error pulling image: $($_.Exception.Message)"
        }
    }
}

# Check for required module and provide installation guidance
if (-not (Get-Module -ListAvailable -Name PwshSpectreConsole)) {
    Write-Host "PwshSpectreConsole module is required but not installed." -ForegroundColor Red
    Write-Host "Please install it using: Install-Module PwshSpectreConsole -Scope CurrentUser" -ForegroundColor Yellow
    exit 1
}

# Start the demo
try {
    Start-DockerDemo
}
catch {
    Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Stack trace: $($_.ScriptStackTrace)" -ForegroundColor Gray
}
finally {
    Write-SpectreHost ""
    Write-SpectreRule -Title "Thank you for exploring PwshSpectreConsole!" -Color "DeepSkyBlue2"
    Write-SpectreHost "Learn more at: [link]https://github.com/ShaunLawrie/PwshSpectreConsole[/]"
}
