---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/formatting/format-spectretextpath/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Format-SpectreTextPath
---

# Format-SpectreTextPath

## SYNOPSIS

Formats a path into a Spectre Console Path which supports highlighting and truncating.

## SYNTAX

### __AllParameterSets

```
Format-SpectreTextPath [-Path] <string> [[-Alignment] <string>] [[-PathStyle] <hashtable>]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Formats a path into a Spectre Console Path which supports highlighting and truncating.
 
See https://spectreconsole.net/widgets/text-path for more information.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to format a PowerShell path as a Spectre Console Path with syntax highlighting.
Get-Location | Format-SpectreTextPath | Out-SpectreHost

## PARAMETERS

### -Alignment

The alignment of the path.
Defaults to "Left".

```yaml
Type: System.String
DefaultValue: Left
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

### -Path

The directory/file path to format

```yaml
Type: System.String
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

### -PathStyle

A hashtable of Spectre Console colors or color names to style the path output.
e.g.
```
@{
    RootColor      = [Spectre.Console.Color]::Cyan2
    SeparatorColor = [Spectre.Console.Color]::Aqua
    StemColor      = [Spectre.Console.Color]::Orange1
    LeafColor      = "HotPink"
}
```

```yaml
Type: System.Collections.Hashtable
DefaultValue: >-
  @{
              RootColor      = $script:AccentColor
              SeparatorColor = $script:DefaultValueColor
              StemColor      = [Spectre.Console.Color]::Orange1
              LeafColor      = [Spectre.Console.Color]::Red
          }
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

### System.String

{{ Fill in the Description }}

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

