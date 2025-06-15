---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/prompts/read-spectreconfirm/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    text: New
    variant: tip
title: Read-SpectreConfirm
---

# Read-SpectreConfirm

## SYNOPSIS

Displays a simple confirmation prompt with the option of selecting yes or no and returns a boolean representing the answer.

## SYNTAX

### __AllParameterSets

```
Read-SpectreConfirm [-Message] <string> [[-DefaultAnswer] <string>] [[-ConfirmSuccess] <string>]
 [[-ConfirmFailure] <string>] [[-TimeoutSeconds] <int>] [[-Color] <Color>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Displays a simple confirmation prompt with the option of selecting yes or no.
Additional options are provided to display either a success or failure response message in addition to the boolean return value.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates a simple confirmation prompt with a success message.
$answer = Read-SpectreConfirm -Message "Would you like to continue the preview installation of [#7693FF]PowerShell 7?[/]" `
                              -ConfirmSuccess "Woohoo! The internet awaits your elite development contributions." `
                              -ConfirmFailure "What kind of monster are you? How could you do this?"
# Type "y", "↲" to accept the prompt
Write-Host "Your answer was '$answer'"

## PARAMETERS

### -Color

{{ Fill Color Description }}

```yaml
Type: Spectre.Console.Color
DefaultValue: $script:AccentColor
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 5
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ConfirmFailure

The text and markup to display if the user chooses no.
If left undefined, nothing will display.

```yaml
Type: System.String
DefaultValue: ''
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

### -ConfirmSuccess

The text and markup to display if the user chooses yes.
If left undefined, nothing will display.

```yaml
Type: System.String
DefaultValue: ''
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

### -DefaultAnswer

The default answer to the prompt if the user just presses enter.
The default value is "y".

```yaml
Type: System.String
DefaultValue: y
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

### -Message

The prompt to display to the user.
The default value is "Do you like cute animals?".

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Title
- Question
- Prompt
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

### -TimeoutSeconds

{{ Fill TimeoutSeconds Description }}

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
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

