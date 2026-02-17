# Function to build tree data structure from AST
function ConvertTo-TreeData {
    param(
        [string]$CommandName,
        [System.Management.Automation.Language.Ast]$Node,
        [int]$MaxDepth = 5
    )
    
    $ErrorActionPreference = 'SilentlyContinue'
    
    $excludeProps = @('Body', 'Parent', 'StaticType', 'VariablePath', 'Splatted', 'Traps', 'Redirections', '*Block', 'Attributes', 'UsingStatements', 'Unnamed', 'BlockKind', 'Operator', 'ErrorPosition', 'StringConstantType', 'InvocationOperator', 'DefiningKeyword')

    # Get all nodes at once with recursion enabled
    $allAstNodes = $Node.FindAll({ $true }, $true)
    
    # Build a hashtable to store tree data for each node
    $nodeData = @{}
    
    # Create tree data for each node
    foreach ($astNode in $allAstNodes) {
        $nodeType = $astNode.GetType().Name
        
        # Exclude top-level properties
        $selectedObject = $astNode | Select-Object -ExcludeProperty $excludeProps
        
        # Clean up nested objects - exclude properties from child properties
        $processedObject = [PSCustomObject]@{}
        foreach ($prop in $selectedObject.PSObject.Properties) {
            $propValue = $prop.Value
            
            # Special handling for Name properties - extract VariablePath.Name if present
            if ($prop.Name -eq 'Name' -and $null -ne $propValue) {
                $propValue = $propValue.ToString()
            }
            
            # Check if it's an object that has properties (not a primitive, string, or collection)
            if ($null -ne $propValue -and $propValue.GetType().IsClass -and -not ($propValue -is [string]) -and -not ($propValue -is [Array])) {
                    $processedObject | Add-Member -NotePropertyName $prop.Name -NotePropertyValue ($propValue | Select-Object -ExcludeProperty ($excludeProps + 'Extent') -ErrorAction SilentlyContinue)
            } else {
                $processedObject | Add-Member -NotePropertyName $prop.Name -NotePropertyValue $propValue -ErrorAction SilentlyContinue
            }
        }
        
        # Extract and format extent information for code highlighting
        $extentInfo = ""
        if ($astNode.Extent) {
            $line = $astNode.Extent.StartScriptPosition.Line
            if ($line) {
                # Remove trailing newline
                $line = $line.TrimEnd("`r`n")
                
                # Get column positions (1-based)
                $startCol = $astNode.Extent.StartColumnNumber
                $endCol = $astNode.Extent.EndColumnNumber
                
                # If extent spans multiple lines, highlight to the end of the start line
                $isMultiLine = $astNode.Extent.StartLineNumber -ne $astNode.Extent.EndLineNumber
                if ($isMultiLine) {
                    $endCol = $line.Length + 1
                }
                
                # Build highlighted line
                if ($startCol -gt 1) {
                    $before = $line.Substring(0, $startCol - 1) | Get-SpectreEscapedText
                } else {
                    $before = ""
                }
                
                $highlighted = $line.Substring($startCol - 1, $endCol - $startCol) | Get-SpectreEscapedText
                
                # Append "..." if this is a multi-line extent
                if ($isMultiLine) {
                    $highlighted += "..."
                }
                
                if ($endCol -le $line.Length) {
                    $after = $line.Substring($endCol - 1) | Get-SpectreEscapedText
                } else {
                    $after = ""
                }
                
                $extentInfo = "[white]$($before.TrimStart())[black on Gold1]$highlighted[/]$($after.TrimEnd()))[/]".Trim()
            }
            # Remove the extent
            $processedObject.PSObject.Properties.Remove('Extent') | Out-Null
        }
        
        $jsonData = $processedObject |
            ConvertTo-Json -Depth 2 -WarningAction SilentlyContinue |
            Get-SpectreEscapedText
        
        $value = "[Grey50]$jsonData[/]" |
            Format-SpectrePanel -Header "${nodeType}: $extentInfo" -Border Heavy -Expand
        
        $nodeData[$astNode] = @{
            Value = $value
            Children = @()
            Node = $astNode
        }
    }
    
    # Build parent-child relationships
    foreach ($astNode in $allAstNodes) {
        # Skip VariableExpressionAst nodes to reduce noise
        if ($astNode -is [System.Management.Automation.Language.VariableExpressionAst]) {
            continue
        }
        if ($astNode.Parent -and $nodeData.ContainsKey($astNode.Parent)) {
            # Add this node as a child of its parent
            $nodeData[$astNode.Parent].Children += $nodeData[$astNode]
        }
    }

    # Replace root node value with figlet text and full code snippet
    $figletText = Write-SpectreFigletText -Text $CommandName -FigletFontPath "$PSScriptRoot/3d.flf" -PassThru
    $codeSnippet = $Node.Extent.Text | Get-SpectreEscapedText
    $nodeData[$Node].Value = @($figletText, "`n[blue]$codeSnippet[/]`n") | Format-SpectreRows
    
    # Return the root node's data
    return $nodeData[$Node]
}

function Remove-TreeNodes {
    <#
    .SYNOPSIS
    Removes nodes from tree data based on their header text.
    
    .PARAMETER TreeData
    The tree data structure to filter.
    
    .PARAMETER Headers
    Array of header names to remove. Will match using -like pattern.
    
    .EXAMPLE
    $treeData = ConvertTo-TreeData -Node $ast -CommandName "Test"
    Remove-TreeNodes -TreeData $treeData -Headers @("VariableExpressionAst", "NamedBlockAst")
    #>
    param(
        [hashtable]$TreeData,
        [string[]]$Headers
    )
    
    if (-not $TreeData.Children) {
        return
    }
    
    # Filter out children whose headers match the removal list, promoting their children
    $filteredChildren = @()
    foreach ($child in $TreeData.Children) {
        $shouldRemove = $false
        
        # Check if this child's header matches any of the headers to remove
        if ($child.Value.Header.Text) {
            foreach ($targetHeader in $Headers) {
                if ($child.Value.Header.Text -like "*$targetHeader*") {
                    $shouldRemove = $true
                    break
                }
            }
        }
        
        if ($shouldRemove) {
            # Recursively process this child's children first
            Remove-TreeNodes -TreeData $child -Headers $Headers
            # Add the child's children to the current level (promoting them)
            $filteredChildren += $child.Children
        } else {
            # Recursively process this child's children
            Remove-TreeNodes -TreeData $child -Headers $Headers
            # Keep this node
            $filteredChildren += $child
        }
    }
    
    # Update the children array
    $TreeData.Children = $filteredChildren
}

function Get-TreeNodesInOrder {
    <#
    .SYNOPSIS
    Gets all nodes in the tree in depth-first order.
    
    .PARAMETER TreeData
    The tree data structure to traverse.
    #>
    param(
        [hashtable]$TreeData,
        [switch]$SkipRoot
    )
    
    $nodes = @()
    
    if (-not $SkipRoot) {
        $nodes += $TreeData
    }
    
    foreach ($child in $TreeData.Children) {
        $nodes += Get-TreeNodesInOrder -TreeData $child
    }
    
    return $nodes
}

function Set-NodeExpanded {
    <#
    .SYNOPSIS
    Sets whether a node shows full details or just header text.
    
    .PARAMETER Node
    The node to modify.
    
    .PARAMETER Expanded
    Whether the node should be expanded.
    #>
    param(
        [hashtable]$Node,
        [bool]$Expanded
    )
    
    if ($Expanded) {
        # Restore full value if we have it stored
        if ($Node.FullValue) {
            $Node.Value = $Node.FullValue
        }
    } else {
        # Store full value and replace with just header
        if (-not $Node.FullValue) {
            $Node.FullValue = $Node.Value
        }
        # Extract just the header text from the panel
        if ($Node.Value.Header) {
            $Node.Value = $Node.Value.Header.Text
        }
    }
}

function Format-SpectreAst {
    <#
    .SYNOPSIS
    Displays the Abstract Syntax Tree (AST) of a PowerShell command as a tree visualization.
    
    .PARAMETER Command
    The name of a command/function to analyze.
    
    .EXAMPLE
    Show-AstTree -Command Write-Hello
    #>
    param(
        [string]$Command
    )
    
    $commandInfo = Get-Command $Command -ErrorAction Stop
    $ast = $commandInfo.ScriptBlock.Ast
    
    # Build and display the tree
    $treeData = ConvertTo-TreeData -Node $ast -CommandName $Command
    # Remove noisy nodes to simplify the tree
    Remove-TreeNodes -TreeData $treeData -Headers @("ScriptBlockAst", "PipelineAst", "NamedBlockAst")
    
    # Get all nodes in order (skip root as it's always expanded)
    $nodeList = Get-TreeNodesInOrder -TreeData $treeData -SkipRoot
    
    # Initially collapse all nodes
    foreach ($node in $nodeList) {
        Set-NodeExpanded -Node $node -Expanded $false
    }
    
    # Progressive expansion animation
    
    Clear-Host
    [Console]::SetCursorPosition(0, 0)
    
    for ($i = 0; $i -le $nodeList.Count; $i++) {
        # Clear screen and reset cursor
        [Console]::SetCursorPosition(0, 0)
        
        # Expand nodes up to current index
        for ($j = 0; $j -lt $i; $j++) {
            Set-NodeExpanded -Node $nodeList[$j] -Expanded $true
        }
        
        # Render the tree
        Format-SpectreTree -Data $treeData -Border BoldLine | Out-SpectreHost
        
        # Wait for Enter (except on last iteration)
        if ($i -lt $nodeList.Count) {
            $null = Read-Host
        }
    }
}
