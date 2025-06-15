---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/config/set-spectrecolors/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Set-SpectreColors
---

# Set-SpectreColors

## SYNOPSIS

Sets the accent color and default value color for Spectre Console.

## SYNTAX

### __AllParameterSets

```
Set-SpectreColors [[-AccentColor] <Color>] [[-DefaultValueColor] <Color>]
 [[-DefaultTableHeaderColor] <Color>] [[-DefaultTableTextColor] <Color>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function sets the accent color and default value color for Spectre Console.
The accent color is used for highlighting important information, while the default value color is used for displaying default values.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to set the accent color and default value color for Spectre Console.
Write-SpectreRule "This is a default rule"
Set-SpectreColors -AccentColor "Turquoise2"
Write-SpectreRule "This is a Turquoise2 rule"
Write-SpectreRule "This is a rule with a specified color" -Color "Yellow"

## PARAMETERS

### -AccentColor

The accent color to set.
Must be a valid Spectre Console color name.
Defaults to "Blue".

```yaml
Type: Spectre.Console.Color
DefaultValue: Blue
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DefaultTableHeaderColor

The default table header color to set.
Must be a valid Spectre Console color name.
Defaults to "Default" which will be the standard console foreground color.

```yaml
Type: Spectre.Console.Color
DefaultValue: '[Spectre.Console.Color]::Default'
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

### -DefaultTableTextColor

The default table text color to set.
Must be a valid Spectre Console color name.
Defaults to "Default" which will be the standard console foreground color.

```yaml
Type: Spectre.Console.Color
DefaultValue: '[Spectre.Console.Color]::Default'
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DefaultValueColor

The default value color to set.
Must be a valid Spectre Console color name.
Defaults to "Grey".

```yaml
Type: Spectre.Console.Color
DefaultValue: Grey
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

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

