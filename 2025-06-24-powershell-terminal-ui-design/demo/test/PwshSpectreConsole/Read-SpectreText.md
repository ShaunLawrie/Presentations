---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/prompts/read-spectretext/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Read-SpectreText
---

# Read-SpectreText

## SYNOPSIS

Prompts the user with a question and returns the user's input.

## SYNTAX

### __AllParameterSets

```
Read-SpectreText [-Message] <string> [[-DefaultAnswer] <string>] [[-AnswerColor] <Color>]
 [[-TimeoutSeconds] <int>] [[-Choices] <string[]>] [-AllowEmpty] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function uses Spectre Console to prompt the user with a question and returns the user's input.
:::caution
I would advise against this and instead use `Read-Host` because the Spectre Console prompt doesn't have access to the PowerShell session history.
 
Without session history you can't use the up and down arrow keys to navigate through your previous commands.
This text entry also doesn't allow you to use arrow keys to go back and forwards through the text you're entering.
:::

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates a simple text prompt with a default answer.
$name = Read-SpectreText -Message "What's your name?" -DefaultAnswer "Prefer not to say"
# Type "↲" to provide no answer
Write-SpectreHost "Your name is '$name'"

### EXAMPLE 2

# **Example 2**  
# This example demonstrates a simple text prompt with a default answer and a color.
$favouriteColor = Read-SpectreText -Message "What's your favorite color?" -DefaultAnswer "pink"
# Type "orange", "↲" to enter your favourite color
Write-SpectreHost "Your favourite color is '$favouriteColor'"

### EXAMPLE 3

# **Example 3**  
# This example demonstrates a simple text prompt with a default answer, a color, and a list of choices.
$favouriteColor = Read-SpectreText -Message "What's your favorite color?" -AnswerColor "Cyan1" -Choices "Black", "Green", "Magenta", "I'll never tell!"
# Type "orange", "↲", "magenta", "↲" to enter text that must match a choice in the choices list, orange will be rejected, magenta will be accepted
Write-SpectreHost "Your favourite color is '$favouriteColor'"

## PARAMETERS

### -AllowEmpty

If specified, the user can provide an empty answer.

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

### -AnswerColor

The color of the user's answer input.
The default behaviour uses the standard terminal text color.

```yaml
Type: Spectre.Console.Color
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

### -Choices

An array of choices that the user can choose from.
If specified, the user will be prompted with a list of choices to choose from, with validation.
With autocomplete and can tab through the choices.

```yaml
Type: System.String[]
DefaultValue: ''
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

### -DefaultAnswer

The default answer if the user does not provide any input.

```yaml
Type: System.String
DefaultValue: ''
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

The question to prompt the user with.

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
  Position: 3
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

