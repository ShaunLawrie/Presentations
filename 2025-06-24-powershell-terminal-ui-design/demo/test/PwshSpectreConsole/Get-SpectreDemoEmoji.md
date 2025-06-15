---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/demo/get-spectredemoemoji/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Get-SpectreDemoEmoji
---

# Get-SpectreDemoEmoji

## SYNOPSIS

Retrieves a collection of emojis available in Spectre Console.
![Example emojis](/emoji.png)

## SYNTAX

### __AllParameterSets

```
Get-SpectreDemoEmoji [[-Count] <int>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The Get-SpectreDemoEmoji function retrieves a collection of emojis available in Spectre Console.
It displays the general emojis, faces, and provides information on how to use emojis in Spectre Console markup.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to use Get-SpectreDemoEmoji to display a list of the built-in Spectre Console emojis.
Get-SpectreDemoEmoji -Count 5

## PARAMETERS

### -Count

Limit the number of emoji returned.
This is only really useful for generating the help docs.

```yaml
Type: System.Int32
DefaultValue: 0
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

Emoji support is dependent on the operating system, terminal, and font support.
For more information on Spectre Console markup and emojis, refer to the following links:
- Spectre Console Markup: https://spectreconsole.net/markup
- Spectre Console Emojis: https://spectreconsole.net/appendix/emojis


## RELATED LINKS

{{ Fill in the related links here }}

