---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/formatting/format-spectrealigned/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Format-SpectreAligned
---

# Format-SpectreAligned

## SYNOPSIS

Wraps a renderable object in a Spectre Console Aligned object.

## SYNTAX

### __AllParameterSets

```
Format-SpectreAligned [-Data] <Object> [[-HorizontalAlignment] <string>]
 [[-VerticalAlignment] <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This wraps a renderable object in a Spectre Console Aligned object.
This allows you to align the object horizontally and vertically within a space.
Aligned objects are always expanded so they take up all available horizontal space.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to align a string to the right inside a panel.
"hello right hand side" | Format-SpectreAligned -HorizontalAlignment Right -VerticalAlignment Middle | Format-SpectrePanel -Expand -Height 9

## PARAMETERS

### -Data

The renderable object to align.

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

### -HorizontalAlignment

The horizontal alignment of the object.

```yaml
Type: System.String
DefaultValue: Center
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

### -VerticalAlignment

The vertical alignment of the object.

```yaml
Type: System.String
DefaultValue: Middle
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

