#!/usr/bin/env pwsh
<#
.SYNOPSIS
    PwshSpectreConsole Features Demo
    
.DESCRIPTION
    This demo showcases the various widgets and features available in PwshSpectreConsole.
    Each section demonstrates different capabilities like tables, charts, selections, and layouts.
    
.EXAMPLE
    .\FeaturesDemo.ps1
    
.NOTES
    Requires: PwshSpectreConsole module
#>

#Requires -Module PwshSpectreConsole

[CmdletBinding()]
param()

#region Demo Data

function Get-SampleData {
    <#
    .SYNOPSIS
        Generates sample data for demonstrations
    #>
    return @(
        [PSCustomObject]@{ Name = "Alice"; Age = 28; Department = "Engineering"; Salary = 85000; Status = "Active" }
        [PSCustomObject]@{ Name = "Bob"; Age = 34; Department = "Marketing"; Salary = 72000; Status = "Active" }
        [PSCustomObject]@{ Name = "Carol"; Age = 29; Department = "Engineering"; Salary = 88000; Status = "Active" }
        [PSCustomObject]@{ Name = "David"; Age = 42; Department = "Sales"; Salary = 95000; Status = "Active" }
        [PSCustomObject]@{ Name = "Eve"; Age = 31; Department = "HR"; Salary = 65000; Status = "Inactive" }
    )
}

function Get-SampleChartData {
    <#
    .SYNOPSIS
        Generates sample chart data
    #>
    return @(
        (New-SpectreChartItem -Label "Apples" -Value 12 -Color "Green"),
        (New-SpectreChartItem -Label "Oranges" -Value 8 -Color "Orange1"),
        (New-SpectreChartItem -Label "Bananas" -Value 15 -Color "Yellow"),
        (New-SpectreChartItem -Label "Grapes" -Value 6 -Color "Purple"),
        (New-SpectreChartItem -Label "Strawberries" -Value 20 -Color "Red")
    )
}

#endregion

#region Demo Functions

function Show-TitleAndWelcome {
    <#
    .SYNOPSIS
        Demonstrates figlet text and basic formatting
    #>
    param(
        # Whether to pause after display
        [switch]$Pause
    )
    
    Clear-Host
    
    # Set theme colors
    Set-SpectreColors -AccentColor "Cyan1" -DefaultValueColor "Grey70"
    
    # Title with figlet text
    Write-SpectreFigletText -Text "Spectre Demo" -Alignment Center -Color "Cyan1"
    
    # Horizontal rule
    Write-SpectreRule -Title "PwshSpectreConsole Features Showcase" -Alignment Center -Color "Blue"
    
    # Welcome panel
    $welcomeText = @"
Welcome to the PwshSpectreConsole Features Demo!

This demonstration will show you the power and beauty of building 
terminal user interfaces with Spectre Console in PowerShell.

🎨 Beautiful colors and styling
📊 Interactive charts and tables  
🔍 Selection prompts and forms
📱 Responsive layouts
⚡ Live updates and progress bars
🎯 And much more!
"@
    
    $welcomeText | Format-SpectrePanel -Header "Welcome" -Color "Green" -Border "Rounded" -Expand | Out-SpectreHost
    
    if ($Pause) {
        Read-SpectrePause -Message "Press [cyan1]any key[/] to start the feature tour..." -AnyKey
    }
}

function Demo-Tables {
    <#
    .SYNOPSIS
        Demonstrates table formatting capabilities
    #>
    
    Clear-Host
    Write-SpectreRule -Title "Tables Demo" -Color "Green"
    
    Write-SpectreHost "📊 Let's look at table formatting capabilities...`n"
    
    $data = Get-SampleData
    
    # Basic table
    Write-SpectreHost "[bold green]Basic Table:[/]"
    $data | Format-SpectreTable -Color "Green" | Out-SpectreHost
    
    Read-SpectrePause -Message "Press [green]any key[/] for advanced table features..." -AnyKey
    
    # Table with custom properties and markup
    Write-SpectreHost "`n[bold green]Advanced Table with Custom Formatting:[/]"
    $customProperties = @(
        @{Name='Employee'; Expression={ "[bold blue]$($_.Name)[/]" }},
        @{Name='Age'; Expression={ $_.Age }; Alignment='Center'},
        @{Name='Department'; Expression={ 
            switch ($_.Department) {
                'Engineering' { "[green]🔧 $($_.Department)[/]" }
                'Marketing' { "[yellow]📢 $($_.Department)[/]" }
                'Sales' { "[blue]💰 $($_.Department)[/]" }
                'HR' { "[purple]👥 $($_.Department)[/]" }
                default { $_.Department }
            }
        }},
        @{Name='Salary'; Expression={ "[bold]${0:N0}[/]" -f $_.Salary }; Alignment='Right'},
        @{Name='Status'; Expression={ 
            if ($_.Status -eq 'Active') { "[green]✅ Active[/]" } else { "[red]❌ Inactive[/]" }
        }}
    )
    
    $data | Format-SpectreTable -Property $customProperties -Title "Employee Information" -AllowMarkup -Border "Double" -Color "Cyan1" | Out-SpectreHost
    
    Read-SpectrePause -AnyKey
}

function Demo-Charts {
    <#
    .SYNOPSIS
        Demonstrates chart capabilities
    #>
    
    Clear-Host
    Write-SpectreRule -Title "Charts Demo" -Color "Yellow"
    
    Write-SpectreHost "📈 Chart visualization capabilities...`n"
    
    $chartData = Get-SampleChartData
    
    # Bar chart
    Write-SpectreHost "[bold yellow]Bar Chart:[/]"
    $chartData | Format-SpectreBarChart -Label "Fruit Sales (dozens)" -Width 60 | Out-SpectreHost
    
    Write-SpectreHost "`n[bold yellow]Breakdown Chart:[/]"
    $chartData | Format-SpectreBreakdownChart -Width 60 | Out-SpectreHost
    
    Read-SpectrePause -AnyKey
}

function Demo-Selections {
    <#
    .SYNOPSIS
        Demonstrates selection prompts
    #>
    
    Clear-Host
    Write-SpectreRule -Title "Selection Prompts Demo" -Color "Purple"
    
    Write-SpectreHost "🔍 Interactive selection capabilities...`n"
    
    # Simple selection
    $colors = @("Red", "Green", "Blue", "Yellow", "Purple", "Orange", "Pink", "Cyan")
    $selectedColor = Read-SpectreSelection -Message "Choose your favorite color:" -Choices $colors -Color "Purple"
    
    Write-SpectreHost "You selected: [bold $selectedColor]$selectedColor[/]`n"
    
    # Multi-selection
    $hobbies = @("Reading", "Gaming", "Cooking", "Traveling", "Photography", "Music", "Sports", "Art")
    $selectedHobbies = Read-SpectreMultiSelection -Message "Select your hobbies (multiple choice):" -Choices $hobbies -Color "Purple"
    
    Write-SpectreHost "Your hobbies: [bold purple]$($selectedHobbies -join ', ')[/]`n"
    
    # Confirmation
    $confirm = Read-SpectreConfirm -Message "Are you enjoying this demo?" -ConfirmSuccess "🎉 Awesome!" -ConfirmFailure "😢 We'll try harder!"
    
    Read-SpectrePause -AnyKey
}

function Demo-TextAndInput {
    <#
    .SYNOPSIS
        Demonstrates text input and styling
    #>
    
    Clear-Host
    Write-SpectreRule -Title "Text Input & Styling Demo" -Color "Red"
    
    Write-SpectreHost "✏️ Text input and styling features...`n"
    
    # Text input
    $name = Read-SpectreText -Message "What's your name?" -DefaultAnswer "Anonymous User"
    
    # Styled output
    Write-SpectreHost "Hello, [bold red]$name[/]! 👋`n"
    
    # Panel with styled text
    $styledText = @"
[bold]Markdown-like Styling:[/]

[italic]Italic text[/]
[bold]Bold text[/]
[underline]Underlined text[/]
[strikethrough]Strikethrough text[/]

[red]Red text[/]
[green]Green text[/]
[blue]Blue text[/]
[yellow]Yellow background[/]

[link=https://spectreconsole.net]Visit Spectre Console[/]

🚨 [blink]Blinking text![/]
"@
    
    $styledText | Format-SpectrePanel -Header "Text Styling Showcase" -Color "Red" -Border "Double" | Out-SpectreHost
    
    Read-SpectrePause -AnyKey
}

function Demo-Progress {
    <#
    .SYNOPSIS
        Demonstrates progress indicators
    #>
    
    Clear-Host
    Write-SpectreRule -Title "Progress Indicators Demo" -Color "Orange1"
    
    Write-SpectreHost "⏳ Progress and status indicators...`n"
    
    # Status spinner
    $result1 = Invoke-SpectreCommandWithStatus -Title "Loading user data..." -Spinner "Dots" -ScriptBlock {
        Start-Sleep -Seconds 2
        return "User data loaded successfully!"
    }
    
    Write-SpectreHost "Result: [green]$result1[/]`n"
    
    # Progress bar
    $result2 = Invoke-SpectreCommandWithProgress -ScriptBlock {
        param ($Context)
        
        $task = $Context.AddTask("Processing files...")
        
        for ($i = 1; $i -le 20; $i++) {
            Start-Sleep -Milliseconds 100
            $task.Increment(5)
        }
        
        return "All files processed!"
    }
    
    Write-SpectreHost "Result: [green]$result2[/]`n"
    
    Read-SpectrePause -AnyKey
}

function Demo-Layouts {
    <#
    .SYNOPSIS
        Demonstrates layout capabilities
    #>
    
    Clear-Host
    Write-SpectreRule -Title "Layouts Demo" -Color "Magenta1"
    
    Write-SpectreHost "📱 Layout and composition capabilities...`n"
    
    # Create sample content
    $calendar = Write-SpectreCalendar -Date (Get-Date) -PassThru
    $sampleTable = Get-SampleData | Select-Object Name, Department, Status | Format-SpectreTable -Color "Blue"
    $chartData = Get-SampleChartData | Format-SpectreBarChart -Width 30
    
    # Columns layout
    Write-SpectreHost "[bold magenta1]Columns Layout:[/]"
    @($sampleTable, $calendar) | Format-SpectreColumns -Padding 2 | Out-SpectreHost
    
    Write-SpectreHost "`n[bold magenta1]Rows Layout:[/]"
    @($chartData, "This is additional content below the chart") | Format-SpectreRows | Format-SpectrePanel -Header "Chart and Text" | Out-SpectreHost
    
    Read-SpectrePause -AnyKey
    
    # Complex nested layout
    Clear-Host
    Write-SpectreHost "[bold magenta1]Complex Nested Layout:[/]"
    
    $layout = New-SpectreLayout -Name "root" -Rows @(
        (New-SpectreLayout -Name "header" -MinimumSize 3 -Ratio 1 -Data (
            "📊 Dashboard Header" | Format-SpectreAligned -HorizontalAlignment Center | Format-SpectrePanel -Header "Header" -Color "Blue" -Expand
        )),
        (New-SpectreLayout -Name "content" -Ratio 5 -Columns @(
            (New-SpectreLayout -Name "left" -Ratio 2 -Data (
                $sampleTable | Format-SpectrePanel -Header "Data Table" -Color "Green" -Expand
            )),
            (New-SpectreLayout -Name "right" -Ratio 3 -Data (
                $calendar | Format-SpectreAligned -HorizontalAlignment Center -VerticalAlignment Middle | Format-SpectrePanel -Header "Calendar" -Color "Yellow" -Expand
            ))
        )),
        (New-SpectreLayout -Name "footer" -MinimumSize 3 -Ratio 1 -Data (
            "Status: All systems operational ✅" | Format-SpectreAligned -HorizontalAlignment Center | Format-SpectrePanel -Header "Status" -Color "Purple" -Expand
        ))
    )
    
    $layout | Out-SpectreHost
    
    Read-SpectrePause -AnyKey
}

function Demo-Tree {
    <#
    .SYNOPSIS
        Demonstrates tree structure display
    #>
    
    Clear-Host
    Write-SpectreRule -Title "Tree Structures Demo" -Color "Green"
    
    Write-SpectreHost "🌳 Tree structure visualization...`n"
    
    # File system-like tree
    $treeData = @{
        Value = "📁 Project Root"
        Children = @(
            @{
                Value = "📁 src"
                Children = @(
                    @{ Value = "📄 main.ps1"; Children = @() },
                    @{ Value = "📄 helpers.ps1"; Children = @() },
                    @{
                        Value = "📁 modules"
                        Children = @(
                            @{ Value = "📄 auth.psm1"; Children = @() },
                            @{ Value = "📄 utils.psm1"; Children = @() }
                        )
                    }
                )
            },
            @{
                Value = "📁 tests"
                Children = @(
                    @{ Value = "📄 main.tests.ps1"; Children = @() },
                    @{ Value = "📄 helpers.tests.ps1"; Children = @() }
                )
            },
            @{
                Value = "📁 docs"
                Children = @(
                    @{ Value = "📄 README.md"; Children = @() },
                    @{ Value = "📄 CHANGELOG.md"; Children = @() }
                )
            }
        )
    }
    
    $treeData | Format-SpectreTree -Guide "BoldLine" -Color "Green" | Out-SpectreHost
    
    Read-SpectrePause -AnyKey
}

function Demo-Exception {
    <#
    .SYNOPSIS
        Demonstrates exception formatting
    #>
    
    Clear-Host
    Write-SpectreRule -Title "Exception Formatting Demo" -Color "Red"
    
    Write-SpectreHost "🐛 Exception and error formatting...`n"
    
    # Create a sample exception
    try {
        # This will throw an exception
        Get-ChildItem -Path "C:\NonExistentPath\InvalidFile.txt" -ErrorAction Stop
    }
    catch {
        Write-SpectreHost "[bold red]Standard PowerShell Error:[/]"
        Write-SpectreHost $_.Exception.Message
        
        Write-SpectreHost "`n[bold red]Spectre Formatted Exception:[/]"
        $_ | Format-SpectreException | Out-SpectreHost
    }
    
    Read-SpectrePause -AnyKey
}

function Demo-Json {
    <#
    .SYNOPSIS
        Demonstrates JSON formatting
    #>
    
    Clear-Host
    Write-SpectreRule -Title "JSON Formatting Demo" -Color "Cyan1"
    
    Write-SpectreHost "📋 JSON syntax highlighting...`n"
    
    # Create sample JSON data
    $jsonData = @{
        name = "John Doe"
        age = 30
        isEmployed = $true
        skills = @("PowerShell", "C#", "Python")
        address = @{
            street = "123 Main St"
            city = "Anytown"
            zipCode = "12345"
            country = "USA"
        }
        projects = @(
            @{
                name = "Project Alpha"
                status = "completed"
                startDate = "2023-01-15"
            },
            @{
                name = "Project Beta"
                status = "in-progress"
                startDate = "2023-06-01"
            }
        )
    }
    
    Write-SpectreHost "[bold cyan1]Syntax Highlighted JSON:[/]"
    $jsonData | Format-SpectreJson | Format-SpectrePanel -Header "Employee Data" -Color "Cyan1" | Out-SpectreHost
    
    Read-SpectrePause -AnyKey
}

function Show-FeatureMenu {
    <#
    .SYNOPSIS
        Shows the feature demonstration menu
    #>
    
    $features = @(
        "📊 Tables & Data Display",
        "📈 Charts & Graphs", 
        "🔍 Selection Prompts",
        "✏️ Text Input & Styling",
        "⏳ Progress Indicators",
        "📱 Layouts & Composition",
        "🌳 Tree Structures",
        "🐛 Exception Formatting",
        "📋 JSON Formatting",
        "🎨 All Features Tour",
        "❌ Exit Demo"
    )
    
    Clear-Host
    Write-SpectreFigletText -Text "Features Menu" -Alignment Center -Color "Cyan1"
    Write-SpectreRule -Title "Choose a Feature to Demonstrate" -Alignment Center -Color "Blue"
    
    $selection = Read-SpectreSelection -Message "Select a feature to explore:" -Choices $features -Color "Cyan1" -EnableSearch
    
    return $selection
}

function Start-AllFeaturesDemo {
    <#
    .SYNOPSIS
        Runs through all demo features in sequence
    #>
    
    Show-TitleAndWelcome -Pause
    Demo-Tables
    Demo-Charts  
    Demo-Selections
    Demo-TextAndInput
    Demo-Progress
    Demo-Layouts
    Demo-Tree
    Demo-Exception
    Demo-Json
    
    Clear-Host
    Write-SpectreFigletText -Text "Demo Complete!" -Alignment Center -Color "Green"
    Write-SpectreRule -Title "Thank You!" -Alignment Center -Color "Green"
    
    $completionText = @"
🎉 Congratulations! You've completed the full PwshSpectreConsole features tour.

This demonstration covered:
• Beautiful tables with custom formatting
• Interactive charts and visualizations  
• Selection prompts and user input
• Text styling and markup
• Progress indicators and status updates
• Flexible layouts and composition
• Tree structure displays
• Exception formatting
• JSON syntax highlighting

Ready to build amazing terminal applications? 
Visit https://pwshspectreconsole.com for documentation and examples!
"@
    
    $completionText | Format-SpectrePanel -Header "Demo Complete" -Color "Green" -Border "Double" -Expand | Out-SpectreHost
}

#endregion

#region Main Script

function Start-FeaturesDemo {
    <#
    .SYNOPSIS
        Main entry point for the features demo
    #>
    
    try {
        Show-TitleAndWelcome
        
        while ($true) {
            $selection = Show-FeatureMenu
            
            switch ($selection) {
                "📊 Tables & Data Display" { Demo-Tables }
                "📈 Charts & Graphs" { Demo-Charts }
                "🔍 Selection Prompts" { Demo-Selections }
                "✏️ Text Input & Styling" { Demo-TextAndInput }
                "⏳ Progress Indicators" { Demo-Progress }
                "📱 Layouts & Composition" { Demo-Layouts }
                "🌳 Tree Structures" { Demo-Tree }
                "🐛 Exception Formatting" { Demo-Exception }
                "📋 JSON Formatting" { Demo-Json }
                "🎨 All Features Tour" { 
                    Start-AllFeaturesDemo
                    break
                }
                "❌ Exit Demo" {
                    Clear-Host
                    Write-SpectreFigletText -Text "Goodbye!" -Alignment Center -Color "Cyan1"
                    Write-SpectreHost "Thanks for exploring PwshSpectreConsole!"
                    Write-SpectreHost "Visit [link]https://pwshspectreconsole.com[/] to learn more!"
                    return
                }
            }
        }
    }
    catch {
        Write-SpectreHost "❌ [red]An error occurred:[/]: $($_.Exception.Message)"
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
Start-FeaturesDemo

#endregion
