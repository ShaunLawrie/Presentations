---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/formatting/format-spectrebarchart/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Format-SpectreBarChart
---

# Format-SpectreBarChart

## SYNOPSIS

Formats and displays a bar chart using the Spectre Console module.

## SYNTAX

### __AllParameterSets

```
Format-SpectreBarChart [-Data] <Object> [[-Label] <string>] [[-Width] <int>] [-HideValues]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function takes an array of data and displays it as a bar chart using the Spectre Console module.
The chart can be customized with a title and width.
 
See https://spectreconsole.net/widgets/barchart for more information.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to display a bar chart of various data points.
$data = @()

$data += New-SpectreChartItem -Label "Apples" -Value 10 -Color "Green"
$data += New-SpectreChartItem -Label "Oranges" -Value 5 -Color "DarkOrange"
$data += New-SpectreChartItem -Label "Bananas" -Value 2.2 -Color "#FFFF00"

Format-SpectreBarChart -Data $data -Label "Fruit Sales" -Width 50

## PARAMETERS

### -Data

An array of objects containing the data to be displayed in the chart.
Each object should have a Label, Value, and Color property.

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

### -HideValues

Hides the values from being displayed on the chart.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Label

The title to be displayed above the chart.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Title
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

### -Width

The width of the chart in characters.

```yaml
Type: System.Int32
DefaultValue: (Get-HostWidth)
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

