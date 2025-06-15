---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/formatting/add-spectretablerow/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Add-SpectreTableRow
---

# Add-SpectreTableRow

## SYNOPSIS

Adds a row to a Spectre Console table.

## SYNTAX

### __AllParameterSets

```
Add-SpectreTableRow [-Table] <Table> [[-Columns] <array>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Adds a row to a Spectre Console table.
The number of columns in the row must match the number of columns in the table.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to add a row to an existing Spectre Console table.
$data = @(
    [pscustomobject]@{Name="John"; Age=25; City="New York"},
    [pscustomobject]@{Name="Jane"; Age=30; City="Los Angeles"}
)
$table = Format-SpectreTable -Data $data
$table | Out-SpectreHost

$table = Add-SpectreTableRow -Table $table -Columns "Shaun", 99, "Wellington"
$table | Out-SpectreHost

## PARAMETERS

### -Columns

An array of renderable items containing the data to be displayed in the columns of this row.

```yaml
Type: System.Array
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Table

The table to which the row will be added.

```yaml
Type: Spectre.Console.Table
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
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

### System.Array

{{ Fill in the Description }}

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

