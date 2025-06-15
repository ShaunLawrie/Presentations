---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/formatting/format-spectretree/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Format-SpectreTree
---

# Format-SpectreTree

## SYNOPSIS

Formats a hashtable as a tree using Spectre Console.

## SYNTAX

### __AllParameterSets

```
Format-SpectreTree [-Data] <hashtable> [[-Guide] <string>] [[-Color] <Color>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function takes a hashtable and formats it as a tree using Spectre Console.
The hashtable should have a 'Value' key and a 'Children' key.
The 'Value' key should contain the Spectre Console renderable item (text or other objects like calendars etc.) for the node of the tree, and the 'Children' key should contain an array of hashtables representing the child nodes of the node.
 
See https://spectreconsole.net/widgets/tree for more information.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
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

## PARAMETERS

### -Color

The color to use for the tree.
This can be a Spectre Console color name or a hex color code.
Default is the accent color defined in the script.

```yaml
Type: Spectre.Console.Color
DefaultValue: $script:AccentColor
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Data

The hashtable to format as a tree.

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Guide

The type of line to use for the tree.

```yaml
Type: System.String
DefaultValue: Line
SupportsWildcards: false
Aliases:
- Border
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Collections.Hashtable

{{ Fill in the Description }}

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

