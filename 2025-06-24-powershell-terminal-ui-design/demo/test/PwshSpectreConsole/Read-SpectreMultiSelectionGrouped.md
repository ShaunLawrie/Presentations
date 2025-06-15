---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/prompts/read-spectremultiselectiongrouped/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Read-SpectreMultiSelectionGrouped
---

# Read-SpectreMultiSelectionGrouped

## SYNOPSIS

Displays a multi-selection prompt with grouped choices and returns the selected choices.

## SYNTAX

### __AllParameterSets

```
Read-SpectreMultiSelectionGrouped [[-Message] <string>] [-Choices] <array>
 [[-ChoiceLabelProperty] <string>] [[-Color] <Color>] [[-PageSize] <int>] [[-TimeoutSeconds] <int>]
 [-AllowEmpty] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Displays a multi-selection prompt with grouped choices and returns the selected choices.
The prompt allows the user to select one or more choices from a list of options.
The choices can be grouped into categories, and the user can select choices from each category.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates a multi-selection prompt with grouped choices.
$selected = Read-SpectreMultiSelectionGrouped -Message "Select your favorite colors" -PageSize 8 -Choices @(
    @{
        Name = "Primary Colors"
        Choices = @("Red", "Blue", "Yellow")
    },
    @{
        Name = "Secondary Colors"
        Choices = @("Green", "Orange", "Purple")
    }
)
# Type "↓", "<space>", "↓", "↓", "↓", "<space>", "↲" to choose red and all secondary colors
Write-SpectreHost "Your favourite colors are $($selected -join ', ')"

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

The name of the property to use as the label for each choice.
If this parameter is not specified, the choices are displayed as strings.

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

An array of choice groups.
Each group is a hashtable with two keys: "Name" and "Choices".
The "Name" key is a string that represents the name of the group, and the "Choices" key is an array of strings that represents the choices in the group.

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

The color of the selected choices.
The default value is the accent color of the script.

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
The default value is "What are your favourite [Spectre.Console.Color]?".

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
The default value is 10.

```yaml
Type: System.Int32
DefaultValue: 10
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

