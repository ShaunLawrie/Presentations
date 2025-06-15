---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/prompts/read-spectremultiselection/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Read-SpectreMultiSelection
---

# Read-SpectreMultiSelection

## SYNOPSIS

Displays a multi-selection prompt using Spectre Console and returns the selected choices.

## SYNTAX

### __AllParameterSets

```
Read-SpectreMultiSelection [[-Message] <string>] [-Choices] <array>
 [[-ChoiceLabelProperty] <string>] [[-Color] <Color>] [[-PageSize] <int>] [[-TimeoutSeconds] <int>]
 [-AllowEmpty] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function displays a multi-selection prompt using Spectre Console and returns the selected choices.
The prompt allows the user to select one or more choices from a list of options.
The function supports customizing the title, choices, choice label property, color, and page size of the prompt.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates a multi-selection prompt with a custom title and choices.
$fruits = Read-SpectreMultiSelection -Message "Select your favourite fruits" `
                                      -Choices @("apple", "banana", "orange", "pear", "strawberry", "durian", "lemon") `
                                      -PageSize 4
# Type "↓", "<space>", "↓", "↓", "<space>", "↓", "<space>", "↲" to choose banana, pear and strawberry
Write-SpectreHost "Your favourite fruits are $($fruits -join ', ')"

## PARAMETERS

### -AllowEmpty

Allow the multi-selection to be submitted without any options chosen.

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

### -ChoiceLabelProperty

If the object is complex then the property of the choice object to use as the label in the selection prompt is required.

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

### -Choices

The list of choices to display in the selection prompt.
ChoiceLabelProperty is required if the choices are complex objects rather than an array of strings.

```yaml
Type: System.Array
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Color

The color to use for highlighting the selected choices.
Defaults to the accent color of the script.

```yaml
Type: Spectre.Console.Color
DefaultValue: $script:AccentColor
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

### -Message

The title of the prompt.
Defaults to "What are your favourite [Spectre.Console.Color]?".

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
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PageSize

The number of choices to display per page.
Defaults to 5.

```yaml
Type: System.Int32
DefaultValue: 5
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

### -TimeoutSeconds

{{ Fill TimeoutSeconds Description }}

```yaml
Type: System.Int32
DefaultValue: 0
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

