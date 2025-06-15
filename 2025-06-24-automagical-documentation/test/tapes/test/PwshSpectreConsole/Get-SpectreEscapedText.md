---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/writing/get-spectreescapedtext/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    text: New
    variant: tip
title: Get-SpectreEscapedText
---

# Get-SpectreEscapedText

## SYNOPSIS

Escapes text for use in Spectre Console.
[ShaunLawrie/PwshSpectreConsole/issues/5](https://github.com/ShaunLawrie/PwshSpectreConsole/issues/5)

## SYNTAX

### __AllParameterSets

```
Get-SpectreEscapedText [-Text] <string> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function escapes text for use where Spectre Console accepts markup.
It is intended to be used as a helper function for other functions that output text to the console using Spectre Console which contains special characters that need escaping.
See [https://spectreconsole.net/markup](https://spectreconsole.net/markup) for more information about the markup language used in Spectre Console.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to escape text for use in Spectre Console.
$data = "][[][red]]][[/][][]["
Format-SpectrePanel -Title "Unescaped data" -Data "I want escaped $($data | Get-SpectreEscapedText) [yellow]and[/] [red]unescaped[/] data"

## PARAMETERS

### -Text

The text to be escaped.

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

