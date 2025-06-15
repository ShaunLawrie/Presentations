---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/formatting/format-spectrerows/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    text: New
    variant: tip
title: Format-SpectreRows
---

# Format-SpectreRows

## SYNOPSIS

Renders a collection of renderables in rows to the console.

## SYNTAX

### __AllParameterSets

```
Format-SpectreRows [-Data] <Object> [-Expand] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function creates a spectre rows widget that renders a collection of renderables in autosized rows to the console.
 
Rows can contain renderable items.
 
See https://spectreconsole.net/widgets/rows for more information.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to display a collection of strings in rows.
@("top", "middle", "bottom") | Format-SpectreRows

### EXAMPLE 2

# **Example 2**  
# This example demonstrates how to display a collection of renderable items as rows inside a panel, without wrapping the renderables in rows you cannot display them in a panel because a panel only accepts a single item.
$rows = @()
$bigText = "lorem ipsum dolor sit amet consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur excepteur sint occaecat cupidatat non proident sunt in culpa"
for ($i = 0; $i -lt 12; $i+= 4) {
    $rows += $bigText | Format-SpectrePadded -Left $i -Top 0 -Bottom 0 -Right 0
}
$rows | Format-SpectreRows | Format-SpectrePanel

## PARAMETERS

### -Data

An array of renderable items containing the data to be displayed in the rows.

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

### -Expand

{{ Fill Expand Description }}

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

