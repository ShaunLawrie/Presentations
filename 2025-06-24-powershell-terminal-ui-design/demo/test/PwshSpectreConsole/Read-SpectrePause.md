---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/prompts/read-spectrepause/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Read-SpectrePause
---

# Read-SpectrePause

## SYNOPSIS

Pauses the script execution and waits for user input to continue.

## SYNTAX

### __AllParameterSets

```
Read-SpectrePause [[-Message] <string>] [-AnyKey] [-NoNewline] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The Read-SpectrePause function pauses the script execution and waits for user input to continue.
It displays a message prompting the user to press the enter key to continue.
If the end of the console window is reached, the function clears the message and moves the cursor up to the previous line.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to use the Read-SpectrePause function.
Read-SpectrePause -Message "Press the [red]enter[/] key to continue, when you press it this message will disappear..."
# Type "↲" to dismiss the message

### EXAMPLE 2

# **Example 2**  
# This example demonstrates how to use the Read-SpectrePause function with the AnyKey parameter.
Read-SpectrePause -Message "Press the [red]ANY[/] key to continue, when you press it this message will disappear..." -AnyKey
# Type "x" to dismiss the message

## PARAMETERS

### -AnyKey

{{ Fill AnyKey Description }}

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

### -Message

The message to display to the user.
The default message is "[default value color]Press [accent color]enter[/] to continue[/]".

```yaml
Type: System.String
DefaultValue: '"[$($script:DefaultValueColor.ToMarkup())]Press [$($script:AccentColor.ToMarkup())]<enter>[/] to continue[/]"'
SupportsWildcards: false
Aliases:
- Title
- Question
- Prompt
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

### -NoNewline

Indicates whether to write a newline character before displaying the message.
By default, a newline character is written.

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

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

