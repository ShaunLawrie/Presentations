#Requires -Module PwshSpectreConsole

<#
.SYNOPSIS
    Docker Management Wizard - A PwshSpectreConsole demo showcasing beautiful terminal UIs.

.DESCRIPTION
    This demo showcases the PwshSpectreConsole module by creating an interactive Docker management wizard.
    Features include:
    - Beautiful header text with figlet
    - Interactive selections and multi-selections
    - Tables with container and image information
    - Status spinners for operations
    - Live layouts for log tailing
    - Web API integration for Docker Hub
    - Image display capabilities

.NOTES
    Requires PwshSpectreConsole module and Docker to be installed.
    Author: PSConfEU Demo
    Date: 2025
#>

using namespace System.Collections.Generic

# Import required modules
Import-Module PwshSpectreConsole -Force

# Set theme colors
Set-SpectreColors -AccentColor "DodgerBlue1" -DefaultValueColor "Grey70"

function Show-DemoHeader {
    <#
    .SYNOPSIS
        Displays the demo header with figlet text and welcome message.
    #>
    
    Clear-Host
    
    # Demo header with figlet text
    Write-SpectreFigletText -Text "Docker Wizard" -Alignment Center -Color "DodgerBlue1"
    
    # Welcome panel
    $welcomeText = @"
Welcome to the Docker Management Wizard!

This demo showcases the power of PwshSpectreConsole for creating
beautiful, interactive terminal applications in PowerShell.

Features demonstrated:
• Interactive selections and multi-selections
• Beautiful tables and layouts  
• Status spinners and progress indicators
• Live updating displays
• Web API integration
• Image rendering in terminal
"@

    $welcomeText | Format-SpectrePanel -Header "Welcome" -Color "Green" -Expand
    Read-SpectrePause -Message "Press any key to continue..."
    Clear-Host

    Write-SpectreRule -Title "Actions" -Color "DodgerBlue1"
}

function Test-DockerAvailable {
    <#
    .SYNOPSIS
        Tests if Docker is available and running.
    
    .OUTPUTS
        [bool] True if Docker is available, false otherwise.
    #>
    
    try {
        $null = docker version 2>$null
        return $true
    }
    catch {
        return $false
    }
}

function Get-DockerContainers {
    <#
    .SYNOPSIS
        Gets the list of Docker containers.
    
    .OUTPUTS
        [PSCustomObject[]] Array of container objects.
    #>
    
    if (-not (Test-DockerAvailable)) {
        Write-SpectreHost "[red]Docker is not available. Please ensure Docker is installed and running.[/]"
        return @()
    }

    try {
        $containers = docker ps -a --format json | ConvertFrom-Json

        if ($containers) {
            return $containers | ForEach-Object {
                [PSCustomObject]@{
                    ID = $_.ID.Substring(0, [Math]::Min(12, $_.ID.Length))
                    Image = $_.Image -replace '.+?/', ''
                    Name = $_.Names
                    Status = $_.Status
                }
            }
        }
        return @()
    }
    catch {
        Write-SpectreHost "[red]Error getting containers: $($_.Exception.Message)[/]"
        return @()
    }
}

function Show-ContainersTable {
    <#
    .SYNOPSIS
        Displays Docker containers in a formatted table.
    
    .PARAMETER Containers
        Array of container objects to display.
    #>
    param(
        # Array of container objects to display
        [PSCustomObject[]]$Containers
    )

    if ($Containers.Count -eq 0) {
        "[yellow]No containers found.[/]" | Format-SpectrePanel -Header "Docker Containers" -Color "Yellow"
        return
    }

    $Containers | Format-SpectreTable -Title "Docker Containers" -Color "DodgerBlue1"
}

function Get-DockerHubPopularImages {
    <#
    .SYNOPSIS
        Gets popular images from Docker Hub API.
    
    .OUTPUTS
        [PSCustomObject[]] Array of popular image objects.
    #>
    
    Write-SpectreHost "[grey]Fetching popular images from Docker Hub...[/]"
    
    try {
        $response = Invoke-RestMethod -Uri "https://hub.docker.com/v2/repositories/library/?page=1&page_size=20" -Method Get
        
        return $response.results | ForEach-Object {
            [PSCustomObject]@{
                Name = $_.name
                Description = $_.description -replace '\r?\n', ' ' | ForEach-Object {
                  $ellipsis = if ($_.Length -gt 80) { "..." } else { "" }
                  return $_.Substring(0, [Math]::Min(80, $_.Length)) + $ellipsis
                }
                StarCount = $_.star_count
                PullCount = $_.pull_count
            }
        }
    }
    catch {
        Write-SpectreHost "[red]Error fetching Docker Hub data: $($_.Exception.Message)[/]"
        return @()
    }
}

function Get-DockerImageLogo {
    <#
    .SYNOPSIS
        Gets the logo for a Docker image from Docker Hub.
    
    .PARAMETER ImageName
        Name of the Docker image.
    
    .OUTPUTS
        [string] URL to the image logo or null if not found.
    #>
    param(
        # Name of the Docker image
        [string]$ImageName
    )

    try {
        if ($ImageName -notlike "*/*") {
            # If no namespace is provided, assume 'library' as default
            $ImageName = "library/$ImageName"
        }
        $encodedName = [System.Web.HttpUtility]::UrlEncode("$ImageName")
        $logoUrl = "https://hub.docker.com/api/media/repos_logo/v1/$encodedName"
        
        # Test if the logo URL is accessible
        $response = Invoke-WebRequest -Uri $logoUrl -ErrorAction SilentlyContinue -ProgressAction SilentlyContinue
        if ($response.StatusCode -eq 200) {
            return $logoUrl
        }
    }
    catch {
        # Logo not available, return null
    }
    
    return $null
}

function Show-DockerImagesWithLogos {
    <#
    .SYNOPSIS
        Displays Docker Hub images with logos in a formatted layout.
    
    .PARAMETER Images
        Array of image objects to display.
    #>
    param(
        # Array of image objects to display
        [PSCustomObject[]]$Images
    )

    if ($Images.Count -eq 0) {
        "[yellow]No images found.[/]" | Format-SpectrePanel -Header "Docker Hub Popular Images" -Color "Yellow"
        return
    }

    $rows = Invoke-SpectreCommandWithProgress -ScriptBlock {
        param($Context)

        $task1 = $Context.AddTask("Loading container details")
        $increment = [math]::Floor(100 / $Images.Count)
        $output = @()

        foreach ($image in $Images) {
          $task1.Increment($increment)
          # Get logo for the image
          $logoUrl = Get-DockerImageLogo -ImageName $image.Name
          
          $row = [ordered]@{
            "Logo" = $null
            "Details" = $null
          }
          
          # Logo column (if available)
          if ($logoUrl) {
              try {
                  $logo = Get-SpectreImage -ImagePath $logoUrl -MaxWidth 10
                  $row["Logo"] = $logo
              }
              catch {
                continue
              }
          }
          else {
            continue
          }

          # Image details column
          $imageDetails = @"
[bold blue]$($image.Name)[/]
$($image.Description)

[yellow]⭐ Stars:[/] $($image.StarCount)
[green]📥 Pulls:[/] $($image.PullCount -replace '(\d)(?=(\d{3})+$)', '$1,')


"@

          $row["Details"] = $imageDetails | Write-SpectreHost -PassThru
          $output += $row
      }
      return $output
    }

    $rows | Format-SpectreTable -Border HeavyHead | Out-SpectreHost
}

function Start-ContainerManagement {
    <#
    .SYNOPSIS
        Starts the interactive container management interface.
    #>
    
    $containers = Get-DockerContainers
    
    if ($containers.Count -eq 0) {
        "[yellow]No containers found. Please create some containers first.[/]" | Format-SpectrePanel -Header "Container Management" -Color "Yellow"
        Read-SpectrePause
        return
    }

    Show-ContainersTable -Containers $containers

    $actions = @(
        "Start containers",
        "Stop containers", 
        "View container logs",
        "Remove containers",
        "Back to main menu"
    )

    $selectedAction = Read-SpectreSelection -Message "Select an action" -Choices $actions -Color "DodgerBlue1"

    switch ($selectedAction) {
        "Start containers" { Start-ContainerOperation -Containers $containers -Operation "start" }
        "Stop containers" { Start-ContainerOperation -Containers $containers -Operation "stop" }
        "View container logs" { Show-ContainerLogs -Containers $containers }
        "Remove containers" { Start-ContainerOperation -Containers $containers -Operation "rm" }
        "Back to main menu" { return }
    }
}

function Start-ContainerOperation {
    <#
    .SYNOPSIS
        Performs operations on selected containers.
    
    .PARAMETER Containers
        Array of available containers.
    
    .PARAMETER Operation
        The Docker operation to perform (start, stop, rm).
    #>
    param(
        # Array of available containers
        [PSCustomObject[]]$Containers,
        
        # The Docker operation to perform
        [ValidateSet("start", "stop", "rm")]
        [string]$Operation
    )

    $containerChoices = $Containers | ForEach-Object { "$($_.Name) ($($_.ID)) - $($_.Status)" }
    
    $selectedContainers = Read-SpectreMultiSelection -Message "Select containers to $Operation" -Choices $containerChoices -Color "DodgerBlue1"

    if ($selectedContainers.Count -eq 0) {
        Write-SpectreHost "[yellow]No containers selected.[/]"
        Read-SpectrePause
        return
    }

    $operationText = switch ($Operation) {
        "start" { "Starting" }
        "stop" { "Stopping" }
        "rm" { "Removing" }
    }

    Invoke-SpectreCommandWithStatus -Title "$operationText containers..." -Spinner "Dots" -Color "DodgerBlue1" -ScriptBlock {
        foreach ($selection in $selectedContainers) {
            $containerName = ($selection -split ' \(')[0]
            $container = $Containers | Where-Object { $_.Name -eq $containerName }
            
            if ($container) {
                try {
                    Write-SpectreHost "[grey]$operationText container: $($container.Name)[/]"
                    $result = docker $Operation $container.ID 2>&1
                    Start-Sleep -Milliseconds 500
                }
                catch {
                    Write-SpectreHost "[red]Error ${Operation}ing $($container.Name): $($_.Exception.Message)[/]"
                }
            }
        }
    }

    Write-SpectreHost "[green]Operation completed![/]"
    Read-SpectrePause
}

function Show-ContainerLogs {
    <#
    .SYNOPSIS
        Shows live container logs using Spectre layouts.
    
    .PARAMETER Containers
        Array of available containers.
    #>
    param(
        # Array of available containers
        [PSCustomObject[]]$Containers
    )

    $runningContainers = $Containers | Where-Object { $_.Status -like "*Up*" }
    
    if ($runningContainers.Count -eq 0) {
        "[yellow]No running containers found.[/]" | Format-SpectrePanel -Header "Container Logs" -Color "Yellow"
        Read-SpectrePause
        return
    }

    $containerChoices = $runningContainers | ForEach-Object { "$($_.Name) ($($_.ID))" }
    $selectedContainer = Read-SpectreSelection -Message "Select container to view logs" -Choices $containerChoices -Color "DodgerBlue1"
    
    $containerName = ($selectedContainer -split ' \(')[0]
    $container = $runningContainers | Where-Object { $_.Name -eq $containerName }

    if (-not $container) {
        Write-SpectreHost "[red]Container not found.[/]"
        Read-SpectrePause
        return
    }

    # Create layout for logs
    $layout = New-SpectreLayout -Name "root" -Rows @(
        (New-SpectreLayout -Name "header" -Data "Loading..." -Ratio 1),
        (New-SpectreLayout -Name "logs" -Data "Fetching logs..." -Ratio 10)
    )

    # Start live log display
    Invoke-SpectreLive -Data $layout -ScriptBlock {
        param($Context)
        
        $logLines = @()
        $maxLines = 20
        
        # Update header
        $headerContent = "Container Logs: [bold]$($container.Name)[/] [grey]Press Ctrl+C to exit[/]" | Format-SpectrePanel -Color "DodgerBlue1"
        $layout["header"].Update($headerContent) | Out-Null
        
        # Get initial logs
        try {
            $initialLogs = docker logs --tail 20 $container.ID 2>&1
            if ($initialLogs) {
                $logLines += $initialLogs
            }
        }
        catch {
            $logLines += "[red]Error fetching logs: $($_.Exception.Message)[/]"
        }

        while ($true) {
            try {
                # Get recent logs
                $newLogs = docker logs --since 1s $container.ID 2>&1
                
                if ($newLogs) {
                    foreach ($log in $newLogs) {
                        $logLines.Add("$(Get-Date -Format 'HH:mm:ss') | $log")
                        
                        # Keep only the last maxLines
                        if ($logLines.Count -gt $maxLines) {
                            $logLines.RemoveAt(0)
                        }
                    }
                }

                # Update logs display
                $logsContent = if ($logLines.Count -gt 0) {
                    ($logLines -join "`n") | Get-SpectreEscapedText
                } else {
                    "[grey]No logs available[/]"
                }
                
                $logsPanel = $logsContent | Format-SpectrePanel -Header "Live Logs" -Color "Green" -Expand
                $layout["logs"].Update($logsPanel) | Out-Null
                
                $Context.Refresh()
                Start-Sleep -Seconds 1
            }
            catch {
                $errorMsg = "[red]Error: $($_.Exception.Message)[/]" | Format-SpectrePanel -Color "Red" -Expand
                $layout["logs"].Update($errorMsg) | Out-Null
                $Context.Refresh()
                break
            }
        }
    }
}

function Start-ImageBrowser {
    <#
    .SYNOPSIS
        Starts the Docker Hub image browser interface.
    #>
    
    Write-SpectreRule -Title "Popular Docker Hub Images" -Color "DodgerBlue1"

    # Get popular images with status
    $images = Invoke-SpectreCommandWithStatus -Title "Fetching popular images from Docker Hub..." -Spinner "Dots" -Color "DodgerBlue1" -ScriptBlock {
        Get-DockerHubPopularImages
    }

    if ($images.Count -eq 0) {
        "[red]Failed to fetch images from Docker Hub.[/]" | Format-SpectrePanel -Header "Error" -Color "Red"
        Read-SpectrePause
        return
    }

    # Display images with logos
    Show-DockerImagesWithLogos -Images $images

    # Let user select an image to pull
    $imageChoices = $images | ForEach-Object { "$($_.Name) - $($_.Description.Substring(0, [Math]::Min(50, $_.Description.Length)))" }
    $selectedImage = Read-SpectreSelection -Message "Select an image to pull" -Choices $imageChoices -Color "DodgerBlue1"
    
    if ($selectedImage) {
        $imageName = ($selectedImage -split ' - ')[0]
        
        $confirm = Read-SpectreConfirm -Message "Pull Docker image '$imageName'?" -DefaultAnswer "y"
        
        if ($confirm) {
            Invoke-SpectreCommandWithStatus -Title "Pulling Docker image '$imageName'..." -Spinner "Dots" -Color "DodgerBlue1" -ScriptBlock {
                try {
                    Write-SpectreHost "[grey]Executing: docker pull $imageName[/]"
                    $result = docker pull $imageName 2>&1
                    Write-SpectreHost "[green]Successfully pulled $imageName[/]"
                }
                catch {
                    Write-SpectreHost "[red]Error pulling image: $($_.Exception.Message)[/]"
                }
            }
        }
    }

    Read-SpectrePause
}

function Start-MainMenu {
    <#
    .SYNOPSIS
        Starts the main menu interface.
    #>
    
    while ($true) {
        Show-DemoHeader
        
        # Check Docker availability
        $dockerStatus = if (Test-DockerAvailable) {
            "[green]✓ Docker is available[/]"
        } else {
            "[red]✗ Docker is not available[/]"
        }
        
        Write-SpectreHost $dockerStatus
        Write-Host ""

        $menuOptions = @(
            "Container Management",
            "Browse Docker Hub Images", 
            "Demo Features (No Docker Required)",
            "Exit"
        )

        $selection = Read-SpectreSelection -Message "What would you like to do?" -Choices $menuOptions -Color "DodgerBlue1"

        switch ($selection) {
            "Container Management" { 
                Start-ContainerManagement 
            }
            "Browse Docker Hub Images" { 
                Start-ImageBrowser 
            }
            "Demo Features (No Docker Required)" {
                Start-FeatureDemo
            }
            "Exit" { 
                Write-SpectreHost "[green]Thanks for trying the Docker Wizard demo![/]"
                Write-SpectreRule -Title "Goodbye!" -Color "DodgerBlue1"
                return 
            }
        }
    }
}

function Start-FeatureDemo {
    <#
    .SYNOPSIS
        Demonstrates PwshSpectreConsole features without requiring Docker.
    #>
    
    Write-SpectreRule -Title "PwshSpectreConsole Feature Demo" -Color "DodgerBlue1"
    
    # Demo different widgets
    $features = @(
        "Tables and Data Display",
        "Charts and Visualizations",
        "Interactive Selections",
        "Progress and Status",
        "Layouts and Panels",
        "Text and Typography",
        "Back to Main Menu"
    )

    $feature = Read-SpectreSelection -Message "Which features would you like to see?" -Choices $features -Color "DodgerBlue1"

    switch ($feature) {
        "Tables and Data Display" { Demo-TablesAndData }
        "Charts and Visualizations" { Demo-ChartsAndVisualizations }
        "Interactive Selections" { Demo-InteractiveSelections }
        "Progress and Status" { Demo-ProgressAndStatus }
        "Layouts and Panels" { Demo-LayoutsAndPanels }
        "Text and Typography" { Demo-TextAndTypography }
        "Back to Main Menu" { return }
    }
}

function Demo-TablesAndData {
    <#
    .SYNOPSIS
        Demonstrates table and data display features.
    #>
    
    Write-SpectreRule -Title "Tables and Data Display Demo" -Color "Green"
    
    # Sample data
    $sampleData = @(
        [PSCustomObject]@{ Name = "Alice"; Age = 30; City = "New York"; Salary = 75000 }
        [PSCustomObject]@{ Name = "Bob"; Age = 25; City = "Los Angeles"; Salary = 65000 }
        [PSCustomObject]@{ Name = "Charlie"; Age = 35; City = "Chicago"; Salary = 80000 }
        [PSCustomObject]@{ Name = "Diana"; Age = 28; City = "Seattle"; Salary = 70000 }
    )

    # Basic table
    Write-SpectreHost "[bold]Basic Table:[/]"
    $sampleData | Format-SpectreTable -Color "Green"
    
    # Table with custom properties
    Write-SpectreHost "`n[bold]Table with Custom Formatting:[/]"
    $sampleData | Format-SpectreTable -Property @(
        @{Name='Employee'; Expression={ "[bold blue]$($_.Name)[/]" }},
        'Age',
        @{Name='Location'; Expression={ "[yellow]$($_.City)[/]" }},
        @{Name='Annual Salary'; Expression={ "[green]$($_.Salary.ToString('C'))[/]" }}
    ) -AllowMarkup -Title "Employee Information" -Color "Blue"

    Read-SpectrePause
}

function Demo-ChartsAndVisualizations {
    <#
    .SYNOPSIS
        Demonstrates chart and visualization features.
    #>
    
    Write-SpectreRule -Title "Charts and Visualizations Demo" -Color "Orange1"
    
    # Sample chart data
    $chartData = @()
    $chartData += New-SpectreChartItem -Label "Q1 Sales" -Value 1250000 -Color "Green"
    $chartData += New-SpectreChartItem -Label "Q2 Sales" -Value 1500000 -Color "Blue"
    $chartData += New-SpectreChartItem -Label "Q3 Sales" -Value 1100000 -Color "Orange1"
    $chartData += New-SpectreChartItem -Label "Q4 Sales" -Value 1800000 -Color "Red"

    # Bar chart
    Write-SpectreHost "[bold]Bar Chart:[/]"
    $chartData | Format-SpectreBarChart -Title "Quarterly Sales Performance" -Width 60
    
    Write-Host ""
    
    # Breakdown chart
    Write-SpectreHost "[bold]Breakdown Chart:[/]"
    $chartData | Format-SpectreBreakdownChart -Width 60

    Read-SpectrePause
}

function Demo-InteractiveSelections {
    <#
    .SYNOPSIS
        Demonstrates interactive selection features.
    #>
    
    Write-SpectreRule -Title "Interactive Selections Demo" -Color "Purple"
    
    # Single selection
    $colors = @("Red", "Green", "Blue", "Yellow", "Purple", "Orange", "Cyan", "Magenta")
    $selectedColor = Read-SpectreSelection -Message "Pick your favorite color" -Choices $colors -Color "Purple"
    Write-SpectreHost "You selected: [bold $selectedColor]$selectedColor[/]"
    
    Write-Host ""
    
    # Multi-selection
    $fruits = @("Apple", "Banana", "Orange", "Grape", "Strawberry", "Pineapple", "Mango")
    $selectedFruits = Read-SpectreMultiSelection -Message "Pick your favorite fruits" -Choices $fruits -Color "Green"
    Write-SpectreHost "You selected: [bold green]$($selectedFruits -join ', ')[/]"
    
    Write-Host ""
    
    # Confirmation
    $confirm = Read-SpectreConfirm -Message "Do you like these interactive features?" -DefaultAnswer "y"
    if ($confirm) {
        Write-SpectreHost "[green]Great! PwshSpectreConsole makes CLI apps much more engaging![/]"
    } else {
        Write-SpectreHost "[yellow]That's okay, different tools work for different people![/]"
    }

    Read-SpectrePause
}

function Demo-ProgressAndStatus {
    <#
    .SYNOPSIS
        Demonstrates progress and status features.
    #>
    
    Write-SpectreRule -Title "Progress and Status Demo" -Color "Cyan1"
    
    # Status spinner
    Write-SpectreHost "[bold]Status Spinner Demo:[/]"
    Invoke-SpectreCommandWithStatus -Title "Processing data..." -Spinner "Dots2" -Color "Cyan1" -ScriptBlock {
        for ($i = 1; $i -le 5; $i++) {
            Write-SpectreHost "`n[grey]Step $i completed[/]"
            Start-Sleep -Seconds 1
        }
    }
    
    # Progress bars
    Write-SpectreHost "`n[bold]Progress Bar Demo:[/]"
    Invoke-SpectreCommandWithProgress -ScriptBlock {
        param($Context)
        
        $task1 = $Context.AddTask("Downloading files")
        $task2 = $Context.AddTask("Processing data")
        $task3 = $Context.AddTask("Generating report")
        
        # Simulate work with progress updates
        for ($i = 0; $i -le 100; $i += 10) {
            Start-Sleep -Milliseconds 200
            $task1.Increment(10)
            
            if ($i -ge 30) {
                $task2.Increment(7)
            }
            
            if ($i -ge 60) {
                $task3.Increment(5)
            }
        }
    }

    Read-SpectrePause
}

function Demo-LayoutsAndPanels {
    <#
    .SYNOPSIS
        Demonstrates layout and panel features.
    #>
    
    Write-SpectreRule -Title "Layouts and Panels Demo" -Color "Magenta"
    
    # Simple panels
    Write-SpectreHost "[bold]Panel Examples:[/]"
    
    "This is a simple panel with default styling." | Format-SpectrePanel -Header "Default Panel"
    
    "This is a panel with custom colors and borders." | Format-SpectrePanel -Header "Custom Panel" -Color "Green" -Border "Double"
    
    # Layout example
    Write-SpectreHost "`n[bold]Layout Example:[/]"
    
    $leftContent = @"
Left Panel Content:
• Item 1
• Item 2  
• Item 3
• Item 4
"@ | Format-SpectrePanel -Header "Left Side" -Color "Blue" -Expand

    $rightContent = @"
Right Panel Content:
→ Feature A
→ Feature B
→ Feature C
→ Feature D
"@ | Format-SpectrePanel -Header "Right Side" -Color "Green" -Expand

    @($leftContent, $rightContent) | Format-SpectreColumns -Expand

    Read-SpectrePause
}

function Demo-TextAndTypography {
    <#
    .SYNOPSIS
        Demonstrates text and typography features.
    #>
    
    Write-SpectreRule -Title "Text and Typography Demo" -Color "Yellow"
    
    # Figlet text
    Write-SpectreFigletText -Text "AWESOME!" -Alignment Center -Color "Yellow"
    
    # Rich text with markup
    Write-SpectreHost "[bold]Rich Text Examples:[/]"
    Write-SpectreHost "You can use [bold]bold[/], [italic]italic[/], [underline]underlined[/] text."
    Write-SpectreHost "Colors work too: [red]red[/], [green]green[/], [blue]blue[/], [yellow]yellow[/]"
    Write-SpectreHost "Even [bold red on yellow]combinations[/] are possible!"
    Write-SpectreHost "Emojis work great too! 🚀 ⭐ 💻 🎉"
    
    # Rules
    Write-SpectreRule -Title "Different Rule Styles" -Color "Red"
    Write-SpectreRule -Color "Green"
    Write-SpectreRule -Title "Centered Rule" -Alignment Center -Color "Blue"

    Read-SpectrePause
}

# Main execution
if ($MyInvocation.InvocationName -ne '.') {
    try {
        Start-MainMenu
    }
    catch {
        Write-SpectreHost "[red]An error occurred: $($_.Exception.Message)[/]"
        $_ | Format-SpectreException
    }
}
