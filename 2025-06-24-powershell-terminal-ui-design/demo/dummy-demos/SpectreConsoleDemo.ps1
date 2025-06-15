#!/usr/bin/env pwsh
<#
.SYNOPSIS
    PwshSpectreConsole Demo - A comprehensive showcase of Spectre Console widgets in PowerShell
.DESCRIPTION
    This demo showcases how to create beautiful, interactive console applications using the PwshSpectreConsole module.
    It demonstrates various widgets including headers, tables, selections, spinners, layouts, and real-time data display.
.EXAMPLE
    .\SpectreConsoleDemo.ps1
    Runs the interactive demo showcasing various PwshSpectreConsole features
#>

[CmdletBinding()]
param (
    # Skip Docker-related demos if Docker is not available
    [switch]$SkipDocker
)

#Requires -Modules PwshSpectreConsole

# Set theme colors for the demo
Set-SpectreColors -AccentColor "DeepSkyBlue3" -DefaultValueColor "Grey78"

function Show-DemoHeader {
    <#
    .SYNOPSIS
        Displays the demo header with figlet text and welcome message
    #>
    Clear-Host
    
    # Main title with figlet text
    Write-SpectreFigletText -Text "PowerShell" -Alignment Center -Color "DeepSkyBlue3"
    Write-SpectreFigletText -Text "Spectre Demo" -Alignment Center -Color "Cyan1"
    
    # Welcome message in a panel
    $welcomeMessage = @"
Welcome to the PwshSpectreConsole Demo!

This demonstration will showcase how easy it is to create beautiful, 
interactive console applications using the PwshSpectreConsole module.

We'll explore various widgets and features including:
• Headers and text formatting
• Tables and data display
• Interactive selections
• Progress indicators and spinners  
• Layouts and live updates
• Web API integration with visual elements
"@
    
    $welcomeMessage | Format-SpectrePanel -Header "Demo Overview" -Border "Rounded" -Color "Cyan1" -Expand
    
    Write-SpectreRule -Title "Let's Begin!" -Color "DeepSkyBlue3"
    Read-SpectrePause -Message "Press [cyan1]Enter[/] to start the demo..."
}

function Show-BasicWidgets {
    <#
    .SYNOPSIS
        Demonstrates basic Spectre Console widgets like rules, panels, and text formatting
    #>
    Clear-Host
    Write-SpectreRule -Title "Basic Widgets Demo" -Color "DeepSkyBlue3"
    
    # Demonstrate horizontal rules
    Write-SpectreHost "`n[bold]1. Horizontal Rules[/]"
    Write-SpectreRule -Title "Simple Rule" -Alignment "Left"
    Write-SpectreRule -Title "Centered Rule" -Alignment "Center" -Color "Yellow"
    Write-SpectreRule -Title "Right Aligned Rule" -Alignment "Right" -Color "Green"
    
    # Demonstrate panels
    Write-SpectreHost "`n[bold]2. Panels[/]"
    
    @(
        "This is a simple panel with rounded borders",
        "This is a panel with a header" | Format-SpectrePanel -Header "Information" -Color "Yellow",
        "This is an expanded panel that takes full width" | Format-SpectrePanel -Header "Full Width" -Color "Green" -Expand
    ) | Format-SpectreRows
    
    Read-SpectrePause
}

function Show-TableDemo {
    <#
    .SYNOPSIS
        Demonstrates table creation and formatting with sample data
    #>
    Clear-Host
    Write-SpectreRule -Title "Table Demo" -Color "DeepSkyBlue3"
    
    # Create sample container data
    $containerData = @(
        [PSCustomObject]@{
            Name = "nginx"
            Status = "Running"
            Port = "80:80"
            Image = "nginx:latest"
            Created = (Get-Date).AddDays(-2)
        },
        [PSCustomObject]@{
            Name = "redis"
            Status = "Stopped"
            Port = "6379:6379"
            Image = "redis:alpine"
            Created = (Get-Date).AddDays(-1)
        },
        [PSCustomObject]@{
            Name = "postgres"
            Status = "Running"
            Port = "5432:5432"
            Image = "postgres:13"
            Created = (Get-Date).AddHours(-3)
        }
    )
    
    Write-SpectreHost "`n[bold]Container Status Overview[/]"
    $containerData | Format-SpectreTable -Title "Docker Containers" -Color "Cyan1"
    
    # Demonstrate custom properties
    Write-SpectreHost "`n[bold]Custom Table Properties[/]"
    $customProperties = @(
        @{Name='Container'; Expression={$_.Name}; },
        @{Name='Health'; Expression={
            if ($_.Status -eq "Running") { "[green]● $($_.Status)[/]" } 
            else { "[red]● $($_.Status)[/]" }
        }},
        @{Name='Ports'; Expression={$_.Port}},
        @{Name='Age'; Expression={
            $timeSpan = (Get-Date) - $_.Created
            if ($timeSpan.Days -gt 0) { "$($timeSpan.Days)d ago" }
            elseif ($timeSpan.Hours -gt 0) { "$($timeSpan.Hours)h ago" }
            else { "$($timeSpan.Minutes)m ago" }
        }}
    )
    
    $containerData | Format-SpectreTable -Property $customProperties -AllowMarkup -Title "Enhanced Container View" -Color "Yellow"
    
    Read-SpectrePause
}

function Show-SelectionDemo {
    <#
    .SYNOPSIS
        Demonstrates single and multi-selection prompts
    #>
    Clear-Host
    Write-SpectreRule -Title "Selection Demo" -Color "DeepSkyBlue3"
    
    # Single selection demo
    Write-SpectreHost "`n[bold]1. Single Selection[/]"
    $actions = @("Start Container", "Stop Container", "View Logs", "Remove Container", "Pull New Image")
    $selectedAction = Read-SpectreSelection -Message "Select an action to perform" -Choices $actions -Color "Cyan1"
    
    Write-SpectreHost "`nYou selected: [cyan1]$selectedAction[/]"
    
    # Multi-selection demo
    Write-SpectreHost "`n[bold]2. Multi-Selection[/]"
    $containers = @("nginx", "redis", "postgres", "mongodb", "elasticsearch")
    $selectedContainers = Read-SpectreMultiSelection -Message "Select containers to operate on" -Choices $containers -Color "Yellow"
    
    if ($selectedContainers.Count -gt 0) {
        Write-SpectreHost "`nYou selected: [yellow]$($selectedContainers -join ', ')[/]"
    } else {
        Write-SpectreHost "`n[grey]No containers selected[/]"
    }
    
    Read-SpectrePause
}

function Show-SpinnerDemo {
    <#
    .SYNOPSIS
        Demonstrates progress indicators and status spinners
    #>
    Clear-Host
    Write-SpectreRule -Title "Progress & Spinner Demo" -Color "DeepSkyBlue3"
    
    # Status spinner demo
    Write-SpectreHost "`n[bold]Status Spinner Demo[/]"
    
    $result = Invoke-SpectreCommandWithStatus -Spinner "Dots2" -Title "Starting containers..." -Color "Green" -ScriptBlock {
        Start-Sleep -Seconds 2
        Write-SpectreHost "`n[grey]LOG:[/] Starting nginx container..."
        Start-Sleep -Seconds 1
        Write-SpectreHost "`n[grey]LOG:[/] Container started successfully"
        Start-Sleep -Seconds 1
        return "nginx container is now running"
    }
    
    Write-SpectreHost "`nResult: [green]$result[/]"
    
    # Progress bar demo
    Write-SpectreHost "`n[bold]Progress Bar Demo[/]"
    
    Invoke-SpectreCommandWithProgress -ScriptBlock {
        param ([Spectre.Console.ProgressContext] $Context)
        
        $task1 = $Context.AddTask("Pulling image layers")
        $task2 = $Context.AddTask("Extracting files")
        
        # Simulate image pulling
        for ($i = 0; $i -le 100; $i += 10) {
            $task1.Increment(10)
            Start-Sleep -Milliseconds 200
        }
        
        # Simulate extraction
        for ($i = 0; $i -le 100; $i += 20) {
            $task2.Increment(20)
            Start-Sleep -Milliseconds 150
        }
    }
    
    Read-SpectrePause
}

function Show-LayoutDemo {
    <#
    .SYNOPSIS
        Demonstrates layout creation and live updates
    #>
    Clear-Host
    Write-SpectreRule -Title "Layout & Live Demo" -Color "DeepSkyBlue3"
    
    # Create a layout for log viewing
    $layout = New-SpectreLayout -Name "root" -Rows @(
        (New-SpectreLayout -Name "header" -MinimumSize 3 -Ratio 1 -Data "Loading..."),
        (New-SpectreLayout -Name "content" -Ratio 10 -Columns @(
            (New-SpectreLayout -Name "logs" -Ratio 3 -Data "Loading logs..."),
            (New-SpectreLayout -Name "stats" -Ratio 1 -Data "Loading stats...")
        ))
    )
    
    Write-SpectreHost "`n[bold]Live Layout Demo - Container Log Viewer[/]"
    Write-SpectreHost "[grey]This will simulate a live log viewer for 10 seconds...[/]"
    
    Invoke-SpectreLive -Data $layout -ScriptBlock {
        param ([Spectre.Console.LiveDisplayContext] $Context)
        
        $logMessages = @()
        $startTime = Get-Date
        
        for ($i = 0; $i -lt 20; $i++) {
            $currentTime = Get-Date
            $elapsed = ($currentTime - $startTime).TotalSeconds
            
            # Update header
            $headerContent = "Container Log Viewer - Runtime: $([math]::Round($elapsed, 1))s" | 
                Format-SpectreAligned -HorizontalAlignment Center | 
                Format-SpectrePanel -Color "Cyan1" -Expand
            $layout["header"].Update($headerContent) | Out-Null
            
            # Add new log message
            $timestamp = Get-Date -Format "HH:mm:ss.fff"
            $logMessages += "[$timestamp] Container nginx: Request processed successfully"
            
            # Keep only last 15 messages
            if ($logMessages.Count -gt 15) {
                $logMessages = $logMessages[-15..-1]
            }
            
            # Update logs panel
            $logsContent = ($logMessages | ForEach-Object { "[grey]$_[/]" }) -join "`n" |
                Format-SpectrePanel -Header "Live Logs" -Color "Green" -Expand
            $layout["logs"].Update($logsContent) | Out-Null
            
            # Update stats panel
            $statsContent = @"
Messages: $($logMessages.Count)
Uptime: $([math]::Round($elapsed, 1))s
Status: [green]Running[/]
Memory: 128MB
CPU: 15%
"@ | Format-SpectrePanel -Header "Statistics" -Color "Yellow" -Expand
            $layout["stats"].Update($statsContent) | Out-Null
            
            $Context.Refresh()
            Start-Sleep -Milliseconds 500
        }
    }
    
    Read-SpectrePause
}

function Show-DockerHubDemo {
    <#
    .SYNOPSIS
        Demonstrates web API integration by browsing Docker Hub popular images
    #>
    Clear-Host
    Write-SpectreRule -Title "Docker Hub API Demo" -Color "DeepSkyBlue3"
    
    Write-SpectreHost "`n[bold]Fetching Popular Container Images from Docker Hub...[/]"
    
    $images = Invoke-SpectreCommandWithStatus -Spinner "Dots" -Title "Loading popular images..." -Color "Cyan1" -ScriptBlock {
        try {
            # Fetch popular images from Docker Hub API
            $response = Invoke-RestMethod -Uri "https://hub.docker.com/v2/repositories/library/?page=1&page_size=8" -ErrorAction Stop
            return $response.results
        } catch {
            Write-SpectreHost "`n[red]Error fetching data from Docker Hub API: $($_.Exception.Message)[/]"
            return @()
        }
    }
    
    if ($images.Count -eq 0) {
        # Fallback to sample data if API is unavailable
        $images = @(
            @{name="nginx"; star_count=15234; pull_count=1000000000; description="Official build of Nginx."},
            @{name="node"; star_count=12456; pull_count=500000000; description="Node.js is a JavaScript runtime."},
            @{name="python"; star_count=18901; pull_count=2000000000; description="Python is an interpreted language."},
            @{name="redis"; star_count=9876; pull_count=1000000000; description="Redis is an open source key-value store."},
            @{name="postgres"; star_count=8765; pull_count=1000000000; description="PostgreSQL object-relational database."}
        )
        Write-SpectreHost "`n[yellow]Using sample data (API unavailable)[/]"
    }
    
    # Format the data for display
    $tableData = $images | ForEach-Object {
        [PSCustomObject]@{
            Name = $_.name
            Description = if ($_.description.Length -gt 50) { $_.description.Substring(0, 47) + "..." } else { $_.description }
            Stars = "{0:N0}" -f $_.star_count
            Downloads = "{0:N0}" -f $_.pull_count
        }
    }
    
    Write-SpectreHost "`n[bold]Popular Docker Hub Images[/]"
    $tableData | Format-SpectreTable -Title "Docker Hub - Most Popular Images" -Color "Cyan1"
    
    # Interactive selection
    $imageNames = $images | ForEach-Object { $_.name }
    $selectedImage = Read-SpectreSelection -Message "Select an image to view details" -Choices $imageNames -Color "Yellow"
    
    $selectedImageData = $images | Where-Object { $_.name -eq $selectedImage }
    
    # Show selected image details
    $imageDetails = @"
Image: $($selectedImageData.name)
Description: $($selectedImageData.description)
Stars: $("{0:N0}" -f $selectedImageData.star_count)
Downloads: $("{0:N0}" -f $selectedImageData.pull_count)

Docker command to pull:
[cyan1]docker pull $($selectedImageData.name)[/]
"@
    
    $imageDetails | Format-SpectrePanel -Header "Image Details" -Color "Green" -Expand
    
    Read-SpectrePause
}

function Show-ChartDemo {
    <#
    .SYNOPSIS
        Demonstrates chart widgets including bar charts and breakdown charts
    #>
    Clear-Host
    Write-SpectreRule -Title "Charts Demo" -Color "DeepSkyBlue3"
    
    Write-SpectreHost "`n[bold]1. Bar Chart - Container Resource Usage[/]"
    
    # Create sample data for bar chart
    $resourceData = @()
    $resourceData += New-SpectreChartItem -Label "nginx" -Value 45.2 -Color "Green"
    $resourceData += New-SpectreChartItem -Label "redis" -Value 78.9 -Color "Orange1"
    $resourceData += New-SpectreChartItem -Label "postgres" -Value 23.1 -Color "Blue"
    $resourceData += New-SpectreChartItem -Label "mongodb" -Value 56.7 -Color "Purple"
    
    $resourceData | Format-SpectreBarChart -Label "CPU Usage (%)" -Width 60
    
    Write-SpectreHost "`n[bold]2. Breakdown Chart - Storage Distribution[/]"
    
    # Create sample data for breakdown chart
    $storageData = @()
    $storageData += New-SpectreChartItem -Label "Images" -Value 2.5 -Color "Cyan1"
    $storageData += New-SpectreChartItem -Label "Containers" -Value 1.2 -Color "Yellow"
    $storageData += New-SpectreChartItem -Label "Volumes" -Value 0.8 -Color "Green"
    $storageData += New-SpectreChartItem -Label "Cache" -Value 0.3 -Color "Red"
    
    $storageData | Format-SpectreBreakdownChart -Width 60
    
    Read-SpectrePause
}

function Show-TreeDemo {
    <#
    .SYNOPSIS
        Demonstrates tree widget for hierarchical data display
    #>
    Clear-Host
    Write-SpectreRule -Title "Tree Demo" -Color "DeepSkyBlue3"
    
    Write-SpectreHost "`n[bold]Container Dependency Tree[/]"
    
    # Create a tree structure for container dependencies
    $treeData = @{
        Value = "Docker Environment"
        Children = @(
            @{
                Value = "Web Tier"
                Children = @(
                    @{
                        Value = "nginx:latest (Running)"
                        Children = @()
                    },
                    @{
                        Value = "apache:2.4 (Stopped)"
                        Children = @()
                    }
                )
            },
            @{
                Value = "Database Tier"
                Children = @(
                    @{
                        Value = "postgres:13 (Running)"
                        Children = @(
                            @{
                                Value = "Volume: postgres-data"
                                Children = @()
                            }
                        )
                    },
                    @{
                        Value = "redis:alpine (Running)"
                        Children = @()
                    }
                )
            },
            @{
                Value = "Monitoring"
                Children = @(
                    @{
                        Value = "grafana:latest (Running)"
                        Children = @()
                    }
                )
            }
        )
    }
    
    $treeData | Format-SpectreTree -Guide "BoldLine" -Color "Cyan1"
    
    Read-SpectrePause
}

function Show-FinalDemo {
    <#
    .SYNOPSIS
        Shows the final demo summary and additional features
    #>
    Clear-Host
    Write-SpectreRule -Title "Demo Complete!" -Color "DeepSkyBlue3"
    
    $summaryText = @"
🎉 Congratulations! You've seen the key features of PwshSpectreConsole:

✅ Beautiful text formatting with Figlet and colors
✅ Organized content with panels and rules  
✅ Data presentation with customizable tables
✅ User interaction with selection prompts
✅ Progress indication with spinners and bars
✅ Complex layouts with live updates
✅ Web API integration with visual display
✅ Charts for data visualization
✅ Hierarchical data with trees

What we haven't covered (there's so much more!):
• Grids for complex layouts
• JSON syntax highlighting
• Image display (including Sixel support)
• Calendar widgets
• Exception formatting
• Custom color schemes
• Text alignment and padding
• File path highlighting

Ready to build amazing terminal applications? 
Check out the documentation and examples at:
https://pwshspectreconsole.com
"@
    
    $summaryText | Format-SpectrePanel -Header "Demo Summary" -Border "Double" -Color "Green" -Expand
    
    # Show some additional quick examples
    Write-SpectreHost "`n[bold]Quick Examples of Other Features:[/]"
    
    # JSON formatting
    $sampleJson = @{
        name = "demo-container"
        status = "running"
        ports = @("80:80", "443:443")
        environment = @{
            NODE_ENV = "production"
            DEBUG = $false
        }
    } | ConvertTo-Json
    
    Write-SpectreHost "`n[bold]JSON Formatting:[/]"
    $sampleJson | Format-SpectreJson | Format-SpectrePanel -Header "Container Config" -Color "Purple"
    
    # File path formatting
    Write-SpectreHost "`n[bold]File Path Highlighting:[/]"
    $env:PWD | Format-SpectreTextPath
    
    Write-SpectreRule -Title "Thank You!" -Color "DeepSkyBlue3" -Alignment "Center"
    
    Write-SpectreHost "`n[bold green]Happy coding with PwshSpectreConsole! 🚀[/]"
}

function Start-Demo {
    <#
    .SYNOPSIS
        Main demo orchestration function that runs through all demo sections
    #>
    
    # Check if PwshSpectreConsole is available
    try {
        Import-Module PwshSpectreConsole -ErrorAction Stop
    } catch {
        Write-Host "❌ PwshSpectreConsole module is required but not found." -ForegroundColor Red
        Write-Host "Install it with: Install-Module PwshSpectreConsole" -ForegroundColor Yellow
        return
    }
    
    # Demo sections
    $demoSections = @(
        @{ Name = "Demo Header"; Function = "Show-DemoHeader" },
        @{ Name = "Basic Widgets"; Function = "Show-BasicWidgets" },
        @{ Name = "Table Demo"; Function = "Show-TableDemo" },
        @{ Name = "Selection Demo"; Function = "Show-SelectionDemo" },
        @{ Name = "Spinner Demo"; Function = "Show-SpinnerDemo" },
        @{ Name = "Layout Demo"; Function = "Show-LayoutDemo" },
        @{ Name = "Docker Hub API Demo"; Function = "Show-DockerHubDemo" },
        @{ Name = "Charts Demo"; Function = "Show-ChartDemo" },
        @{ Name = "Tree Demo"; Function = "Show-TreeDemo" },
        @{ Name = "Final Summary"; Function = "Show-FinalDemo" }
    )
    
    try {
        # Run each demo section
        foreach ($section in $demoSections) {
            Write-Progress -Activity "Running PwshSpectreConsole Demo" -Status $section.Name -PercentComplete (($demoSections.IndexOf($section) / $demoSections.Count) * 100)
            & $section.Function
        }
        
        Write-Progress -Activity "Running PwshSpectreConsole Demo" -Completed
        
    } catch {
        Write-Host "❌ Demo error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Stack trace: $($_.ScriptStackTrace)" -ForegroundColor Yellow
    }
}

# Run the demo if script is executed directly
if ($MyInvocation.InvocationName -ne '.') {
    Start-Demo
}
