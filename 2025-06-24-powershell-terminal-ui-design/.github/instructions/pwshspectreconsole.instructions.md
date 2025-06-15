---
applyTo: '**/*.ps1'
---
# PwshSpectreConsole Instructions

You have access to the following commands from the PwshSpectreConsole library.

# Commands

## Add-SpectreJob

```powershell

NAME
    Add-SpectreJob
    
SYNOPSIS
    Adds a Spectre job to a list of jobs.
    
    
SYNTAX
    Add-SpectreJob [-Context] <ProgressContext> [-JobName] <String> [-Job] <Job> [<CommonParameters>]
    
    
DESCRIPTION
    This function adds a Spectre job to the list of jobs you want to wait for with Wait-SpectreJobs.  
    To retrieve the outcome of the job you need to use the standard PowerShell Receive-Job cmdlet.
    :::note
    This is only used inside `Invoke-SpectreCommandWithProgress` where the Spectre ProgressContext object is exposed.
    :::
    

PARAMETERS
    -Context <ProgressContext>
        The Spectre context to add the job to. The context object is only available inside Invoke-SpectreCommandWithProgress.
        [https://spectreconsole.net/api/spectre.console/progresscontext/](https://spectreconsole.net/api/spectre.console/progresscontext/)
        
    -JobName <String>
        The name of the job to add.
        
    -Job <Job>
        The PowerShell job to add to the context.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to add two jobs to a context and wait for them to complete.
    
    $jobOutcomes = Invoke-SpectreCommandWithProgress -ScriptBlock {
        param (
            [Spectre.Console.ProgressContext] $Context
        )
        $jobs = @()
        $jobs += Add-SpectreJob -Context $Context -JobName "job 1" -Job (Start-Job { Start-Sleep -Seconds 2 })
        $jobs += Add-SpectreJob -Context $Context -JobName "job 2" -Job (Start-Job { Start-Sleep -Seconds 4 })
        Wait-SpectreJobs -Context $Context -Jobs $jobs
        return $jobs.Job
    }
    $jobOutcomes | Format-SpectreTable -Property Id, Name, PSJobTypeName, State, Command
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Add-SpectreJob -Examples"
    For more information, type: "Get-Help Add-SpectreJob -Detailed"
    For technical information, type: "Get-Help Add-SpectreJob -Full"



```

## Format-SpectreBarChart

```powershell

NAME
    Format-SpectreBarChart
    
SYNOPSIS
    Formats and displays a bar chart using the Spectre Console module.
    
    
SYNTAX
    Format-SpectreBarChart [-Data] <Object> [[-Label] <String>] [[-Width] <Int32>] [-HideValues] [<CommonParameters>]
    
    
DESCRIPTION
    This function takes an array of data and displays it as a bar chart using the Spectre Console module. The chart can be customized with a title and width.  
    See https://spectreconsole.net/widgets/barchart for more information.
    

PARAMETERS
    -Data <Object>
        An array of objects containing the data to be displayed in the chart. Each object should have a Label, Value, and Color property.
        
    -Label <String>
        The title to be displayed above the chart.
        
    -Width <Int32>
        The width of the chart in characters.
        
    -HideValues [<SwitchParameter>]
        Hides the values from being displayed on the chart.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to display a bar chart of various data points.
    $data = @()
    
    $data += New-SpectreChartItem -Label "Apples" -Value 10 -Color "Green"
    $data += New-SpectreChartItem -Label "Oranges" -Value 5 -Color "DarkOrange"
    $data += New-SpectreChartItem -Label "Bananas" -Value 2.2 -Color "#FFFF00"
    
    Format-SpectreBarChart -Data $data -Label "Fruit Sales" -Width 50
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Format-SpectreBarChart -Examples"
    For more information, type: "Get-Help Format-SpectreBarChart -Detailed"
    For technical information, type: "Get-Help Format-SpectreBarChart -Full"



```

## Format-SpectreBreakdownChart

```powershell

NAME
    Format-SpectreBreakdownChart
    
SYNOPSIS
    Formats data into a breakdown chart.
    
    
SYNTAX
    Format-SpectreBreakdownChart [-Data] <Object> [[-Width] <Int32>] [-HideTags] [-HideTagValues] [-ShowPercentage] [<CommonParameters>]
    
    
DESCRIPTION
    This function takes an array of data and formats it into a breakdown chart using BreakdownChart. The chart can be customized with a specified width and color.  
    See https://spectreconsole.net/widgets/breakdownchart for more information.
    

PARAMETERS
    -Data <Object>
        An array of data to be formatted into a breakdown chart.
        
    -Width <Int32>
        The width of the chart. Defaults to the width of the console.
        
    -HideTags [<SwitchParameter>]
        Hides the tags on the chart.
        
    -HideTagValues [<SwitchParameter>]
        Hides the tag values on the chart.
        
    -ShowPercentage [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to display a breakdown chart of various data points.
    $data = @()
    
    $data += New-SpectreChartItem -Label "Apples" -Value 10 -Color "Green"
    $data += New-SpectreChartItem -Label "Oranges" -Value 5 -Color "Gold1"
    $data += New-SpectreChartItem -Label "Bananas" -Value 2.2 -Color "#FFFF00"
    
    Format-SpectreBreakdownChart -Data $data -Width 50
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Format-SpectreBreakdownChart -Examples"
    For more information, type: "Get-Help Format-SpectreBreakdownChart -Detailed"
    For technical information, type: "Get-Help Format-SpectreBreakdownChart -Full"



```

## Format-SpectrePanel

```powershell

NAME
    Format-SpectrePanel
    
SYNOPSIS
    Formats a string as a Spectre Console panel with optional title, border, and color.
    
    
SYNTAX
    Format-SpectrePanel [-Data] <Object> [[-Header] <String>] [[-Border] <String>] [-Expand] [[-Color] <Color>] [[-Width] <Int32>] [[-Height] <Int32>] [<CommonParameters>]
    
    
DESCRIPTION
    This function takes a string and formats it as a Spectre Console panel with optional title, border, and color. The resulting panel can be displayed in the console using the Write-Host command.  
    This function takes a string or renderable object and formats it as a Spectre Console panel with optional title, border, and color. The resulting panel can be displayed in the console using the Write-Host command.  
    
    :::note  
    A panel can only contain a single renderable object. To combine multiple items (such as text and images) in one panel, you'll need to wrap them in a container like Format-SpectreRows or Format-SpectreColumns first. Without this wrapping, Format-SpectrePanel will render each item in a separate panel.
    :::  
    
    See https://spectreconsole.net/widgets/panel for more information.
    

PARAMETERS
    -Data <Object>
        The renderable item to be formatted as a panel.
        
    -Header <String>
        The title to be displayed at the top of the panel.
        
    -Border <String>
        The type of border to be displayed around the panel.
        
    -Expand [<SwitchParameter>]
        Switch parameter that specifies whether the panel should be expanded to fill the available space.
        
    -Color <Color>
        The color of the panel border.
        
    -Width <Int32>
        The width of the panel.
        
    -Height <Int32>
        The height of the panel.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to display a panel with a title and a rounded border.
    Format-SpectrePanel -Data "Hello, world!" -Title "My Panel" -Border "Rounded" -Color "Red"
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > # **Example 2**  
    # This example demonstrates how to display a panel with a title and a double border that's expanded to take up the whole console width.
    "Hello, big panel!" | Format-SpectrePanel -Title "My Big Panel" -Border "Double" -Color "Magenta1" -Expand
    
    
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS > # **Example 3**  
    # This example demonstrates how to combine text and images in a single panel.
    # When combining multiple items in a panel, use Format-SpectreRows or Format-SpectreColumns to wrap them into a single renderable object.
    $message = "Thanks Jeff!"
    $image = Get-SpectreImage -ImagePath ".\private\images\smiley.png" -MaxWidth 25
    @($message, $image) | Format-SpectreRows | Format-SpectrePanel
    
    
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS > # **Example 4**  
    # This example demonstrates how to combine text and images in a single panel with side-by-side layout.
    $message = "Thanks Jeff!"
    $image = Get-SpectreImage -ImagePath ".\private\images\smiley.png" -MaxWidth 25  
    @($message, $image) | Format-SpectreColumns | Format-SpectrePanel
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Format-SpectrePanel -Examples"
    For more information, type: "Get-Help Format-SpectrePanel -Detailed"
    For technical information, type: "Get-Help Format-SpectrePanel -Full"



```

## Format-SpectreTable

```powershell

NAME
    Format-SpectreTable
    
SYNOPSIS
    Formats an array of objects into a Spectre Console table.
    
    
SYNTAX
    Format-SpectreTable -Data <Object> [-Wrap] [-Border <String>] [-Color <Color>] [-HeaderColor <Color>] [-TextColor <Color>] [-Width <Int32>] [-HideHeaders] [-Title <String>] [-AllowMarkup] [-Expand] [<CommonParameters>]
    
    Format-SpectreTable -Data <Object> [[-Property] <Object[]>] [-Wrap] [-Border <String>] [-Color <Color>] [-HeaderColor <Color>] [-TextColor <Color>] [-Width <Int32>] [-HideHeaders] [-Title <String>] [-AllowMarkup] [-Expand] [<CommonParameters>]
    
    Format-SpectreTable -Data <Object> [-Wrap] [-View <String>] [-Border <String>] [-Color <Color>] [-HeaderColor <Color>] [-TextColor <Color>] [-Width <Int32>] [-HideHeaders] [-Title <String>] [-AllowMarkup] [-Expand] [<CommonParameters>]
    
    
DESCRIPTION
    This function takes an array of objects and formats them into a table using the Spectre Console library. The table can be customized with a border style and color.  
    Thanks to [trackd](https://github.com/trackd) and [fmotion1](https://github.com/fmotion1) for the updates to support markdown and color in the table contents.  
    See https://spectreconsole.net/widgets/table for more information.
    

PARAMETERS
    -Data <Object>
        The array of objects to be formatted into a table.
        Takes pipeline input.
        
    -Property <Object[]>
        Specifies the object properties that appear in the display and the order in which they appear.
        Type one or more property names, separated by commas, or use a hash table to display a calculated property.
        Wildcards are permitted.
        The Property parameter is optional. You can't use the Property and View parameters in the same command.
        The value of the Property parameter can be a new calculated property.
        The calculated property can be a script block or a hash table. Valid key-value pairs are:
        - Name (or Label) `<string>`
        - Expression - `<string>` or `<script block>`
        - FormatString - `<string>`
        - Width - `<int32>` - must be greater than `0`
        - Alignment - value can be `Left`, `Center`, or `Right`
        
    -Wrap [<SwitchParameter>]
        Displays text that exceeds the column width on the next line. By default, text that exceeds the column width is truncated
        Currently there is a bug with this, spectre.console/issues/1185
        
    -View <String>
        The View parameter lets you specify an alternate format or custom view for the table.
        
    -Border <String>
        The border style of the table. Default is "Rounded".
        
    -Color <Color>
        The color of the table border. Default is the accent color of the script.
        
    -HeaderColor <Color>
        The color of the table header text. Default is the DefaultTableHeaderColor.
        
    -TextColor <Color>
        The color of the table text. Default is the DefaultTableTextColor.
        
    -Width <Int32>
        The width of the table.
        
    -HideHeaders [<SwitchParameter>]
        Hides the headers of the table.
        
    -Title <String>
        The title of the table.
        
    -AllowMarkup [<SwitchParameter>]
        Allow Spectre markup in the table elements e.g. [green]message[/].
        
    -Expand [<SwitchParameter>]
        Take up all of the horizontal space available.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to format an array of objects into a Spectre Console table.
    $data = @(
        [pscustomobject]@{Name="John"; Age=25; City="New York"},
        [pscustomobject]@{Name="Jane"; Age=30; City="Los Angeles"}
    )
    Format-SpectreTable -Data $data
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > # **Example 2**  
    # This example demonstrates how to format an array of objects into a Spectre Console table with custom properties generated by scriptblock expressions.
    $Properties = @(
        # foreground + background
        @{'Name'='FileName'; Expression={ "[white on DeepSkyBlue3_1]" + $_.Name + "[/]" }},
        # foreground
        @{'Name'='Last Updated'; Expression={ "[DeepSkyBlue3_1]" + $_.LastWriteTime.ToString() + "[/]" }},
        # background
        @{'Name'='Drive'; Expression={ "[black on LightGreen_1]" + $_.PSDrive.Root + "[/]" }}
    )
    Get-ChildItem | Format-SpectreTable -Property $Properties -AllowMarkup
    
    
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS > # **Example 3**  
    # This example demonstrates how to format an array of scalar objects into a Spectre Console table.
    1..10 | Format-SpectreTable -Title Numbers
    
    
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS > # **Example 4**  
    # This example demonstrates how to nest other renderable objects inside a table.
    $calendar = Write-SpectreCalendar -Date (Get-Date) -PassThru
    
    $fruits = @(
        (New-SpectreChartItem -Label "Bananas" -Value 2.2 -Color Yellow),
        (New-SpectreChartItem -Label "Oranges" -Value 6.6 -Color Orange1),
        (New-SpectreChartItem -Label "Apples" -Value 1 -Color Red)
    ) | Format-SpectreBarChart -Width 45
    
    @{
        Calendar = $calendar
        Fruits = $fruits
    } | Format-SpectreTable -Color Cyan1
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Format-SpectreTable -Examples"
    For more information, type: "Get-Help Format-SpectreTable -Detailed"
    For technical information, type: "Get-Help Format-SpectreTable -Full"



```

## Format-SpectreTree

```powershell

NAME
    Format-SpectreTree
    
SYNOPSIS
    Formats a hashtable as a tree using Spectre Console.
    
    
SYNTAX
    Format-SpectreTree [-Data] <Hashtable> [[-Guide] <String>] [[-Color] <Color>] [<CommonParameters>]
    
    
DESCRIPTION
    This function takes a hashtable and formats it as a tree using Spectre Console. The hashtable should have a 'Value' key and a 'Children' key. The 'Value' key should contain the Spectre Console renderable item (text or other objects like calendars etc.) for the node of the tree, and the 'Children' key should contain an array of hashtables representing the child nodes of the node.  
    See https://spectreconsole.net/widgets/tree for more information.
    

PARAMETERS
    -Data <Hashtable>
        The hashtable to format as a tree.
        
    -Guide <String>
        The type of line to use for the tree.
        
    -Color <Color>
        The color to use for the tree. This can be a Spectre Console color name or a hex color code. Default is the accent color defined in the script.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to display a tree with multiple children.
    $calendar = Write-SpectreCalendar -Date 2024-07-01 -PassThru
    $data = @{
        Value = "Root"
        Children = @(
            @{
                Value = "Child 1"
                Children = @(
                    @{
                        Value = "Grandchild 1"
                        Children = @()
                    },
                    @{
                        Value = $calendar
                        Children = @()
                    }
                )
            },
            @{
                Value = "Child 2"
                Children = @()
            }
        )
    }
    
    Format-SpectreTree -Data $data -Guide BoldLine -Color "Green"
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Format-SpectreTree -Examples"
    For more information, type: "Get-Help Format-SpectreTree -Detailed"
    For technical information, type: "Get-Help Format-SpectreTree -Full"



```

## Get-SpectreEscapedText

```powershell

NAME
    Get-SpectreEscapedText
    
SYNOPSIS
    Escapes text for use in Spectre Console.
    [ShaunLawrie/PwshSpectreConsole/issues/5](https://github.com/ShaunLawrie/PwshSpectreConsole/issues/5)
    
    
SYNTAX
    Get-SpectreEscapedText [-Text] <String> [<CommonParameters>]
    
    
DESCRIPTION
    This function escapes text for use where Spectre Console accepts markup. It is intended to be used as a helper function for other functions that output text to the console using Spectre Console which contains special characters that need escaping.
    See [https://spectreconsole.net/markup](https://spectreconsole.net/markup) for more information about the markup language used in Spectre Console.
    

PARAMETERS
    -Text <String>
        The text to be escaped.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to escape text for use in Spectre Console.
    $data = "][[][red]]][[/][][]["
    Format-SpectrePanel -Title "Unescaped data" -Data "I want escaped $($data | Get-SpectreEscapedText) [yellow]and[/] [red]unescaped[/] data"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Get-SpectreEscapedText -Examples"
    For more information, type: "Get-Help Get-SpectreEscapedText -Detailed"
    For technical information, type: "Get-Help Get-SpectreEscapedText -Full"



```

## Get-SpectreImage

```powershell

NAME
    Get-SpectreImage
    
SYNOPSIS
    Displays an image in the console using CanvasImage or SixelImage if the terminal supports Sixel.
    
    
SYNTAX
    Get-SpectreImage [-ImagePath] <String> [[-MaxWidth] <Int32>] [[-Format] <String>] [-Force] [<CommonParameters>]
    
    
DESCRIPTION
    Displays an image in the console using CanvasImage or SixelImage if the terminal supports Sixel.
    The image can be resized to a maximum width if desired.
    
    Windows Terminal supports Sixel in the [latest preview builds](https://apps.microsoft.com/detail/9n8g5rfz9xk3) so it will be available in the production builds soon 🤞
    See https://www.arewesixelyet.com/ for Sixel support status for your terminal.
    

PARAMETERS
    -ImagePath <String>
        The path to the image file to be displayed, as a local path or remote path using http/https.
        
    -MaxWidth <Int32>
        The maximum width of the image. If not specified, the image will be displayed at its original size.
        
    -Format <String>
        The preferred format to use when rendering the image.
        If not specified, the image will be rendered using Sixel if the terminal supports it, otherwise it will use Canvas.
        
    -Force [<SwitchParameter>]
        Forces the image to be displayed using the specified format, even if we can't detect Sixel support in the terminal.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # When Sixel is not supported the image will use the standard Canvas renderer which draws the image using character cells to represent the image.
    Get-SpectreImage -ImagePath ".\private\images\smiley.png" -MaxWidth 40
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > # **Example 2**  
    # For Sixel images, the image returned by `Get-SpectreImage` will render a new frame every time it's drawn so if it's an animated GIF it will appear animated if you render it repeatedly and move the cursor back to the same start position before each image output.
    #
    # ![Spectre Sixel Example](/lapras-terminal.gif)
    #
    NORECORDING
    $image = Get-SpectreImage ".\private\images\lapras-pokemon.gif" -MaxWidth 50
    
    Clear-Host
    [Console]::CursorVisible = $false
    
    for($frame = 0; $frame -lt 100; $frame++) {
        [Console]::SetCursorPosition(0, 0)
        $image | Format-SpectrePanel -Title "Frame: $frame" -Color White | Out-SpectreHost
        Start-Sleep -Milliseconds 150
    }
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Get-SpectreImage -Examples"
    For more information, type: "Get-Help Get-SpectreImage -Detailed"
    For technical information, type: "Get-Help Get-SpectreImage -Full"



```

## Invoke-SpectreCommandWithProgress

```powershell

NAME
    Invoke-SpectreCommandWithProgress
    
SYNOPSIS
    Invokes a Spectre command with a progress bar.
    
    
SYNTAX
    Invoke-SpectreCommandWithProgress [-ScriptBlock] <ScriptBlock> [<CommonParameters>]
    
    
DESCRIPTION
    This function takes a script block as a parameter and executes it while displaying a progress bar. The context and task objects are defined at [https://spectreconsole.net/api/spectre.console/progresscontext/](https://spectreconsole.net/api/spectre.console/progresscontext/).  
    The context requires at least one task to be added for progress to be displayed. The task object is used to update the progress bar by calling the `Increment()` method or other methods defined in Spectre console [https://spectreconsole.net/api/spectre.console/progresstask/](https://spectreconsole.net/api/spectre.console/progresstask/).  
    See https://spectreconsole.net/live/progress for more information.
    

PARAMETERS
    -ScriptBlock <ScriptBlock>
        The script block to execute.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates a 4-stage process with one loading bar that loads in four chunks.
    
    Invoke-SpectreCommandWithProgress -ScriptBlock {
        param (
            [Spectre.Console.ProgressContext] $Context
        )
        # AddTask() returns a https://spectreconsole.net/api/spectre.console/progresstask/ object
        $task1 = $Context.AddTask("A 4-stage process")
        Start-Sleep -Seconds 1
        $task1.Increment(25)
        Start-Sleep -Seconds 1
        $task1.Increment(25)
        Start-Sleep -Seconds 1
        $task1.Increment(25)
        Start-Sleep -Seconds 1
        $task1.Increment(25)
        Start-Sleep -Seconds 1
    }
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > # **Example 2**  
    # This example demonstrates a 2-stage process with two loading bars running in parallel.
    
    Invoke-SpectreCommandWithProgress -ScriptBlock {
        param (
            [Spectre.Console.ProgressContext] $Context
        )
        
        $jobs = @()
        $jobs += Add-SpectreJob -Context $Context -JobName "Drawing a picture" -Job (
            Start-Job {
                $progress = 0
                while($progress -lt 100) {
                    $progress += 1.5
                    Write-Progress -Activity "Processing" -PercentComplete $progress
                    Start-Sleep -Milliseconds 50
                }
            }
        )
        $jobs += Add-SpectreJob -Context $Context -JobName "Driving a car" -Job (
            Start-Job {
                $progress = 0
                while($progress -lt 100) {
                    $progress += 0.9
                    Write-Progress -Activity "Processing" -PercentComplete $progress
                    Start-Sleep -Milliseconds 50
                }
            }
        )
        
        Wait-SpectreJobs -Context $Context -Jobs $jobs
    }
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS > # **Example 3**  
    # This example demonstrates a task with an unknown (indeterminate) duration.
    
    $result = Invoke-SpectreCommandWithProgress -ScriptBlock {
        param (
            [Spectre.Console.ProgressContext] $Context
        )
        
        $task1 = $Context.AddTask("Task with unknown duration")
        $task1.IsIndeterminate = $true
        Start-Sleep -Seconds 5
        $task1.Value = 100
    
        return "Some result"
    }
    Write-SpectreHost "Result: $result"
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS > # **Example 4**  
    # This example demonstrates a job with an estimated duration, after the estimated duration has passed the job will switch to an indeterminate state.
    
    $result = Invoke-SpectreCommandWithProgress -ScriptBlock {
        param (
            [Spectre.Console.ProgressContext] $Context
        )
        
        $job = Add-SpectreJob -Context $Context -JobName "Doing some work" -Job (
            Start-Job {
                Start-Sleep -Seconds 10
                return 1234
            }
        )
        
        Wait-SpectreJobs -Context $Context -Jobs $job -EstimatedDurationSeconds 5
        
        $result = Receive-Job -Job $job.Job
        
        return $result
    }
    Write-SpectreHost "Result: $result"
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Invoke-SpectreCommandWithProgress -Examples"
    For more information, type: "Get-Help Invoke-SpectreCommandWithProgress -Detailed"
    For technical information, type: "Get-Help Invoke-SpectreCommandWithProgress -Full"



```

## Invoke-SpectreCommandWithStatus

```powershell

NAME
    Invoke-SpectreCommandWithStatus
    
SYNOPSIS
    Invokes a script block with a Spectre status spinner.
    
    
SYNTAX
    Invoke-SpectreCommandWithStatus [-ScriptBlock] <ScriptBlock> [[-Spinner] <String>] [-Title] <String> [[-Color] <Color>] [<CommonParameters>]
    
    
DESCRIPTION
    This function starts a Spectre status spinner with the specified title and spinner type, and invokes the specified script block. The spinner will continue to spin until the script block completes.  
    See https://spectreconsole.net/live/status for more information.
    

PARAMETERS
    -ScriptBlock <ScriptBlock>
        The script block to invoke.
        
    -Spinner <String>
        The type of spinner to display.
        
    -Title <String>
        The title to display above the spinner.
        
    -Color <Color>
        The color of the spinner. Valid values can be found with Get-SpectreDemoColors.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to show a spinner while doing some work. Write-SpectreHost is used to update the host with progress without breaking the spinner animation.
    
    $result = Invoke-SpectreCommandWithStatus -Spinner "Dots2" -Title "Showing a spinner..." -ScriptBlock {
        # Write updates to the host using Write-SpectreHost
        Start-Sleep -Seconds 1
        Write-SpectreHost "`n[grey]LOG:[/] Doing some work      "
        Start-Sleep -Seconds 1
        Write-SpectreHost "`n[grey]LOG:[/] Doing some more work "
        Start-Sleep -Seconds 1
        Write-SpectreHost "`n[grey]LOG:[/] Done                 "
        Start-Sleep -Seconds 1
        Write-SpectreHost " "
        return "Some result"
    }
    Write-SpectreHost "Result: $result"
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Invoke-SpectreCommandWithStatus -Examples"
    For more information, type: "Get-Help Invoke-SpectreCommandWithStatus -Detailed"
    For technical information, type: "Get-Help Invoke-SpectreCommandWithStatus -Full"



```

## Read-SpectreMultiSelection

```powershell

NAME
    Read-SpectreMultiSelection
    
SYNOPSIS
    Displays a multi-selection prompt using Spectre Console and returns the selected choices.
    
    
SYNTAX
    Read-SpectreMultiSelection [[-Message] <String>] [-Choices] <Array> [[-ChoiceLabelProperty] <String>] [[-Color] <Color>] [[-PageSize] <Int32>] [[-TimeoutSeconds] <Int32>] [-AllowEmpty] [<CommonParameters>]
    
    
DESCRIPTION
    This function displays a multi-selection prompt using Spectre Console and returns the selected choices. The prompt allows the user to select one or more choices from a list of options. The function supports customizing the title, choices, choice label property, color, and page size of the prompt.
    

PARAMETERS
    -Message <String>
        The title of the prompt. Defaults to "What are your favourite [Spectre.Console.Color]?".
        
    -Choices <Array>
        The list of choices to display in the selection prompt. ChoiceLabelProperty is required if the choices are complex objects rather than an array of strings.
        
    -ChoiceLabelProperty <String>
        If the object is complex then the property of the choice object to use as the label in the selection prompt is required.
        
    -Color <Color>
        The color to use for highlighting the selected choices. Defaults to the accent color of the script.
        
    -PageSize <Int32>
        The number of choices to display per page. Defaults to 5.
        
    -TimeoutSeconds <Int32>
        
    -AllowEmpty [<SwitchParameter>]
        Allow the multi-selection to be submitted without any options chosen.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates a multi-selection prompt with a custom title and choices.
    $fruits = Read-SpectreMultiSelection -Message "Select your favourite fruits" `
                                          -Choices @("apple", "banana", "orange", "pear", "strawberry", "durian", "lemon") `
                                          -PageSize 4
    # Type "↓", "<space>", "↓", "↓", "<space>", "↓", "<space>", "↲" to choose banana, pear and strawberry
    Write-SpectreHost "Your favourite fruits are $($fruits -join ', ')"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Read-SpectreMultiSelection -Examples"
    For more information, type: "Get-Help Read-SpectreMultiSelection -Detailed"
    For technical information, type: "Get-Help Read-SpectreMultiSelection -Full"



```

## Read-SpectreMultiSelectionGrouped

```powershell

NAME
    Read-SpectreMultiSelectionGrouped
    
SYNOPSIS
    Displays a multi-selection prompt with grouped choices and returns the selected choices.
    
    
SYNTAX
    Read-SpectreMultiSelectionGrouped [[-Message] <String>] [-Choices] <Array> [[-ChoiceLabelProperty] <String>] [[-Color] <Color>] [[-PageSize] <Int32>] [[-TimeoutSeconds] <Int32>] [-AllowEmpty] [<CommonParameters>]
    
    
DESCRIPTION
    Displays a multi-selection prompt with grouped choices and returns the selected choices. The prompt allows the user to select one or more choices from a list of options. The choices can be grouped into categories, and the user can select choices from each category.
    

PARAMETERS
    -Message <String>
        The title of the prompt. The default value is "What are your favourite [Spectre.Console.Color]?".
        
    -Choices <Array>
        An array of choice groups. Each group is a hashtable with two keys: "Name" and "Choices". The "Name" key is a string that represents the name of the group, and the "Choices" key is an array of strings that represents the choices in the group.
        
    -ChoiceLabelProperty <String>
        The name of the property to use as the label for each choice. If this parameter is not specified, the choices are displayed as strings.
        
    -Color <Color>
        The color of the selected choices. The default value is the accent color of the script.
        
    -PageSize <Int32>
        The number of choices to display per page. The default value is 10.
        
    -TimeoutSeconds <Int32>
        
    -AllowEmpty [<SwitchParameter>]
        Allow the multi-selection to be submitted without any options chosen.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates a multi-selection prompt with grouped choices.
    $selected = Read-SpectreMultiSelectionGrouped -Message "Select your favorite colors" -PageSize 8 -Choices @(
        @{
            Name = "Primary Colors"
            Choices = @("Red", "Blue", "Yellow")
        },
        @{
            Name = "Secondary Colors"
            Choices = @("Green", "Orange", "Purple")
        }
    )
    # Type "↓", "<space>", "↓", "↓", "↓", "<space>", "↲" to choose red and all secondary colors
    Write-SpectreHost "Your favourite colors are $($selected -join ', ')"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Read-SpectreMultiSelectionGrouped -Examples"
    For more information, type: "Get-Help Read-SpectreMultiSelectionGrouped -Detailed"
    For technical information, type: "Get-Help Read-SpectreMultiSelectionGrouped -Full"



```

## Read-SpectrePause

```powershell

NAME
    Read-SpectrePause
    
SYNOPSIS
    Pauses the script execution and waits for user input to continue.
    
    
SYNTAX
    Read-SpectrePause [[-Message] <String>] [-AnyKey] [-NoNewline] [<CommonParameters>]
    
    
DESCRIPTION
    The Read-SpectrePause function pauses the script execution and waits for user input to continue. It displays a message prompting the user to press the enter key to continue. If the end of the console window is reached, the function clears the message and moves the cursor up to the previous line.
    

PARAMETERS
    -Message <String>
        The message to display to the user. The default message is "[default value color]Press [accent color]enter[/] to continue[/]".
        
    -AnyKey [<SwitchParameter>]
        
    -NoNewline [<SwitchParameter>]
        Indicates whether to write a newline character before displaying the message. By default, a newline character is written.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to use the Read-SpectrePause function.
    Read-SpectrePause -Message "Press the [red]enter[/] key to continue, when you press it this message will disappear..."
    # Type "↲" to dismiss the message
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > # **Example 2**  
    # This example demonstrates how to use the Read-SpectrePause function with the AnyKey parameter.
    Read-SpectrePause -Message "Press the [red]ANY[/] key to continue, when you press it this message will disappear..." -AnyKey
    # Type "x" to dismiss the message
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Read-SpectrePause -Examples"
    For more information, type: "Get-Help Read-SpectrePause -Detailed"
    For technical information, type: "Get-Help Read-SpectrePause -Full"



```

## Read-SpectreSelection

```powershell

NAME
    Read-SpectreSelection
    
SYNOPSIS
    Displays a selection prompt using Spectre Console.
    
    
SYNTAX
    Read-SpectreSelection [[-Message] <String>] [-Choices] <Array> [[-ChoiceLabelProperty] <String>] [[-Color] <Color>] [[-PageSize] <Int32>] [-EnableSearch] [[-TimeoutSeconds] <Int32>] [[-SearchHighlightColor] <Color>] [<CommonParameters>]
    
    
DESCRIPTION
    This function displays a selection prompt using Spectre Console. The user can select an option from the list of choices provided. The function returns the selected option.  
    With the `-EnableSearch` switch, the user can search for choices in the selection prompt by typing the characters instead of just typing up and down arrows.
    

PARAMETERS
    -Message <String>
        The title of the selection prompt.
        
    -Choices <Array>
        The list of choices to display in the selection prompt. ChoiceLabelProperty is required if the choices are complex objects rather than an array of strings.
        
    -ChoiceLabelProperty <String>
        If the object is complex then the property of the choice object to use as the label in the selection prompt is required.
        
    -Color <Color>
        The color of the selected option in the selection prompt.
        
    -PageSize <Int32>
        The number of choices to display per page in the selection prompt.
        
    -EnableSearch [<SwitchParameter>]
        If this switch is present, the user can search for choices in the selection prompt by typing the characters instead of just typing up and down arrows.
        
    -TimeoutSeconds <Int32>
        
    -SearchHighlightColor <Color>
        The color of the search highlight in the selection prompt. Defaults to a slightly brighter version of the accent color.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates a selection prompt with a custom title and choices.
    $color = Read-SpectreSelection -Message "Select your favorite color" -Choices @("Red", "Green", "Blue") -Color "Green"
    # Type "↓", "↓", "↓", "↓", "↲" to wrap around the list and choose green
    Write-SpectreHost "Your chosen color is '$color'"
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > # **Example 2**  
    # This example demonstrates a selection prompt with a custom title and choices, and search enabled.
    $color = Read-SpectreSelection -Message "Select your favorite color" -Choices @("Blue", "Bluer", "Blue-est") -EnableSearch
    # Type "b", "l", "u", "e", "r", "↲" to choose "Bluer"
    Write-SpectreHost "Your chosen color is '$color'"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Read-SpectreSelection -Examples"
    For more information, type: "Get-Help Read-SpectreSelection -Detailed"
    For technical information, type: "Get-Help Read-SpectreSelection -Full"



```

## Read-SpectreText

```powershell

NAME
    Read-SpectreText
    
SYNOPSIS
    Prompts the user with a question and returns the user's input.
    
    
SYNTAX
    Read-SpectreText [-Message] <String> [[-DefaultAnswer] <String>] [[-AnswerColor] <Color>] [-AllowEmpty] [[-TimeoutSeconds] <Int32>] [[-Choices] <String[]>] [<CommonParameters>]
    
    
DESCRIPTION
    This function uses Spectre Console to prompt the user with a question and returns the user's input.
    :::caution
    I would advise against this and instead use `Read-Host` because the Spectre Console prompt doesn't have access to the PowerShell session history.  
    Without session history you can't use the up and down arrow keys to navigate through your previous commands.
    This text entry also doesn't allow you to use arrow keys to go back and forwards through the text you're entering.
    :::
    

PARAMETERS
    -Message <String>
        The question to prompt the user with.
        
    -DefaultAnswer <String>
        The default answer if the user does not provide any input.
        
    -AnswerColor <Color>
        The color of the user's answer input. The default behaviour uses the standard terminal text color.
        
    -AllowEmpty [<SwitchParameter>]
        If specified, the user can provide an empty answer.
        
    -TimeoutSeconds <Int32>
        
    -Choices <String[]>
        An array of choices that the user can choose from. If specified, the user will be prompted with a list of choices to choose from, with validation.
        With autocomplete and can tab through the choices.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates a simple text prompt with a default answer.
    $name = Read-SpectreText -Message "What's your name?" -DefaultAnswer "Prefer not to say"
    # Type "↲" to provide no answer
    Write-SpectreHost "Your name is '$name'"
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > # **Example 2**  
    # This example demonstrates a simple text prompt with a default answer and a color.
    $favouriteColor = Read-SpectreText -Message "What's your favorite color?" -DefaultAnswer "pink"
    # Type "orange", "↲" to enter your favourite color
    Write-SpectreHost "Your favourite color is '$favouriteColor'"
    
    
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS > # **Example 3**  
    # This example demonstrates a simple text prompt with a default answer, a color, and a list of choices.
    $favouriteColor = Read-SpectreText -Message "What's your favorite color?" -AnswerColor "Cyan1" -Choices "Black", "Green", "Magenta", "I'll never tell!"
    # Type "orange", "↲", "magenta", "↲" to enter text that must match a choice in the choices list, orange will be rejected, magenta will be accepted
    Write-SpectreHost "Your favourite color is '$favouriteColor'"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Read-SpectreText -Examples"
    For more information, type: "Get-Help Read-SpectreText -Detailed"
    For technical information, type: "Get-Help Read-SpectreText -Full"



```

## Set-SpectreColors

```powershell

NAME
    Set-SpectreColors
    
SYNOPSIS
    Sets the accent color and default value color for Spectre Console.
    
    
SYNTAX
    Set-SpectreColors [[-AccentColor] <Color>] [[-DefaultValueColor] <Color>] [[-DefaultTableHeaderColor] <Color>] [[-DefaultTableTextColor] <Color>] [<CommonParameters>]
    
    
DESCRIPTION
    This function sets the accent color and default value color for Spectre Console. The accent color is used for highlighting important information, while the default value color is used for displaying default values.
    

PARAMETERS
    -AccentColor <Color>
        The accent color to set. Must be a valid Spectre Console color name. Defaults to "Blue".
        
    -DefaultValueColor <Color>
        The default value color to set. Must be a valid Spectre Console color name. Defaults to "Grey".
        
    -DefaultTableHeaderColor <Color>
        The default table header color to set. Must be a valid Spectre Console color name. Defaults to "Default" which will be the standard console foreground color.
        
    -DefaultTableTextColor <Color>
        The default table text color to set. Must be a valid Spectre Console color name. Defaults to "Default" which will be the standard console foreground color.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to set the accent color and default value color for Spectre Console.
    Write-SpectreRule "This is a default rule"
    Set-SpectreColors -AccentColor "Turquoise2"
    Write-SpectreRule "This is a Turquoise2 rule"
    Write-SpectreRule "This is a rule with a specified color" -Color "Yellow"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Set-SpectreColors -Examples"
    For more information, type: "Get-Help Set-SpectreColors -Detailed"
    For technical information, type: "Get-Help Set-SpectreColors -Full"



```

## Wait-SpectreJobs

```powershell

NAME
    Wait-SpectreJobs
    
SYNOPSIS
    Waits for Spectre jobs to complete.
    
    
SYNTAX
    Wait-SpectreJobs [-Context] <Object> [-Jobs] <Array> [[-TimeoutSeconds] <Int32>] [[-EstimatedDurationSeconds] <Int32>] [<CommonParameters>]
    
    
DESCRIPTION
    This function waits for Spectre jobs to complete by checking the progress of each job and updating the corresponding task value.
    Adapted from https://key2consulting.com/powershell-how-to-display-job-progress/
    :::note
    This is only used inside `Invoke-SpectreCommandWithProgress` where the Spectre ProgressContext object is exposed.
    :::
    

PARAMETERS
    -Context <Object>
        The Spectre progress context object.
        [https://spectreconsole.net/api/spectre.console/progresscontext/](https://spectreconsole.net/api/spectre.console/progresscontext/)
        
    -Jobs <Array>
        An array of Spectre jobs which are decorated PowerShell jobs.
        
    -TimeoutSeconds <Int32>
        The maximum number of seconds to wait for the jobs to complete. Defaults to 60 seconds.
        
    -EstimatedDurationSeconds <Int32>
        The estimated duration of the jobs in seconds. This is used to calculate the progress of the jobs if the job progress is not available.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to add two jobs to a context and wait for them to complete.
    
    Invoke-SpectreCommandWithProgress -ScriptBlock {
        param (
            $Context
        )
        $jobs = @()
        $jobs += Add-SpectreJob -Context $Context -JobName "job 1" -Job (Start-Job { Start-Sleep -Seconds 2 })
        $jobs += Add-SpectreJob -Context $Context -JobName "job 2" -Job (Start-Job { Start-Sleep -Seconds 4 })
        Wait-SpectreJobs -Context $Context -Jobs $jobs
    }
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Wait-SpectreJobs -Examples"
    For more information, type: "Get-Help Wait-SpectreJobs -Detailed"
    For technical information, type: "Get-Help Wait-SpectreJobs -Full"



```

## Write-SpectreFigletText

```powershell

NAME
    Write-SpectreFigletText
    
SYNOPSIS
    Writes a Spectre Console Figlet text to the console.
    
    
SYNTAX
    Write-SpectreFigletText [[-Text] <String>] [[-Alignment] <String>] [[-Color] <Color>] [[-FigletFontPath] <String>] [-PassThru] [<CommonParameters>]
    
    
DESCRIPTION
    This function writes a Spectre Console Figlet text to the console. The text can be aligned to the left, right, or center, and can be displayed in a specified color.
    

PARAMETERS
    -Text <String>
        The text to display in the Figlet format.
        
    -Alignment <String>
        The alignment of the text. The default value is "Left".
        
    -Color <Color>
        The color of the text. The default value is the accent color of the script.
        
    -FigletFontPath <String>
        The path to the Figlet font file to use. If this parameter is not specified, the default built-in Figlet font is used.
        The figlet font format is usually *.flf, see https://spectreconsole.net/widgets/figlet for more.
        
    -PassThru [<SwitchParameter>]
        Returns the Spectre Figlet text object instead of writing it to the console.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to write Figlet text to the console.
    Write-SpectreFigletText -Text "Hello Spectre!" -Alignment "Center" -Color "Red"
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > # **Example 2**  
    # This example demonstrates how to write Figlet text to the console using a custom Figlet font.
    Write-SpectreFigletText -Text "Whoa?!" -FigletFontPath "..\PwshSpectreConsole.Docs\src\assets\3d.flf"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Write-SpectreFigletText -Examples"
    For more information, type: "Get-Help Write-SpectreFigletText -Detailed"
    For technical information, type: "Get-Help Write-SpectreFigletText -Full"



```

## Write-SpectreHost

```powershell

NAME
    Write-SpectreHost
    
SYNOPSIS
    Writes a message to the console using Spectre Console markup.
    
    
SYNTAX
    Write-SpectreHost [-Message] <Object> [-NoNewline] [-PassThru] [[-Justify] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    The Write-SpectreHost function writes a message to the console using Spectre Console. It supports ANSI markup and can optionally append a newline character to the end of the message.
    The markup language is defined at [https://spectreconsole.net/markup](https://spectreconsole.net/markup)
    Supported emoji are defined at [https://spectreconsole.net/appendix/emojis](https://spectreconsole.net/appendix/emojis)
    

PARAMETERS
    -Message <Object>
        The message to write to the console.
        
    -NoNewline [<SwitchParameter>]
        If specified, the message will not be followed by a newline character.
        
    -PassThru [<SwitchParameter>]
        
    -Justify <String>
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to write a message to the console using Spectre Console markup.
    Write-SpectreHost -Message "Hello, [blue underline]world[/]! :call_me_hand:"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Write-SpectreHost -Examples"
    For more information, type: "Get-Help Write-SpectreHost -Detailed"
    For technical information, type: "Get-Help Write-SpectreHost -Full"



```

## Write-SpectreRule

```powershell

NAME
    Write-SpectreRule
    
SYNOPSIS
    Writes a Spectre horizontal-rule to the console.
    
    
SYNTAX
    Write-SpectreRule [[-Title] <String>] [[-Alignment] <String>] [[-Color] <Color>] [[-LineColor] <Color>] [-PassThru] [<CommonParameters>]
    
    
DESCRIPTION
    The Write-SpectreRule function writes a Spectre horizontal-rule to the console with the specified title, alignment, and color.
    

PARAMETERS
    -Title <String>
        The title of the rule.
        
    -Alignment <String>
        The alignment of the text in the rule. The default value is Left.
        
    -Color <Color>
        The color of the rule. The default value is the accent color of the script.
        
    -LineColor <Color>
        
    -PassThru [<SwitchParameter>]
        Returns the Spectre Rule object instead of writing it to the console.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to write a rule to the console.
    Write-SpectreRule -Title "My Rule" -Alignment Center -Color Yellow
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Write-SpectreRule -Examples"
    For more information, type: "Get-Help Write-SpectreRule -Detailed"
    For technical information, type: "Get-Help Write-SpectreRule -Full"



```

## Read-SpectreConfirm

```powershell

NAME
    Read-SpectreConfirm
    
SYNOPSIS
    Displays a simple confirmation prompt with the option of selecting yes or no and returns a boolean representing the answer.
    
    
SYNTAX
    Read-SpectreConfirm [-Message] <String> [[-DefaultAnswer] <String>] [[-ConfirmSuccess] <String>] [[-ConfirmFailure] <String>] [[-TimeoutSeconds] <Int32>] [[-Color] <Color>] [<CommonParameters>]
    
    
DESCRIPTION
    Displays a simple confirmation prompt with the option of selecting yes or no. Additional options are provided to display either a success or failure response message in addition to the boolean return value.
    

PARAMETERS
    -Message <String>
        The prompt to display to the user. The default value is "Do you like cute animals?".
        
    -DefaultAnswer <String>
        The default answer to the prompt if the user just presses enter. The default value is "y".
        
    -ConfirmSuccess <String>
        The text and markup to display if the user chooses yes. If left undefined, nothing will display.
        
    -ConfirmFailure <String>
        The text and markup to display if the user chooses no. If left undefined, nothing will display.
        
    -TimeoutSeconds <Int32>
        
    -Color <Color>
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates a simple confirmation prompt with a success message.
    $answer = Read-SpectreConfirm -Message "Would you like to continue the preview installation of [#7693FF]PowerShell 7?[/]" `
                                  -ConfirmSuccess "Woohoo! The internet awaits your elite development contributions." `
                                  -ConfirmFailure "What kind of monster are you? How could you do this?"
    # Type "y", "↲" to accept the prompt
    Write-Host "Your answer was '$answer'"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Read-SpectreConfirm -Examples"
    For more information, type: "Get-Help Read-SpectreConfirm -Detailed"
    For technical information, type: "Get-Help Read-SpectreConfirm -Full"



```

## New-SpectreChartItem

```powershell

NAME
    New-SpectreChartItem
    
SYNOPSIS
    Creates a new SpectreChartItem object.
    
    
SYNTAX
    New-SpectreChartItem [-Label] <String> [-Value] <Double> [-Color] <Color> [<CommonParameters>]
    
    
DESCRIPTION
    The New-SpectreChartItem function creates a new SpectreChartItem object with the specified label, value, and color for use in Format-SpectreBarChart and Format-SpectreBreakdownChart.
    

PARAMETERS
    -Label <String>
        The label for the chart item.
        
    -Value <Double>
        The value for the chart item.
        
    -Color <Color>
        The color for the chart item. Must be a valid Spectre color as name, hex or a Spectre.Console.Color object.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to use SpectreChartItems to create a breakdown chart.
    $data = @()
    $data += New-SpectreChartItem -Label "Sales" -Value 1000 -Color "green"
    $data += New-SpectreChartItem -Label "Expenses" -Value 500 -Color "#ff0000"
    $data += New-SpectreChartItem -Label "Profit" -Value 420 -Color ([Spectre.Console.Color]::Blue)
    Write-SpectreHost "`nGenerate a bar chart`n"
    $data | Format-SpectreBarChart
    Write-SpectreHost "`nGenerate a breakdown chart`n"
    $data | Format-SpectreBreakdownChart
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help New-SpectreChartItem -Examples"
    For more information, type: "Get-Help New-SpectreChartItem -Detailed"
    For technical information, type: "Get-Help New-SpectreChartItem -Full"



```

## Invoke-SpectreScriptBlockQuietly

```powershell

NAME
    Invoke-SpectreScriptBlockQuietly
    
SYNOPSIS
    This is a test function for invoking a script block in a background job inside Invoke-SpectreCommandWithProgress to help with https://github.com/ShaunLawrie/PwshSpectreConsole/issues/7  
    Some commands cause output that interferes with the progress bar, this function is an attempt to suppress that output when all other attempts have failed.
    
    
SYNTAX
    Invoke-SpectreScriptBlockQuietly [[-Command] <ScriptBlock>] [[-Level] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    This function invokes a script block in a background job and returns the output. It also provides an option to suppress the output even more if there is garbage being printed to stderr if using Level = Quieter.
    

PARAMETERS
    -Command <ScriptBlock>
        The script block to be invoked.
        
    -Level <String>
        Suppresses the output by varying amounts.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to use this function to suppress all output from a script block so it doesn't break the progress bar.
    
    $result = Invoke-SpectreCommandWithProgress {
        param (
            $Context
        )
        $task1 = $Context.AddTask("Starting a process that generates noise")
        $task1.Increment(50)
        $value = Invoke-SpectreScriptBlockQuietly -Level Quiet -Command {
            Write-Output "Things..."
            Write-Output "And stuff..."
            Write-Error "This is an error"
            Start-Sleep -Seconds 3
            Write-Output "But it shouldn't break progress bar rendering"
        }
        $task1.Increment(50)
        return $value
    }
    Write-SpectreHost "Result: $result"
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Invoke-SpectreScriptBlockQuietly -Examples"
    For more information, type: "Get-Help Invoke-SpectreScriptBlockQuietly -Detailed"
    For technical information, type: "Get-Help Invoke-SpectreScriptBlockQuietly -Full"



```

## Format-SpectreJson

```powershell

NAME
    Format-SpectreJson
    
SYNOPSIS
    Formats an array of objects into a Spectre Console Json.
    
    
SYNTAX
    Format-SpectreJson [-Data] <Object> [[-Depth] <Int32>] [-NoBorder] [[-Border] <String>] [[-Color] <String>] [[-Title] <String>] [[-Width] <Int32>] [[-Height] <Int32>] [[-JsonStyle] <Hashtable>] [<CommonParameters>]
    
    
DESCRIPTION
    This function takes an objects and converts them into syntax highlighted Json using the Spectre Console Json Library.  
    Thanks to [trackd](https://github.com/trackd) for adding this!  
    See https://spectreconsole.net/widgets/json for more information.
    

PARAMETERS
    -Data <Object>
        The array of objects to be formatted into Json.
        
    -Depth <Int32>
        The maximum depth of the Json. Default is defined by the version of powershell.
        
    -NoBorder [<SwitchParameter>]
        :::caution
        This parameter is deprecated and will be removed in the future. It takes no effect from version 2.0.
        The json output already has no border.
        :::
        
    -Border <String>
        :::caution
        This parameter is deprecated and will be removed in the future. It takes no effect from version 2.0.
        To add a border wrap this object in a panel, use `$data | Format-SpectreJson | Format-SpectrePanel`.
        :::
        
    -Color <String>
        :::caution
        This parameter is deprecated and will be removed in the future. It takes no effect from version 2.0.
        To add a border with a color use `$data | Format-SpectreJson | Format-SpectrePanel -Color "color"`.
        :::
        
    -Title <String>
        :::caution
        This parameter is deprecated and will be removed in the future. It takes no effect from version 2.0.
        To add a border with a title to the json data, use `$data | Format-SpectreJson | Format-SpectrePanel -Header "title"`.
        :::
        
    -Width <Int32>
        :::caution
        This parameter is deprecated and will be removed in the future. It takes no effect from version 2.0.
        To add a border with a width, use `$data | Format-SpectreJson | Format-SpectrePanel -Width 20`.
        :::
        
    -Height <Int32>
        :::caution
        This parameter is deprecated and will be removed in the future. It takes no effect from version 2.0.
        To add a border with a width, use `$data | Format-SpectreJson | Format-SpectrePanel -Height 20`.
        :::
        
    -JsonStyle <Hashtable>
        A hashtable of Spectre Console color names and values to style the Json output.
        e.g.
        ```
        @{
            MemberStyle    = "Yellow"
            BracesStyle    = "Red"
            BracketsStyle  = "Orange1"
            ColonStyle     = "White"
            CommaStyle     = "White"
            StringStyle    = "White"
            NumberStyle    = "Red"
            BooleanStyle   = "LightSkyBlue1"
            NullStyle      = "Gray"
        }
        ```
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to format an array of objects into a Spectre Console Json object with syntax highlighting.
    $data = @(
        [pscustomobject]@{
            Name = "John"
            Age = 25
            City = "New York"
            IsEmployed = $true
            Salary = 10
            Hobbies = @("Reading", "Swimming")
            Address = @{
                Street = "123 Main St"
                ZipCode = $null
            }
        }
    )
    Format-SpectreJson -Data $data
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > # **Example 2**  
    # This example demonstrates how to display json string data using Format-SpectreJson.
    $jsonString = @{
        Name = 'Alice'
        Age = 30
        Skills = @('PowerShell', 'Spectre.Console')
    } | ConvertTo-Json
    
    # Display the JSON string using Format-SpectreJson
    $jsonString | Format-SpectreJson
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS > # **Example 3**  
    # This example demonstrates how to display the contents of one or more JSON files directly using Format-SpectreJson.
    
    # Create temporary JSON files for demonstration, use a random execution ID to avoid reading random json files from the temp directory.
    $executionId = [guid]::NewGuid().ToString()
    $tempJson1 = (New-TemporaryFile).FullName -replace '.tmp$', ".$executionId.json"
    $tempJson2 = (New-TemporaryFile).FullName -replace '.tmp$', ".$executionId.json"
    
    @{
        Name = 'Alice'
        Age = 30
        Skills = @('PowerShell', 'Spectre.Console')
    } | ConvertTo-Json | Set-Content -Path $tempJson1
    
    @{
        Name = 'Bob'
        Age = 35
        Skills = @('C#', 'JavaScript')
    } | ConvertTo-Json | Set-Content -Path $tempJson2
    
    # Display the JSON files directly using Get-ChildItem and Format-SpectreJson
    $parent = Split-Path $tempJson1 -Parent
    Get-ChildItem $parent -Filter "*.$executionId.json" | Format-SpectreJson
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Format-SpectreJson -Examples"
    For more information, type: "Get-Help Format-SpectreJson -Detailed"
    For technical information, type: "Get-Help Format-SpectreJson -Full"



```

## Write-SpectreCalendar

```powershell

NAME
    Write-SpectreCalendar
    
SYNOPSIS
    Writes a Spectre Console Calendar text to the console.
    
    
SYNTAX
    Write-SpectreCalendar [[-Date] <DateTime>] [[-Alignment] <String>] [[-Color] <Color>] [[-Border] <String>] [[-Culture] <CultureInfo>] [[-Events] <Hashtable>] [-HideHeader] [-PassThru] [<CommonParameters>]
    
    
DESCRIPTION
    Writes a Spectre Console Calendar text to the console.
    

PARAMETERS
    -Date <DateTime>
        The date to display the calendar for.
        
    -Alignment <String>
        The alignment of the calendar.
        
    -Color <Color>
        The color of the calendar.
        
    -Border <String>
        The border of the calendar.
        
    -Culture <CultureInfo>
        The culture of the calendar.
        
    -Events <Hashtable>
        The events to highlight on the calendar.
        Takes a hashtable with the date as the key and the event as the value.
        
    -HideHeader [<SwitchParameter>]
        Hides the header of the calendar. (Date)
        
    -PassThru [<SwitchParameter>]
        Returns the Spectre Calendar object instead of writing it to the console.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to write a calendar to the console.
    Write-SpectreCalendar -Date 2024-07-01 -Events @{'2024-07-10' = 'Beach time!'; '2024-07-20' = 'Barbecue' }
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > # **Example 2**  
    # This example demonstrates how to write a calendar to the console with some event details.
    $events = @{
        '2024-01-10' = 'Hello World!'
        '2024-01-20' = 'Hello Universe!'
    }
    Write-SpectreCalendar -Date 2024-01-01 -Events $events
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Write-SpectreCalendar -Examples"
    For more information, type: "Get-Help Write-SpectreCalendar -Detailed"
    For technical information, type: "Get-Help Write-SpectreCalendar -Full"



```

## Format-SpectreColumns

```powershell

NAME
    Format-SpectreColumns
    
SYNOPSIS
    Renders a collection of renderables in columns to the console.
    
    
SYNTAX
    Format-SpectreColumns [-Data] <Object> [[-Padding] <Int32>] [-Expand] [<CommonParameters>]
    
    
DESCRIPTION
    This function creates a spectre columns widget that renders a collection of renderables in autosized columns to the console.  
    Columns can contain renderable items.  
    See https://spectreconsole.net/widgets/columns for more information.
    

PARAMETERS
    -Data <Object>
        An array of objects containing the data to be displayed in the columns.
        
    -Padding <Int32>
        The padding to apply to the columns.
        
    -Expand [<SwitchParameter>]
        A switch to expand the columns to fill the available space.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to display a collection of strings in columns.
    @("lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit,", "sed", "do", "eiusmod",
      "tempor", "incididunt", "ut", "labore", "et", "dolore", "magna", "aliqua.", "Ut", "enim", "ad", "minim",
      "veniam,", "quis", "nostrud", "exercitation", "ullamco", "laboris", "nisi", "ut", "aliquip", "ex", "ea",
      "commodo", "consequat", "duis", "aute", "irure", "dolor", "in", "reprehenderit", "in", "voluptate", "velit",
      "esse", "cillum", "dolore", "eu", "fugiat", "nulla", "pariatur", "excepteur", "sint", "occaecat",
      "cupidatat", "non", "proident", "sunt", "in", "culpa") | Foreach-Object { $_ } | Format-SpectreColumns
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > # **Example 2**  
    # This example demonstrates how to display a collection of panels that are expanded but with normal sized columns.
    @("left", "middle", "right") | Foreach-Object { $_ | Format-SpectrePanel -Expand } | Format-SpectreColumns
    
    
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS > # **Example 3**  
    # This example demonstrates how to display a collection of panels that are expanded and with expanded columns so it takes up the console width.
    @("left", "middle", "right") | Foreach-Object { $_ | Format-SpectrePanel -Expand } | Format-SpectreColumns -Expand
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Format-SpectreColumns -Examples"
    For more information, type: "Get-Help Format-SpectreColumns -Detailed"
    For technical information, type: "Get-Help Format-SpectreColumns -Full"



```

## Format-SpectreRows

```powershell

NAME
    Format-SpectreRows
    
SYNOPSIS
    Renders a collection of renderables in rows to the console.
    
    
SYNTAX
    Format-SpectreRows [-Data] <Object> [-Expand] [<CommonParameters>]
    
    
DESCRIPTION
    This function creates a spectre rows widget that renders a collection of renderables in autosized rows to the console.  
    Rows can contain renderable items.  
    See https://spectreconsole.net/widgets/rows for more information.
    

PARAMETERS
    -Data <Object>
        An array of renderable items containing the data to be displayed in the rows.
        
    -Expand [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to display a collection of strings in rows.
    @("top", "middle", "bottom") | Format-SpectreRows
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > # **Example 2**  
    # This example demonstrates how to display a collection of renderable items as rows inside a panel, without wrapping the renderables in rows you cannot display them in a panel because a panel only accepts a single item.
    $rows = @()
    $bigText = "lorem ipsum dolor sit amet consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur excepteur sint occaecat cupidatat non proident sunt in culpa"
    for ($i = 0; $i -lt 12; $i+= 4) {
        $rows += $bigText | Format-SpectrePadded -Left $i -Top 0 -Bottom 0 -Right 0
    }
    $rows | Format-SpectreRows | Format-SpectrePanel
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Format-SpectreRows -Examples"
    For more information, type: "Get-Help Format-SpectreRows -Detailed"
    For technical information, type: "Get-Help Format-SpectreRows -Full"



```

## Format-SpectrePadded

```powershell

NAME
    Format-SpectrePadded
    
SYNOPSIS
    Wraps a Spectre Console renderable item in padding.
    
    
SYNTAX
    Format-SpectrePadded -Data <Object> -Padding <Int32> [<CommonParameters>]
    
    Format-SpectrePadded -Data <Object> -Top <Int32> -Left <Int32> -Bottom <Int32> -Right <Int32> [<CommonParameters>]
    
    Format-SpectrePadded -Data <Object> -Expand [<CommonParameters>]
    
    
DESCRIPTION
    This function that wraps a spectre renderable item in padding.  
    See https://spectreconsole.net/widgets/padder for more information.
    

PARAMETERS
    -Data <Object>
        A renderable item to wrap in padding.
        
    -Padding <Int32>
        
    -Top <Int32>
        
    -Left <Int32>
        
    -Bottom <Int32>
        
    -Right <Int32>
        
    -Expand [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to pad an item with a padding of 1 on all sides
    "Item to pad" | Format-SpectrePadded -Padding 1 | Format-SpectrePanel
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > # **Example 2**  
    # This example demonstrates how to pad an item with a padding of 4 on all sides
    "Item to pad" | Format-SpectrePadded -Padding 4  | Format-SpectrePanel
    
    
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS > # **Example 3**  
    # This example demonstrates how to pad an item with different padding on each side.
    "Item to pad" | Format-SpectrePadded -Top 4 -Left 10 -Right 1 -Bottom 1 | Format-SpectrePanel
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Format-SpectrePadded -Examples"
    For more information, type: "Get-Help Format-SpectrePadded -Detailed"
    For technical information, type: "Get-Help Format-SpectrePadded -Full"



```

## Format-SpectreGrid

```powershell

NAME
    Format-SpectreGrid
    
SYNOPSIS
    Formats data into a Spectre Console grid.
    
    
SYNTAX
    Format-SpectreGrid [-Data] <Object> [[-Width] <Int32>] [[-Padding] <Int32>] [<CommonParameters>]
    
    
DESCRIPTION
    Formats data into a Spectre Console grid. The grid can be used to display data in a tabular format but it's not as flexible as the Layout widget.  
    See https://spectreconsole.net/widgets/grid for more information.
    

PARAMETERS
    -Data <Object>
        The data to be displayed in the grid. This can be a list of lists or a list of `New-SpectreGridRow` objects.
        
    -Width <Int32>
        The width of the grid. If not specified, the grid width will be automatic.
        
    -Padding <Int32>
        The padding to apply to the grid items. The default is 1.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to display a grid of rows using the Spectre Console module with a list of lists.
    Format-SpectreGrid -Data @("hello", "I", "am"), @("a", "grid", "of"), @("rows", "using", "spectre")
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > # **Example 2**  
    # This example demonstrates how to display a grid of rows using the Spectre Console module with a list of `New-SpectreGridRow` objects.
    # The `New-SpectreGridRow` function is used to create the rows when you want to avoid array collapsing in PowerShell turning your rows into a single array of columns.
    $rows = 4
    $cols = 6
    
    $gridRows = @()
    for ($row = 1; $row -le $rows; $row++) {
        $columns = @()
        for ($col = 1; $col -le $cols; $col++) {
            $columns += "Row $row, Col $col" | Format-SpectrePanel
        }
        $gridRows += New-SpectreGridRow $columns
    }
    
    $gridRows | Format-SpectreGrid
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Format-SpectreGrid -Examples"
    For more information, type: "Get-Help Format-SpectreGrid -Detailed"
    For technical information, type: "Get-Help Format-SpectreGrid -Full"



```

## New-SpectreGridRow

```powershell

NAME
    New-SpectreGridRow
    
SYNOPSIS
    Creates a new SpectreGridRow object.
    
    
SYNTAX
    New-SpectreGridRow [-Data] <Array> [<CommonParameters>]
    
    
DESCRIPTION
    Creates a new SpectreGridRow object with the specified columns for use in Format-SpectreGrid. PowerShell collapses nested arrays, so you must use this function to create an array of SpectreGridRow objects to provide to Format-SpectreGrid.
    

PARAMETERS
    -Data <Array>
        An array of renderable items containing the data to be displayed in the columns of this row.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to create a grid with two rows and three columns.
    $columns = @()
    $columns += "Column 1" | Format-SpectrePanel
    $columns += "Column 2" | Format-SpectrePanel
    $columns += "Column 3" | Format-SpectrePanel
    
    $rows = @(
    (New-SpectreGridRow -Data $columns),
    (New-SpectreGridRow -Data $columns)
    )
    
    $rows | Format-SpectreGrid
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help New-SpectreGridRow -Examples"
    For more information, type: "Get-Help New-SpectreGridRow -Detailed"
    For technical information, type: "Get-Help New-SpectreGridRow -Full"



```

## Format-SpectreTextPath

```powershell

NAME
    Format-SpectreTextPath
    
SYNOPSIS
    Formats a path into a Spectre Console Path which supports highlighting and truncating.
    
    
SYNTAX
    Format-SpectreTextPath [-Path] <String> [[-Alignment] <String>] [[-PathStyle] <Hashtable>] [<CommonParameters>]
    
    
DESCRIPTION
    Formats a path into a Spectre Console Path which supports highlighting and truncating.  
    See https://spectreconsole.net/widgets/text-path for more information.
    

PARAMETERS
    -Path <String>
        The directory/file path to format
        
    -Alignment <String>
        The alignment of the path. Defaults to "Left".
        
    -PathStyle <Hashtable>
        A hashtable of Spectre Console colors or color names to style the path output.
        e.g.
        ```
        @{
            RootColor      = [Spectre.Console.Color]::Cyan2
            SeparatorColor = [Spectre.Console.Color]::Aqua
            StemColor      = [Spectre.Console.Color]::Orange1
            LeafColor      = "HotPink"
        }
        ```
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to format a PowerShell path as a Spectre Console Path with syntax highlighting.
    Get-Location | Format-SpectreTextPath | Out-SpectreHost
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Format-SpectreTextPath -Examples"
    For more information, type: "Get-Help Format-SpectreTextPath -Detailed"
    For technical information, type: "Get-Help Format-SpectreTextPath -Full"



```

## New-SpectreLayout

```powershell

NAME
    New-SpectreLayout
    
SYNOPSIS
    Creates a new Spectre Layout object.
    
    
SYNTAX
    New-SpectreLayout [-Data <Object>] [-Ratio <Int32>] [-Name <String>] [-MinimumSize <Int32>] [<CommonParameters>]
    
    New-SpectreLayout -Columns <Array> [-Ratio <Int32>] [-Name <String>] [-MinimumSize <Int32>] [<CommonParameters>]
    
    New-SpectreLayout -Rows <Array> [-Ratio <Int32>] [-Name <String>] [-MinimumSize <Int32>] [<CommonParameters>]
    
    
DESCRIPTION
    The New-SpectreLayout function creates a new Spectre Layout object with the specified data, columns, or rows. This function is used to create a layout object that can be used to split the console into multiple sections.  
    You can only have either rows OR columns in a layout and can compose layouts of layouts to create complex layouts.  
    
    :::note  
    If you need to know the size of the layout panels you can use the [`Get-SpectreLayoutSizes`](https://pwshspectreconsole.com/reference/measurement/get-spectrelayoutsizes/) function.  
    :::  
    
    See https://spectreconsole.net/widgets/layout for more information.
    

PARAMETERS
    -Data <Object>
        The data to be displayed in the layout.
        
    -Columns <Array>
        The columns to be displayed in the layout.
        
    -Rows <Array>
        The rows to be displayed in the layout.
        
    -Ratio <Int32>
        The ratio of the layout, when composing layouts of layouts you can use a higher ratio in one layout to make it larger than the other layouts.
        
    -Name <String>
        The name of the layout, this is used when you want to access one of the layouts in a nested layout to update the contents.  
        e.g. in the example below to update the contents of row1 you would use `$root = $root["row1"].Update(("hello row 1 again" | Format-SpectrePanel))`
        
    -MinimumSize <Int32>
        The minimum size of the layout, this can be used to ensure a layout is at least the minimum width.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to create a layout with a calendar, a list of files, and a panel with a calendar aligned to the middle and center.
    $calendar = Write-SpectreCalendar -Date (Get-Date) -PassThru
    $files = Get-ChildItem | Select-Object Name, LastWriteTime -First 3 | Format-SpectreTable | Format-SpectreAligned -HorizontalAlignment Right -VerticalAlignment Bottom
    
    $panel1 = $files | Format-SpectrePanel -Header "panel 1 (align bottom right)" -Expand -Color Green
    $panel2 = "hello row 2" | Format-SpectrePanel -Header "panel 2" -Expand -Color Blue
    $panel3 = $calendar | Format-SpectreAligned | Format-SpectrePanel -Header "panel 3 (align middle center)" -Expand -Color Yellow
    
    $row1 = New-SpectreLayout -Name "row1" -Data $panel1 -Ratio 1
    $row2 = New-SpectreLayout -Name "row2" -Columns @($panel2, $panel3) -Ratio 2
    $root = New-SpectreLayout -Name "root" -Rows @($row1, $row2)
    
    $root | Out-SpectreHost
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help New-SpectreLayout -Examples"
    For more information, type: "Get-Help New-SpectreLayout -Detailed"
    For technical information, type: "Get-Help New-SpectreLayout -Full"



```

## Format-SpectreAligned

```powershell

NAME
    Format-SpectreAligned
    
SYNOPSIS
    Wraps a renderable object in a Spectre Console Aligned object.
    
    
SYNTAX
    Format-SpectreAligned [-Data] <Object> [[-HorizontalAlignment] <String>] [[-VerticalAlignment] <String>] [<CommonParameters>]
    
    
DESCRIPTION
    This wraps a renderable object in a Spectre Console Aligned object. This allows you to align the object horizontally and vertically within a space. Aligned objects are always expanded so they take up all available horizontal space.
    

PARAMETERS
    -Data <Object>
        The renderable object to align.
        
    -HorizontalAlignment <String>
        The horizontal alignment of the object.
        
    -VerticalAlignment <String>
        The vertical alignment of the object.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to align a string to the right inside a panel.
    "hello right hand side" | Format-SpectreAligned -HorizontalAlignment Right -VerticalAlignment Middle | Format-SpectrePanel -Expand -Height 9
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Format-SpectreAligned -Examples"
    For more information, type: "Get-Help Format-SpectreAligned -Detailed"
    For technical information, type: "Get-Help Format-SpectreAligned -Full"



```

## Out-SpectreHost

```powershell

NAME
    Out-SpectreHost
    
SYNOPSIS
    Writes a spectre renderable to the console host.
    
    
SYNTAX
    Out-SpectreHost [-Data] <Object> [-CustomItemFormatter] [<CommonParameters>]
    
    
DESCRIPTION
    Out-SpectreHost writes a spectre renderable object to the console host.  
    This function is used to output spectre renderables to the console when you want to avoid the additional newlines that the PowerShell formatter adds.
    

PARAMETERS
    -Data <Object>
        The data to write to the console.
        
    -CustomItemFormatter [<SwitchParameter>]
        The default host customitem formatter has some restrictions, it needs to be one char less wide than when outputting to the standard console or it will wrap.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to write a spectre renderable object to the console host.
    $table = Get-ChildItem | Select-Object Name, Length, LastWriteTime | Format-SpectreTable
    $table | Out-SpectreHost
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Out-SpectreHost -Examples"
    For more information, type: "Get-Help Out-SpectreHost -Detailed"
    For technical information, type: "Get-Help Out-SpectreHost -Full"



```

## Add-SpectreTableRow

```powershell

NAME
    Add-SpectreTableRow
    
SYNOPSIS
    Adds a row to a Spectre Console table.
    
    
SYNTAX
    Add-SpectreTableRow [-Table] <Table> [[-Columns] <Array>] [<CommonParameters>]
    
    
DESCRIPTION
    Adds a row to a Spectre Console table. The number of columns in the row must match the number of columns in the table.
    

PARAMETERS
    -Table <Table>
        The table to which the row will be added.
        
    -Columns <Array>
        An array of renderable items containing the data to be displayed in the columns of this row.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to add a row to an existing Spectre Console table.
    $data = @(
        [pscustomobject]@{Name="John"; Age=25; City="New York"},
        [pscustomobject]@{Name="Jane"; Age=30; City="Los Angeles"}
    )
    $table = Format-SpectreTable -Data $data
    $table | Out-SpectreHost
    
    $table = Add-SpectreTableRow -Table $table -Columns "Shaun", 99, "Wellington"
    $table | Out-SpectreHost
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Add-SpectreTableRow -Examples"
    For more information, type: "Get-Help Add-SpectreTableRow -Detailed"
    For technical information, type: "Get-Help Add-SpectreTableRow -Full"



```

## Invoke-SpectreLive

```powershell

NAME
    Invoke-SpectreLive
    
SYNOPSIS
    Invokes a script block with live rendering.
    
    
SYNTAX
    Invoke-SpectreLive [[-Data] <Object>] [[-ScriptBlock] <ScriptBlock>] [<CommonParameters>]
    
    
DESCRIPTION
    Starts live rendering for a given renderable. The script block is able to update the renderable in real-time and Spectre Console redraws every time the scriptblock calls `$Context.refresh()`.  
    
    :::note  
    If you need to know the size of the layouts you can use the [`Get-SpectreLayoutSizes`](https://pwshspectreconsole.com/reference/measurement/get-spectrelayoutsizes/) function.  
    :::  
    
    See https://spectreconsole.net/live/live-display for more information.
    

PARAMETERS
    -Data <Object>
        The renderable object to render.
        
    -ScriptBlock <ScriptBlock>
        The script block to execute while the live renderable is being rendered.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This is a live updating table example, the table will be updated every second with a new row.
    $data = @(
        [pscustomobject]@{Name="John"; Age=25; City="New York"},
        [pscustomobject]@{Name="Jane"; Age=30; City="Los Angeles"}
    )
    $table = Format-SpectreTable -Data $data
    
    Invoke-SpectreLive -Data $table -ScriptBlock {
        param (
            [Spectre.Console.LiveDisplayContext] $Context
        )
        $Context.refresh()
        for ($i = 0; $i -lt 5; $i++) {
            Start-Sleep -Seconds 1
            $table = Add-SpectreTableRow -Table $table -Columns "Shaun $i", $i, "Wellington"
            $Context.refresh()
        }
    }
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > # **Example 2**  
    # This is a complex live updating nested layout example. It demonstrates how to create a file browser with a preview panel.
    # The root layout is constructed with a header and a content panel. The content panel is split into two columns: filelist and preview.
    # Invoke-SpectreLive is used to render the layout and update the content of each panel on every loop iteration until the escape key is pressed.
    $layout = New-SpectreLayout -Name "root" -Rows @(
        # Row 1
        (
            New-SpectreLayout -Name "header" -MinimumSize 5 -Ratio 1 -Data ("empty")
        ),
        # Row 2
        (
            New-SpectreLayout -Name "content" -Ratio 10 -Columns @(
                (
                    New-SpectreLayout -Name "filelist" -Ratio 2 -Data "empty"
                ),
                (
                    New-SpectreLayout -Name "preview" -Ratio 4 -Data "empty"
                )
            )
        )
    )
    
    # Functions for rendering the content of each panel
    function Get-TitlePanel {
        return "File Browser - Spectre Live Demo [gray]$(Get-Date)[/]" | Format-SpectreAligned -HorizontalAlignment Center -VerticalAlignment Middle | Format-SpectrePanel -Expand
    }
    
    function Get-FileListPanel {
        param (
            $Files,
            $SelectedFile
        )
        $fileList = $Files | ForEach-Object {
            $name = $_.Name
            if ($_.Name -eq $SelectedFile.Name) {
                $name = "[Turquoise2]$($name)[/]"
            }
            return $name
        } | Out-String
        return Format-SpectrePanel -Header "[white]File List[/]" -Data $fileList.Trim() -Expand
    }
    
    function Get-PreviewPanel {
        param (
            $SelectedFile
        )
        $item = Get-Item -Path $SelectedFile.FullName
        $result = ""
        if ($item -is [System.IO.DirectoryInfo]) {
            $result = "[grey]$($SelectedFile.Name) is a directory.[/]"
        } elseif ($item.Name -match "\.(jpg|jpeg|png|gif)$") {
            $result = Get-SpectreSixelImage $item.FullName
        } else {
            try {
                $content = Get-Content -Path $item.FullName -Raw -ErrorAction Stop
                $result = "[grey]$($content | Get-SpectreEscapedText)[/]"
            } catch {
                $result = "[red]Error reading file content: $($_.Exception.Message | Get-SpectreEscapedText)[/]"
            }
        }
        return $result | Format-SpectrePanel -Header "[white]Preview[/]" -Expand
    }
    
    function Get-LastKeyPressed {
        $lastKeyPressed = $null
        while ([Console]::KeyAvailable) {
            $lastKeyPressed = [Console]::ReadKey($true)
        }
        return $lastKeyPressed
    }
    
    # Start live rendering the layout
    # Type "↓", "↓", "↓" to navigate the file list, and press "Enter" to open a file in Notepad
    Invoke-SpectreLive -Data $layout -ScriptBlock {
        param (
            [Spectre.Console.LiveDisplayContext] $Context
        )
    
        # State
        $fileList = @(@{Name = ".."; Fullname = ".."}) + (Get-ChildItem)
        $selectedFile = $fileList[0]
    
        while ($true) {
            # Handle input
            $lastKeyPressed = Get-LastKeyPressed
            if ($lastKeyPressed -ne $null) {
                if ($lastKeyPressed.Key -eq "DownArrow") {
                    $selectedFile = $fileList[($fileList.IndexOf($selectedFile) + 1) % $fileList.Count]
                } elseif ($lastKeyPressed.Key -eq "UpArrow") {
                    $selectedFile = $fileList[($fileList.IndexOf($selectedFile) - 1 + $fileList.Count) % $fileList.Count]
                } elseif ($lastKeyPressed.Key -eq "Enter") {
                    if ($selectedFile -is [System.IO.DirectoryInfo] -or $selectedFile.Name -eq "..") {
                        $fileList = @(@{Name = ".."; Fullname = ".."}) + (Get-ChildItem -Path $selectedFile.FullName)
                        $selectedFile = $fileList[0]
                    } else {
                        notepad $selectedFile.FullName
                        return
                    }
                } elseif ($lastKeyPressed.Key -eq "Escape") {
                    return
                }
            }
    
            # Generate new data
            $titlePanel = Get-TitlePanel
            $fileListPanel = Get-FileListPanel -Files $fileList -SelectedFile $selectedFile
            $previewPanel = Get-PreviewPanel -SelectedFile $selectedFile
    
            # Update layout
            $layout["header"].Update($titlePanel) | Out-Null
            $layout["filelist"].Update($fileListPanel) | Out-Null
            $layout["preview"].Update($previewPanel) | Out-Null
    
            # Draw changes
            $Context.Refresh()
            Start-Sleep -Milliseconds 200
        }
    }
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS > # **Example 3**  
    # This is a simple example of creating a chat application. In this example a different approach is used to render the components, each component has been passed a copy of the context and layout object so it can update itself.
    
    Set-SpectreColors -AccentColor DeepPink1
    
    # Build root layout scaffolding for:
    # +--------------------------------+
    # |             Title              | <- Update-TitleComponent will render the title
    # |--------------------------------|
    # |                                | <- Update-MessageListComponent will display the list of messages here
    # |                                |
    # |            Messages            |
    # |                                |
    # |                                |
    # |--------------------------------|
    # |        CustomTextEntry         | <- Update-CustomTextEntryComponent will create a text entry prompt here that is manually managed by pushing keys into a string
    # |________________________________|
    
    $layout = New-SpectreLayout -Name "root" -Rows @(
        # Row 1
        (New-SpectreLayout -Name "title" -MinimumSize 5 -Ratio 1 -Data ("empty")),
        # Row 2
        (New-SpectreLayout -Name "messages" -Ratio 10 -Data ("empty")),
        # Row 3
        (New-SpectreLayout -Name "customTextEntry" -MinimumSize 5 -Ratio 1 -Data ("empty"))
    )
    
    # Component functions for rendering the content of each panel
    function Update-TitleComponent {
        param (
            [Spectre.Console.LiveDisplayContext] $Context,
            [Spectre.Console.Layout] $LayoutComponent
        )
        $component = @(
            ("🧠 ChaTTY" | Format-SpectreAligned -HorizontalAlignment Center -VerticalAlignment Middle | Format-SpectrePadded -Padding 1),
            (Write-SpectreRule -LineColor DeepPink1 -PassThru)
        ) | Format-SpectreRows | Format-SpectrePanel -Border None
        $LayoutComponent.Update($component) | Out-Null
        $Context.Refresh()
    }
    
    function Update-MessageListComponent {
        param (
            [Spectre.Console.LiveDisplayContext] $Context,
            [Spectre.Console.Layout] $LayoutComponent,
            [System.Collections.Stack] $Messages
        )
    
        $rows = @()
    
        foreach ($message in $Messages) {
            if ($message.Actor -eq "System") {
                $rows += $message.Message.PadRight(6) `
                    | Get-SpectreEscapedText `
                    | Write-SpectreHost -Justify Left -PassThru `
                    | Format-SpectrePanel -Color Grey -Header "System" `
                    | Format-SpectreAligned -HorizontalAlignment Left `
                    | Format-SpectrePadded -Top 0 -Left 10 -Bottom 0 -Right 0
            } else {
                $rows += $message.Message.PadRight($message.Actor.Length) `
                    | Get-SpectreEscapedText `
                    | Write-SpectreHost -Justify Right -PassThru `
                    | Format-SpectrePanel -Color Pink1 -Header $message.Actor `
                    | Format-SpectreAligned -HorizontalAlignment Right `
                    | Format-SpectrePadded -Top 0 -Left 0 -Bottom 0 -Right 10
            }
        }
    
        # Add the heights of each message until reaching the max size, subtract the height of the title and text entry components (10)
        $availableHeight = $Host.UI.RawUI.WindowSize.Height - 10
        $totalHeight = 0
        $rowsToRender = @()
        foreach ($row in $rows) {
            $totalHeight += ($row | Get-SpectreRenderableSize).Height
            if ($totalHeight -gt $availableHeight) {
                break
            }
            $rowsToRender += $row
        }
    
        # Stack is LIFO, so we need to reverse it to display the messages in the correct order
        [array]::Reverse($rowsToRender)
    
        $component = $rowsToRender | Format-SpectreRows | Format-SpectreAligned -VerticalAlignment Top | Format-SpectrePanel -Border None
        $LayoutComponent.Update($component) | Out-Null
        $Context.Refresh()
    }
    
    function Update-CustomTextEntryComponent {
        param (
            [Spectre.Console.LiveDisplayContext] $Context,
            [Spectre.Console.Layout] $LayoutComponent,
            [string] $CurrentInput
        )
        $safeInput = [string]::IsNullOrEmpty($CurrentInput) ? "" : ($CurrentInput | Get-SpectreEscapedText)
        $component = "[gray]Prompt:[/] $safeInput" | Format-SpectrePanel -Expand | Format-SpectrePadded -Top 0 -Left 20 -Bottom 0 -Right 20 | Format-SpectreAligned -HorizontalAlignment Center
        $LayoutComponent.Update($component) | Out-Null
        $Context.Refresh()
    }
    
    # App logic functions
    function Get-SomeChatResponse {
        param (
            [System.Collections.Stack] $Messages,
            [Spectre.Console.LiveDisplayContext] $Context,
            [Spectre.Console.Layout] $LayoutComponent
        )
    
        # Pretend to be thinking
        $ellipsisCount = 1
        for ($i = 0; $i -lt 3; $i++) {
            $Messages.Push(@{ Actor = "System"; Message = ("." * $ellipsisCount) })
            $ellipsisCount++
    
            Update-MessageListComponent -Context $Context -LayoutComponent $LayoutComponent -Messages $Messages
            Start-Sleep -Milliseconds 500
    
            # Remove the last thinking message
            $null = $Messages.Pop()
        }
    
        # Return the response
        return @{ Actor = "System"; Message = "I don't understand what you're saying." }
    }
    
    function Get-LastChatKeyPressed {
        return [Console]::ReadKey($true)
    }
    
    # Start live rendering the layout
    Invoke-SpectreLive -Data $layout -ScriptBlock {
        param (
            [Spectre.Console.LiveDisplayContext] $Context
        )
    
        # State
        $messages = [System.Collections.Stack]::new(@(
            @{ Actor = "System"; Message = "👋 Hello, welcome to ChaTTY!" },
            @{ Actor = "System"; Message = "Type your message and press Enter to send it." },
            @{ Actor = "System"; Message = "Use the Up and Down arrow keys to scroll through previous messages." },
            @{ Actor = "System"; Message = "Press 'ctrl-c' to close the chat." }
        ))
        $currentInput = ""
    
        while ($true) {
            # Update components
            Update-TitleComponent -Context $Context -LayoutComponent $layout["title"]
            Update-MessageListComponent -Context $Context -LayoutComponent $layout["messages"] -Messages $messages
            Update-CustomTextEntryComponent -Context $Context -LayoutComponent $layout["customTextEntry"] -CurrentInput $currentInput
    
            # Real basic input handling, just add characters and remove if backspace is pressed, submit message if Enter is pressed
            [Console]::TreatControlCAsInput = $true
            $lastKeyPressed = Get-LastChatKeyPressed
            if ($lastKeyPressed.Key -eq "C" -and $lastKeyPressed.Modifiers -eq "Control") {
                # Exit the loop. You have to treat ctrl-c as input to avoid the console readkey blocking the sigint
                return
            } elseif ($lastKeyPressed.Key -eq "Enter") {
                # Add the latest user message to the message stack
                $messages.Push(@{ Actor = ($env:USERNAME + $env:USER); Message = $currentInput })
                $currentInput = ""
                Update-CustomTextEntryComponent -Context $Context -LayoutComponent $layout["customTextEntry"] -CurrentInput $currentInput
                Update-MessageListComponent -Context $Context -LayoutComponent $layout["messages"] -Messages $messages
                $messages.Push((Get-SomeChatResponse -Messages $messages -Context $Context -LayoutComponent $layout["messages"]))
            } elseif($lastKeyPressed.Key -eq "Backspace") {
                # Remove the last character from the current input string
                $currentInput = $currentInput.Substring(0, [Math]::Max(0, $currentInput.Length - 1))
            } elseif ($lastKeyPressed.KeyChar) {
                # Add the character to the current input string
                $currentInput += $lastKeyPressed.KeyChar
            }
        }
    }
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Invoke-SpectreLive -Examples"
    For more information, type: "Get-Help Invoke-SpectreLive -Detailed"
    For technical information, type: "Get-Help Invoke-SpectreLive -Full"



```

## Format-SpectreException

```powershell

NAME
    Format-SpectreException
    
SYNOPSIS
    Formats an error record/exception into a Spectre Console Exception which supports syntax highlighting.
    
    
SYNTAX
    Format-SpectreException [-Exception] <Object> [[-ExceptionFormat] <String>] [[-ExceptionStyle] <Hashtable>] [<CommonParameters>]
    
    
DESCRIPTION
    Formats an error record/exception into a Spectre Console Exception which supports syntax highlighting.  
    See https://spectreconsole.net/exceptions for more information.
    

PARAMETERS
    -Exception <Object>
        The error/exception object to format.
        
    -ExceptionFormat <String>
        The format to use when rendering the exception. The default value is "Default".
        
    -ExceptionStyle <Hashtable>
        The style to use when rendering the exception provided as a hashtable. e.g. 
        ```
        @{
            Message        = "red"
            Exception      = "white"
            Method         = "yellow"
            ParameterType  = "blue"
            ParameterName  = "silver"
            Parenthesis    = "silver"
            Path           = "Yellow"
            LineNumber     = "blue"
            Dimmed         = "grey"
            NonEmphasized  = "silver"
        }
        ```
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to format an exception into a Spectre Console Exception with syntax highlighting.
    try {
        Get-ChildItem -BadParam -ErrorAction Stop
    } catch {
        $_ | Format-SpectreException -ExceptionFormat ShortenEverything
    }
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > # **Example 2**
    # This example uses custom formatting for the exception.
    try {
        Get-ChildItem -BadParam -ErrorAction Stop
    } catch {
        $_ | Format-SpectreException -ExceptionStyle @{
            Message        = "#00ff00"
            Exception      = "white"
            Method         = "#ff0000 on orange1"
            ParameterType  = "blue"
            ParameterName  = "silver"
            Parenthesis    = "silver"
            Path           = "Yellow"
            LineNumber     = "blue"
            Dimmed         = "grey"
            NonEmphasized  = "silver"
        }
    }
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Format-SpectreException -Examples"
    For more information, type: "Get-Help Format-SpectreException -Detailed"
    For technical information, type: "Get-Help Format-SpectreException -Full"



```

## Get-SpectreDemoFeatures

```powershell

NAME
    Get-SpectreDemoFeatures
    
SYNOPSIS
    Demonstrates the features of Spectre.Console.
    
    
SYNTAX
    Get-SpectreDemoFeatures [<CommonParameters>]
    
    
DESCRIPTION
    This script demonstrates the features of Spectre.Console. It shows off the various colors, styles, and other features that Spectre.Console supports.
    

PARAMETERS
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates how to use Get-SpectreDemoFeatures to display a list of the features of Spectre.Console as seen on the https://spectreconsole.net/ homepage.
    Get-SpectreDemoFeatures
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Get-SpectreDemoFeatures -Examples"
    For more information, type: "Get-Help Get-SpectreDemoFeatures -Detailed"
    For technical information, type: "Get-Help Get-SpectreDemoFeatures -Full"



```

## Get-SpectreRenderableSize

```powershell

NAME
    Get-SpectreRenderableSize
    
SYNOPSIS
    Gets the width and height of a Spectre Console widget.
    
    
SYNTAX
    Get-SpectreRenderableSize [-Renderable] <Renderable> [[-ContainerHeight] <Int32>] [[-ContainerWidth] <Int32>] [<CommonParameters>]
    
    
DESCRIPTION
    The Get-SpectreRenderableSize function gets the height of a Spectre Console renderable object. The width and height is estimated.  
    This method of size calculation is not perfect, but it is a good approximation for most use cases. There are factors outside of the control of this function that can affect the size of the widget once it's rendered to the console.  
    The size of a containing object can influence the size of the widget when it's expandable. If you know the width and height of a container that this widget will be rendered inside you can provide that as a parameter to get a more accurate size.
    

PARAMETERS
    -Renderable <Renderable>
        The widget to calculate the size of.
        
    -ContainerHeight <Int32>
        The height of the container that the widget will be rendered inside.
        
    -ContainerWidth <Int32>
        The width of the container that the widget will be rendered inside.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example calculates the height of a small panel
    $panel = "hello`nworld" | Format-SpectrePanel
    $panelSize = $panel | Get-SpectreRenderableSize
    Write-SpectreHost "Panel width: $($panelSize.Width), height: $($panelSize.Height)"
    $panel | Out-SpectreHost
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Get-SpectreRenderableSize -Examples"
    For more information, type: "Get-Help Get-SpectreRenderableSize -Detailed"
    For technical information, type: "Get-Help Get-SpectreRenderableSize -Full"



```

## Read-SpectreSelectionGrouped

```powershell

NAME
    Read-SpectreSelectionGrouped
    
SYNOPSIS
    Displays a selection prompt using Spectre Console with groups.
    
    
SYNTAX
    Read-SpectreSelectionGrouped [[-Message] <String>] [-Choices] <Hashtable> [[-ChoiceLabelProperty] <String>] [[-Color] <Color>] [[-PageSize] <Int32>] [-EnableSearch] [[-TimeoutSeconds] <Int32>] [[-SearchHighlightColor] <Color>] [<CommonParameters>]
    
    
DESCRIPTION
    This function displays a selection prompt using Spectre Console. The user can select an option from the list of choices provided. The function returns the selected option.  
    With the `-EnableSearch` switch, the user can search for choices in the selection prompt by typing the characters instead of just typing up and down arrows.
    

PARAMETERS
    -Message <String>
        The title of the selection prompt.
        
    -Choices <Hashtable>
        
    -ChoiceLabelProperty <String>
        If the object is complex then the property of the choice object to use as the label in the selection prompt is required.
        
    -Color <Color>
        The color of the selected option in the selection prompt.
        
    -PageSize <Int32>
        The number of choices to display per page in the selection prompt.
        
    -EnableSearch [<SwitchParameter>]
        If this switch is present, the user can search for choices in the selection prompt by typing the characters instead of just typing up and down arrows.
        
    -TimeoutSeconds <Int32>
        
    -SearchHighlightColor <Color>
        The color of the search highlight in the selection prompt. Defaults to a slightly brighter version of the accent color.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example demonstrates a selection prompt with a custom title and choices.
    $choices = @{
        "Reds" = @("Crimson", "Ruby", "Scarlet")
        "Greens" = @("Lime", "Emerald", "Jade")
        "Blues" = @("Azure", "Cerulean", "Sapphire")
    }
    $color = Read-SpectreSelectionGrouped -Message "Select your favorite color" -Choices $choices -Color "Green"
    # Type "↓", "↓", "↓", "↓", "↲" to wrap around the list and choose green
    Write-SpectreHost "Your chosen color is '$color'"
    
    
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Read-SpectreSelectionGrouped -Examples"
    For more information, type: "Get-Help Read-SpectreSelectionGrouped -Detailed"
    For technical information, type: "Get-Help Read-SpectreSelectionGrouped -Full"



```

## Get-SpectreLayoutSizes

```powershell

NAME
    Get-SpectreLayoutSizes
    
SYNOPSIS
    Gets the width and height of all of the layouts in a Spectre Console Layout.
    
    
SYNTAX
    Get-SpectreLayoutSizes [-Layout] <Layout> [<CommonParameters>]
    
    
DESCRIPTION
    The Get-SpectreLayoutSizes function gets the height of a Spectre Console layout object and all of its children. The result is a hashtable where you can access the size details for each layout object by its name.  
    When using sizes you need to be aware that this may include the size of the border if you specified one so you may need to subtract the border size from the total dimensions.
    

PARAMETERS
    -Layout <Layout>
        The root layout to calculate the size for including all of its children.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > # **Example 1**  
    # This example calculates the heights of all the layouts in a layout tree and tells you how high the content layout will be based on their ratios.
    
    $layout = New-SpectreLayout -Name "root" -Rows @(
        # Row 1
        (New-SpectreLayout -Name "title" -Ratio 1 -Data ("Title goes here" | Format-SpectrePanel -Expand)),
        # Row 2
        (New-SpectreLayout -Name "body" -Ratio 3 -Columns @(
            # Column 1
            (New-SpectreLayout -Name "left" -Ratio 1 -Data ("Left goes here" | Format-SpectrePanel -Expand)),
            # Column 2
            (New-SpectreLayout -Name "right" -Ratio 2 -Data ("Right goes here" | Format-SpectrePanel -Expand))
        ))
    )
    
    # Get the sizes of the layouts in the layout tree before populating them with data
    $sizes = $layout | Get-SpectreLayoutSizes
    
    # Subtract the border sizes!
    $titleWidth = $sizes["title"].Width - 2
    $titleHeight = $sizes["title"].Height - 2
    $leftWidth = $sizes["left"].Width - 2
    $leftHeight = $sizes["left"].Height - 2
    $rightWidth = $sizes["right"].Width - 2
    $rightHeight = $sizes["right"].Height - 2
    
    # Populate the layouts with data that takes up the full height of the layout
    $titleContent = ((1..($titleHeight + 1)) | ForEach-Object { "Title line $_" }) -join "`n"
    $leftContent = ((1..($leftHeight + 1)) | ForEach-Object { "Left line $_" }) -join "`n"
    $rightContent = ((1..($rightHeight + 1)) | ForEach-Object { "Right line $_" }) -join "`n"
    
    $null = $layout["title"].Update(($titleContent | Format-SpectrePanel -Title "I am $titleWidth x $titleHeight" -Expand))
    $null = $layout["left"].Update(($leftContent | Format-SpectrePanel -Title "I am $leftWidth x $leftHeight" -Expand))
    $null = $layout["right"].Update(($rightContent | Format-SpectrePanel -Title "I am $rightWidth x $rightHeight" -Expand))
    
    $layout | Out-SpectreHost
    
    
    
    
REMARKS
    To see the examples, type: "Get-Help Get-SpectreLayoutSizes -Examples"
    For more information, type: "Get-Help Get-SpectreLayoutSizes -Detailed"
    For technical information, type: "Get-Help Get-SpectreLayoutSizes -Full"



```
