#requires -Module PwshSpectreConsole

<#
.SYNOPSIS
    Demonstrates the features of PwshSpectreConsole with a Docker-themed interactive CLI.

.DESCRIPTION
    This demo showcases how to create beautiful, interactive console applications using PwshSpectreConsole.
    It creates a Docker management tool that demonstrates various widgets and features including:
    - Figlet text for headers
    - Panels and rules for layout
    - Tables for data display
    - Selection prompts for user interaction
    - Status spinners for operations
    - Live layouts for real-time data
    - Integration with web APIs
    - Image display capabilities

.NOTES
    Requires PwshSpectreConsole module
    Docker installation is optional - demo works without Docker
#>

param(
    # Skip Docker availability check and use mock data only
    [switch]$UseMockData
)

# Set color theme
Set-SpectreColors -AccentColor "DodgerBlue1" -DefaultValueColor "Grey70"

function Show-DemoHeader {
    <#
    .SYNOPSIS
        Displays the demo header with figlet text and welcome message.
    #>
    Clear-Host
    
    # Main title with figlet text
    Write-SpectreFigletText -Text "Docker UI" -Alignment Center -Color "DodgerBlue1"
    
    # Subtitle with rule
    Write-SpectreRule -Title "PowerShell Terminal UI Design with PwshSpectreConsole" -Alignment Center -Color "Cyan1"
    
    # Welcome panel
    $welcomeText = @"
[yellow]Welcome to the Docker Management Demo![/]

This interactive demo showcases the power of [bold blue]PwshSpectreConsole[/] for creating 
beautiful terminal user interfaces in PowerShell.

Features demonstrated:
• [green]Figlet text[/] for impressive headers
• [green]Panels and rules[/] for organized layout  
• [green]Tables[/] for structured data display
• [green]Selection prompts[/] for user interaction
• [green]Status indicators[/] for operations
• [green]Live layouts[/] for real-time updates
• [green]API integration[/] with Docker Hub
• [green]Image display[/] for visual elements
"@
    
    $welcomeText | Format-SpectrePanel -Header "Demo Overview" -Border "Rounded" -Color "Yellow" -Expand
    
    Read-SpectrePause -Message "Press [bold cyan1]Enter[/] to start the demo..."
}

function Test-DockerAvailability {
    <#
    .SYNOPSIS
        Tests if Docker is available and returns containers if found.
    #>
    try {
        $null = Get-Command docker -ErrorAction Stop
        $dockerVersion = docker --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-SpectreHost "[green]✓[/] Docker detected: $dockerVersion"
            return $true
        }
    }
    catch {
        # Docker not available
    }
    
    Write-SpectreHost "[yellow]⚠[/] Docker not detected - using mock data for demonstration"
    return $false
}

function Get-MockContainers {
    <#
    .SYNOPSIS
        Returns mock container data for demonstration purposes.
    #>    return @(
        [PSCustomObject]@{
            Name = "nginx-web"
            Image = "docker.io/library/nginx:latest"
            Status = "running"
            Ports = "80:8080"
            Created = (Get-Date).AddDays(-5)
        },
        [PSCustomObject]@{
            Name = "redis-cache"
            Image = "redis:alpine"
            Status = "running"
            Ports = "6379:6379"
            Created = (Get-Date).AddDays(-3)
        },
        [PSCustomObject]@{
            Name = "postgres-db"
            Image = "registry.hub.docker.com/library/postgres:13"
            Status = "stopped"
            Ports = "5432:5432"
            Created = (Get-Date).AddDays(-7)
        },
        [PSCustomObject]@{
            Name = "mongodb"
            Image = "mongo:latest"
            Status = "running"
            Ports = "27017:27017"
            Created = (Get-Date).AddDays(-2)
        }
    )
}

function Get-RealContainers {
    <#
    .SYNOPSIS
        Gets real container data from Docker if available.
    #>
    try {
        $dockerOutput = docker ps -a --format json 2>$null
        if ($LASTEXITCODE -ne 0) {
            return @()
        }
        
        # Docker returns NDJSON (newline-delimited JSON), so we need to split and parse each line
        $containers = @()
        $lines = $dockerOutput -split "`n" | Where-Object { $_.Trim() -ne "" }
        
        foreach ($line in $lines) {
            try {
                $containerData = $line | ConvertFrom-Json
                $containers += [PSCustomObject]@{
                    Name = $containerData.Names
                    Image = $containerData.Image
                    Status = $containerData.Status
                    Ports = $containerData.Ports
                    Created = $containerData.CreatedAt
                }
            }
            catch {
                Write-SpectreHost "[yellow]Warning: Failed to parse container data: $line[/]"
                continue
            }
        }
        
        return $containers
    }
    catch {
        Write-SpectreHost "[red]Error getting containers: $($_.Exception.Message)[/]"
        return @()
    }
}

function Show-ContainerTable {
    <#
    .SYNOPSIS
        Displays containers in a formatted table.
    #>
    param(
        # Container data to display
        [array]$Containers
    )
    
    if ($Containers.Count -eq 0) {
        "No containers found" | Format-SpectrePanel -Header "Container Status" -Color "Yellow"
        return
    }
      # Create custom properties for better display
    $tableData = $Containers | ForEach-Object {
        $statusColor = switch ($_.Status) {
            { $_ -match "running" } { "green" }
            { $_ -match "stopped" } { "red" }
            { $_ -match "exited" } { "orange1" }
            default { "white" }
        }
        
        # Extract just the image name and tag (remove repository prefix)
        $imageName = $_.Image
        if ($imageName -match '/') {
            # If image contains '/', take everything after the last '/'
            $imageName = $imageName -split '/' | Select-Object -Last 1
        }
        
        [PSCustomObject]@{
            Name = $_.Name
            Image = $imageName
            Status = "[$statusColor]$($_.Status)[/]"
            Created = $_.Created
        }
    }
    
    $tableData | Format-SpectreTable -Title "Docker Containers" -Color "DodgerBlue1" -AllowMarkup
}

function Show-ActionMenu {
    <#
    .SYNOPSIS
        Shows the main action menu and returns the selected action.
    #>
    $actions = @(
        "📋 View Containers",
        "🚀 Start/Stop Containers", 
        "📊 Container Logs",
        "🌐 Browse Docker Hub Images",
        "📈 System Information",
        "🚪 Exit"
    )
    
    Write-SpectreRule -Title "Available Actions" -Color "Cyan1"
    
    $selection = Read-SpectreSelection -Message "What would you like to do?" -Choices $actions -Color "DodgerBlue1"
    
    return $selection
}

function Invoke-ContainerManagement {
    <#
    .SYNOPSIS
        Handles starting and stopping containers.
    #>
    param(
        # Container data
        [array]$Containers,
        # Whether Docker is available
        [bool]$DockerAvailable
    )
    
    if ($Containers.Count -eq 0) {
        "No containers available for management" | Format-SpectrePanel -Header "Container Management" -Color "Yellow"
        Read-SpectrePause
        return
    }
    
    Write-SpectreRule -Title "Container Management" -Color "Green"
    
    # Let user select containers to manage
    $containerNames = $Containers | ForEach-Object { "$($_.Name) [$($_.Status)]" }
    $selected = Read-SpectreMultiSelection -Message "Select containers to manage" -Choices $containerNames -Color "Green"
    
    if ($selected.Count -eq 0) {
        Write-SpectreHost "[yellow]No containers selected[/]"
        Read-SpectrePause
        return
    }
    
    # Ask for action
    $action = Read-SpectreSelection -Message "What action do you want to perform?" -Choices @("Start", "Stop", "Restart") -Color "Orange1"
    
    # Simulate the operation with a status spinner
    $result = Invoke-SpectreCommandWithStatus -Title "Performing $action operation..." -Spinner "Dots12" -Color "Green" -ScriptBlock {
        Start-Sleep -Seconds 2
        
        if ($DockerAvailable) {
            # Real Docker commands would go here
            foreach ($container in $selected) {
                $containerName = $container -replace " \[.*\]$", ""
                Write-SpectreHost "`n[grey]LOG:[/] ${action}ing container: $containerName"
                Start-Sleep -Milliseconds 500
            }
        } else {
            # Mock operation
            foreach ($container in $selected) {
                Write-SpectreHost "`n[grey]LOG:[/] Mock ${action}ing: $container"
                Start-Sleep -Milliseconds 300
            }
        }
        
        return "Operation completed successfully!"
    }
    
    Write-SpectreHost "[green]✓[/] $result"
    Read-SpectrePause
}

function Show-ContainerLogs {
    <#
    .SYNOPSIS
        Demonstrates live log viewing with layouts.
    #>
    param(
        # Container data
        [array]$Containers,
        # Whether Docker is available
        [bool]$DockerAvailable
    )
    
    if ($Containers.Count -eq 0) {
        "No containers available for log viewing" | Format-SpectrePanel -Header "Container Logs" -Color "Yellow"
        Read-SpectrePause
        return
    }
    
    Write-SpectreRule -Title "Container Logs" -Color "Purple"
    
    # Select container for logs
    $containerNames = $Containers | Where-Object { $_.Status -match "running" } | ForEach-Object { $_.Name }
    
    if ($containerNames.Count -eq 0) {
        Write-SpectreHost "[yellow]No running containers found[/]"
        Read-SpectrePause
        return
    }
    
    $selectedContainer = Read-SpectreSelection -Message "Select container to view logs" -Choices $containerNames -Color "Purple"
    
    # Create a layout for log display
    $layout = New-SpectreLayout -Name "root" -Rows @(
        (New-SpectreLayout -Name "header" -MinimumSize 3 -Data "Loading..."),
        (New-SpectreLayout -Name "logs" -Data "Connecting to container logs...")
    )
    
    Write-SpectreHost "`n[yellow]Press ESC to stop viewing logs[/]"
    Start-Sleep -Seconds 1
    
    # Live log simulation
    Invoke-SpectreLive -Data $layout -ScriptBlock {
        param($Context)
        
        # Update header
        $headerPanel = "Container: [bold]$selectedContainer[/] | Status: [green]Live Streaming[/] | Time: [grey]$(Get-Date -Format 'HH:mm:ss')[/]" | 
            Format-SpectrePanel -Expand -Border "Rounded" -Color "Purple"
        $layout["header"].Update($headerPanel) | Out-Null
        
        # Mock log entries
        $logEntries = @()
        $logTypes = @("INFO", "DEBUG", "WARN", "ERROR")
        $logMessages = @(
            "Application started successfully",
            "Database connection established", 
            "Processing user request",
            "Cache miss, fetching from database",
            "Request completed in 45ms",
            "Memory usage: 128MB",
            "Garbage collection triggered",
            "Health check passed"
        )
        
        for ($i = 0; $i -lt 50; $i++) {
            # Check for ESC key
            if ([Console]::KeyAvailable) {
                $key = [Console]::ReadKey($true)
                if ($key.Key -eq "Escape") {
                    break
                }
            }
            
            # Add new log entry
            $logType = Get-Random -InputObject $logTypes
            $logMessage = Get-Random -InputObject $logMessages
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"
            
            $colorMap = @{
                "INFO" = "white"
                "DEBUG" = "grey"
                "WARN" = "yellow" 
                "ERROR" = "red"
            }
            
            $color = $colorMap[$logType]
            $logEntry = "[$color]$timestamp [$logType][/] $logMessage"
            $logEntries += $logEntry
            
            # Keep only last 15 entries
            if ($logEntries.Count -gt 15) {
                $logEntries = $logEntries[-15..-1]
            }
            
            # Update logs panel
            $logsContent = ($logEntries -join "`n") | Format-SpectrePanel -Header "Live Logs" -Expand -Border "Rounded"
            $layout["logs"].Update($logsContent) | Out-Null
            
            $Context.Refresh()
            Start-Sleep -Milliseconds 500
        }
    }
    
    Write-SpectreHost "[green]✓[/] Log viewing ended"
    Read-SpectrePause
}

function Get-DockerHubImages {
    <#
    .SYNOPSIS
        Fetches popular images from Docker Hub API.
    #>
    try {
        Write-SpectreHost "[blue]Fetching popular images from Docker Hub...[/]"
        
        $uri = "https://hub.docker.com/v2/repositories/library/?page=1&page_size=10"
        $response = Invoke-RestMethod -Uri $uri -Method Get -TimeoutSec 10
        
        $images = @()
        foreach ($repo in $response.results) {
            $logoUrl = $null
            try {
                # Try to get logo URL
                $encodedName = [System.Web.HttpUtility]::UrlEncode("library/$($repo.name)")
                $logoUri = "https://hub.docker.com/api/media/repos_logo/v1/$encodedName"
                $logoResponse = Invoke-RestMethod -Uri $logoUri -Method Get -TimeoutSec 5
                $logoUrl = $logoResponse.logo_url
            }
            catch {
                # Logo not available
            }
            
            $images += [PSCustomObject]@{
                Name = $repo.name
                Description = $repo.short_description
                Stars = $repo.star_count
                Pulls = $repo.pull_count
                LogoUrl = $logoUrl
                Official = $true
            }
        }
        
        return $images
    }
    catch {
        Write-SpectreHost "[red]Error fetching Docker Hub data: $($_.Exception.Message)[/]"
        return @()
    }
}

function Show-DockerHubBrowser {
    <#
    .SYNOPSIS
        Shows a browser interface for Docker Hub images.
    #>
    Write-SpectreRule -Title "Docker Hub Image Browser" -Color "Blue"
    
    # Get images with status
    $images = Invoke-SpectreCommandWithStatus -Title "Fetching popular images from Docker Hub..." -Spinner "Dots8" -Color "Blue" -ScriptBlock {
        return Get-DockerHubImages
    }
    
    if ($images.Count -eq 0) {
        "No images could be retrieved from Docker Hub" | Format-SpectrePanel -Header "Docker Hub Browser" -Color "Red"
        Read-SpectrePause
        return
    }
    
    # Create table data with formatting
    $tableData = @()
    foreach ($image in $images) {
        # Format numbers for better readability
        $starsFormatted = if ($image.Stars -gt 1000) { 
            "{0:N1}k" -f ($image.Stars / 1000) 
        } else { 
            $image.Stars.ToString() 
        }
        
        $pullsFormatted = if ($image.Pulls -gt 1000000) {
            "{0:N1}M" -f ($image.Pulls / 1000000)
        } elseif ($image.Pulls -gt 1000) {
            "{0:N1}k" -f ($image.Pulls / 1000)
        } else {
            $image.Pulls.ToString()
        }
        
        # Create clickable link (Spectre markup)
        $nameWithLink = "[link=https://hub.docker.com/_/$($image.Name)]$($image.Name)[/]"
        
        $tableData += [PSCustomObject]@{
            "Image" = $nameWithLink
            "Description" = if ($image.Description.Length -gt 50) { 
                $image.Description.Substring(0, 47) + "..." 
            } else { 
                $image.Description 
            }
            "⭐ Stars" = $starsFormatted
            "📥 Pulls" = $pullsFormatted
            "Official" = if ($image.Official) { "[green]✓[/]" } else { "[red]✗[/]" }
        }
    }
    
    # Display the table
    $tableData | Format-SpectreTable -Title "Popular Docker Hub Images" -Color "Blue" -AllowMarkup
    
    # Let user select an image to "pull"
    Write-SpectreRule -Title "Image Selection" -Color "Green"
    
    $imageNames = $images | ForEach-Object { $_.Name }
    $selectedImage = Read-SpectreSelection -Message "Select an image to demonstrate pulling" -Choices $imageNames -Color "Green"
    
    if ($selectedImage) {
        # Simulate pulling the image
        $result = Invoke-SpectreCommandWithStatus -Title "Pulling $selectedImage from Docker Hub..." -Spinner "Dots12" -Color "Green" -ScriptBlock {
            # Simulate various pull stages
            $stages = @(
                "Pulling fs layer",
                "Downloading",
                "Download complete", 
                "Extracting",
                "Pull complete"
            )
            
            foreach ($stage in $stages) {
                Write-SpectreHost "`n[grey]LOG:[/] $stage"
                Start-Sleep -Milliseconds 800
            }
            
            return "Successfully pulled $selectedImage:latest"
        }
        
        Write-SpectreHost "[green]✓[/] $result"
        
        # Show what would happen next
        $nextSteps = @"
[green]Image pull completed![/]

Next steps you could take:
• Run the container: [cyan]docker run -d $selectedImage[/]
• View the image: [cyan]docker images $selectedImage[/]  
• Inspect the image: [cyan]docker inspect $selectedImage[/]
"@
        
        $nextSteps | Format-SpectrePanel -Header "What's Next?" -Color "Green"
    }
    
    Read-SpectrePause
}

function Show-SystemInformation {
    <#
    .SYNOPSIS
        Displays system information using various Spectre widgets.
    #>
    Write-SpectreRule -Title "System Information" -Color "Magenta1"
    
    # Get system info
    $computerInfo = Get-ComputerInfo
    $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
    $diskInfo = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
    
    # Create panels for different info sections
    $osPanel = @"
[bold]Operating System[/]
Name: $($osInfo.Caption)
Version: $($osInfo.Version)
Architecture: $($osInfo.OSArchitecture)
Install Date: $($osInfo.InstallDate.ToString('yyyy-MM-dd'))
"@ | Format-SpectrePanel -Header "OS Information" -Color "Blue"
    
    $hwPanel = @"
[bold]Hardware[/]
Computer: $($computerInfo.CsName)
Processor: $($computerInfo.CsProcessors[0].Name)
Total RAM: $([math]::Round($computerInfo.CsTotalPhysicalMemory / 1GB, 2)) GB
"@ | Format-SpectrePanel -Header "Hardware" -Color "Green"
    
    # Disk usage chart
    $diskData = @()
    foreach ($disk in $diskInfo) {
        $usedGB = [math]::Round(($disk.Size - $disk.FreeSpace) / 1GB, 1)
        $totalGB = [math]::Round($disk.Size / 1GB, 1)
        $usedPercent = [math]::Round((($disk.Size - $disk.FreeSpace) / $disk.Size) * 100, 1)
        
        $color = if ($usedPercent -gt 90) { "Red" } 
                 elseif ($usedPercent -gt 70) { "Orange1" }
                 else { "Green" }
        
        $diskData += New-SpectreChartItem -Label "Drive $($disk.DeviceID)" -Value $usedPercent -Color $color
    }
    
    # Display everything in columns
    $leftColumn = @($osPanel, $hwPanel) | Format-SpectreRows
    $rightColumn = $diskData | Format-SpectreBarChart -Label "Disk Usage (%)" -Width 40
    
    @($leftColumn, $rightColumn) | Format-SpectreColumns -Expand
    
    Read-SpectrePause
}

function Show-DemoSummary {
    <#
    .SYNOPSIS
        Shows a summary of all the Spectre features demonstrated.
    #>
    Write-SpectreRule -Title "Demo Summary" -Color "Gold1"
    
    $featuresData = @(
        [PSCustomObject]@{ Feature = "Write-SpectreFigletText"; Usage = "Large ASCII art headers"; Demo = "✓" },
        [PSCustomObject]@{ Feature = "Write-SpectreRule"; Usage = "Section dividers and titles"; Demo = "✓" },
        [PSCustomObject]@{ Feature = "Format-SpectrePanel"; Usage = "Bordered content containers"; Demo = "✓" },
        [PSCustomObject]@{ Feature = "Format-SpectreTable"; Usage = "Structured data display"; Demo = "✓" },
        [PSCustomObject]@{ Feature = "Read-SpectreSelection"; Usage = "Single choice selection"; Demo = "✓" },
        [PSCustomObject]@{ Feature = "Read-SpectreMultiSelection"; Usage = "Multiple choice selection"; Demo = "✓" },
        [PSCustomObject]@{ Feature = "Invoke-SpectreCommandWithStatus"; Usage = "Progress spinners"; Demo = "✓" },
        [PSCustomObject]@{ Feature = "New-SpectreLayout"; Usage = "Complex UI layouts"; Demo = "✓" },
        [PSCustomObject]@{ Feature = "Invoke-SpectreLive"; Usage = "Real-time updates"; Demo = "✓" },
        [PSCustomObject]@{ Feature = "Format-SpectreBarChart"; Usage = "Data visualization"; Demo = "✓" },
        [PSCustomObject]@{ Feature = "Format-SpectreColumns"; Usage = "Side-by-side layout"; Demo = "✓" },
        [PSCustomObject]@{ Feature = "Write-SpectreHost"; Usage = "Markup rendering"; Demo = "✓" }
    )
    
    $featuresData | Format-SpectreTable -Title "PwshSpectreConsole Features Demonstrated" -Color "Gold1"
    
    $closingMessage = @"
[bold gold1]Congratulations![/] You've seen the power of PwshSpectreConsole in action.

[yellow]What we've covered:[/]
• Rich text formatting with markup
• Interactive selection prompts  
• Real-time status indicators
• Complex layouts and live updates
• Data visualization with charts
• Web API integration
• Professional console interfaces

[yellow]What we haven't shown:[/]
• Trees and hierarchical data
• Progress bars with custom steps
• Grid layouts for complex UIs
• Exception formatting
• Image display capabilities
• Custom color schemes
• And much more!

[cyan]Ready to build amazing terminal UIs?[/]
Install PwshSpectreConsole and start creating today!

[grey]Install-Module PwshSpectreConsole[/]
"@
    
    $closingMessage | Format-SpectrePanel -Header "Thank You!" -Border "Double" -Color "Gold1" -Expand
    
    Read-SpectrePause -Message "Press [bold gold1]Enter[/] to exit the demo..."
}

# Main demo execution
function Start-Demo {
    <#
    .SYNOPSIS
        Main demo orchestration function.
    #>
    param(
        # Whether to use mock data only
        [bool]$UseMockData
    )
    
    try {
        # Show header
        Show-DemoHeader
        
        # Check Docker availability
        $dockerAvailable = if ($UseMockData) { $false } else { Test-DockerAvailability }
        Read-SpectrePause
        
        # Main demo loop
        do {
            Clear-Host
            Write-SpectreFigletText -Text "Docker UI" -Alignment Center -Color "DodgerBlue1"
            
            # Get container data
            $containers = if ($dockerAvailable) { 
                Get-RealContainers 
            } else { 
                Get-MockContainers 
            }
            
            # Show action menu
            $action = Show-ActionMenu
            
            Clear-Host
            switch -Wildcard ($action) {
                "*View Containers*" {
                    Write-SpectreRule -Title "Container Overview" -Color "DodgerBlue1"
                    Show-ContainerTable -Containers $containers
                    Read-SpectrePause
                }
                "*Start/Stop*" {
                    Invoke-ContainerManagement -Containers $containers -DockerAvailable $dockerAvailable
                }
                "*Logs*" {
                    Show-ContainerLogs -Containers $containers -DockerAvailable $dockerAvailable
                }
                "*Docker Hub*" {
                    Show-DockerHubBrowser
                }
                "*System Information*" {
                    Show-SystemInformation
                }
                "*Exit*" {
                    break
                }
            }
        } while ($action -notmatch "\*Exit\*")
        
        # Show demo summary
        Clear-Host
        Show-DemoSummary
        
        Write-SpectreHost "`n[green]Demo completed successfully! Thank you for watching.[/]"
    }
    catch {
        Write-SpectreHost "`n[red]Demo error: $($_.Exception.Message)[/]"
        $_ | Format-SpectreException
    }
}

# Start the demo
Start-Demo -UseMockData $UseMockData
