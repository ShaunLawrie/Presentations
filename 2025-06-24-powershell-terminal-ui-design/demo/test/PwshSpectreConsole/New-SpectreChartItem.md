---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/formatting/new-spectrechartitem/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: New-SpectreChartItem
---

# New-SpectreChartItem

## SYNOPSIS

Creates a new SpectreChartItem object.

## SYNTAX

### __AllParameterSets

```
New-SpectreChartItem [-Label] <string> [-Value] <double> [-Color] <Color> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The New-SpectreChartItem function creates a new SpectreChartItem object with the specified label, value, and color for use in Format-SpectreBarChart and Format-SpectreBreakdownChart.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to use SpectreChartItems to create a breakdown chart.
$data = @()
$data += New-SpectreChartItem -Label "Sales" -Value 1000 -Color "green"
$data += New-SpectreChartItem -Label "Expenses" -Value 500 -Color "#ff0000"
$data += New-SpectreChartItem -Label "Profit" -Value 420 -Color ([Spectre.Console.Color]::Blue)
Write-SpectreHost "`nGenerate a bar chart`n"
$data | Format-SpectreBarChart
Write-SpectreHost "`nGenerate a breakdown chart`n"
$data | Format-SpectreBreakdownChart

## PARAMETERS

### -Color

The color for the chart item.
Must be a valid Spectre color as name, hex or a Spectre.Console.Color object.

```yaml
Type: Spectre.Console.Color
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Label

The label for the chart item.

```yaml
Type: System.String
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

### -Value

The value for the chart item.

```yaml
Type: System.Double
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
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

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

