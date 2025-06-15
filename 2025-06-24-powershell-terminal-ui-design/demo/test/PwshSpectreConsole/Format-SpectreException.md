---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/formatting/format-spectreexception/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Format-SpectreException
---

# Format-SpectreException

## SYNOPSIS

Formats an error record/exception into a Spectre Console Exception which supports syntax highlighting.

## SYNTAX

### __AllParameterSets

```
Format-SpectreException [-Exception] <Object> [[-ExceptionFormat] <string>]
 [[-ExceptionStyle] <hashtable>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Formats an error record/exception into a Spectre Console Exception which supports syntax highlighting.
 
See https://spectreconsole.net/exceptions for more information.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to format an exception into a Spectre Console Exception with syntax highlighting.
try {
    Get-ChildItem -BadParam -ErrorAction Stop
} catch {
    $_ | Format-SpectreException -ExceptionFormat ShortenEverything
}

### EXAMPLE 2

# **Example 2**
# This example uses custom formatting for the exception.
try {
    Get-ChildItem -BadParam -ErrorAction Stop
} catch {
    $_ | Format-SpectreException -ExceptionStyle @{
        Message        = "#00ff00"
        Exception      = "white"
        Method         = "#ff0000 on orange1"
        ParameterType  = "blue"
        ParameterName  = "silver"
        Parenthesis    = "silver"
        Path           = "Yellow"
        LineNumber     = "blue"
        Dimmed         = "grey"
        NonEmphasized  = "silver"
    }
}

## PARAMETERS

### -Exception

The error/exception object to format.

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

### -ExceptionFormat

The format to use when rendering the exception.
The default value is "Default".

```yaml
Type: System.String
DefaultValue: Default
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

### -ExceptionStyle

The style to use when rendering the exception provided as a hashtable.
e.g.

```
@{
    Message        = "red"
    Exception      = "white"
    Method         = "yellow"
    ParameterType  = "blue"
    ParameterName  = "silver"
    Parenthesis    = "silver"
    Path           = "Yellow"
    LineNumber     = "blue"
    Dimmed         = "grey"
    NonEmphasized  = "silver"
}
```

```yaml
Type: System.Collections.Hashtable
DefaultValue: >-
  @{
              Message        = "Red"
              Exception      = "White"
              Method         = [Spectre.Console.Color]::Pink3
              ParameterType  = "Grey69"
              ParameterName  = $script:DefaultValueColor
              Parenthesis    = $script:DefaultValueColor
              Path           = [Spectre.Console.Color]::Pink3
              LineNumber     = "Blue"
              Dimmed         = "Grey"
              NonEmphasized  = $script:DefaultValueColor
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

### System.Object

{{ Fill in the Description }}

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

