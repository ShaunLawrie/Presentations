---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/formatting/format-spectregrid/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Format-SpectreGrid
---

# Format-SpectreGrid

## SYNOPSIS

Formats data into a Spectre Console grid.

## SYNTAX

### __AllParameterSets

```
Format-SpectreGrid [-Data] <Object> [[-Width] <int>] [[-Padding] <int>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Formats data into a Spectre Console grid.
The grid can be used to display data in a tabular format but it's not as flexible as the Layout widget.
 
See https://spectreconsole.net/widgets/grid for more information.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to display a grid of rows using the Spectre Console module with a list of lists.
Format-SpectreGrid -Data @("hello", "I", "am"), @("a", "grid", "of"), @("rows", "using", "spectre")

### EXAMPLE 2

# **Example 2**  
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

## PARAMETERS

### -Data

The data to be displayed in the grid.
This can be a list of lists or a list of `New-SpectreGridRow` objects.

```yaml
Type: System.Object
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

### -Padding

The padding to apply to the grid items.
The default is 1.

```yaml
Type: System.Int32
DefaultValue: 1
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

### -Width

The width of the grid.
If not specified, the grid width will be automatic.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
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

### System.Object

{{ Fill in the Description }}

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

