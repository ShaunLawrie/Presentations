---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/formatting/format-spectrebreakdownchart/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Format-SpectreBreakdownChart
---

# Format-SpectreBreakdownChart

## SYNOPSIS

Formats data into a breakdown chart.

## SYNTAX

### __AllParameterSets

```
Format-SpectreBreakdownChart [-Data] <Object> [[-Width] <int>] [-HideTags] [-HideTagValues]
 [-ShowPercentage] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function takes an array of data and formats it into a breakdown chart using BreakdownChart.
The chart can be customized with a specified width and color.
 
See https://spectreconsole.net/widgets/breakdownchart for more information.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to display a breakdown chart of various data points.
$data = @()

$data += New-SpectreChartItem -Label "Apples" -Value 10 -Color "Green"
$data += New-SpectreChartItem -Label "Oranges" -Value 5 -Color "Gold1"
$data += New-SpectreChartItem -Label "Bananas" -Value 2.2 -Color "#FFFF00"

Format-SpectreBreakdownChart -Data $data -Width 50

## PARAMETERS

### -Data

An array of data to be formatted into a breakdown chart.

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

### -HideTags

Hides the tags on the chart.

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

### -HideTagValues

Hides the tag values on the chart.

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

### -ShowPercentage

{{ Fill ShowPercentage Description }}

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

### -Width

The width of the chart.
Defaults to the width of the console.

```yaml
Type: System.Int32
DefaultValue: (Get-HostWidth)
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

