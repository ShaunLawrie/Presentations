---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/formatting/new-spectregridrow/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: New-SpectreGridRow
---

# New-SpectreGridRow

## SYNOPSIS

Creates a new SpectreGridRow object.

## SYNTAX

### __AllParameterSets

```
New-SpectreGridRow [-Data] <array> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Creates a new SpectreGridRow object with the specified columns for use in Format-SpectreGrid.
PowerShell collapses nested arrays, so you must use this function to create an array of SpectreGridRow objects to provide to Format-SpectreGrid.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
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

## PARAMETERS

### -Data

An array of renderable items containing the data to be displayed in the columns of this row.

```yaml
Type: System.Array
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Array

{{ Fill in the Description }}

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

