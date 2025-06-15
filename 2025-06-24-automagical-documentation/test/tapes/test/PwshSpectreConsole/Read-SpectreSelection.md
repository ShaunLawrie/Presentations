---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/prompts/read-spectreselection/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    text: New
    variant: tip
title: Read-SpectreSelection
---

# Read-SpectreSelection

## SYNOPSIS

Displays a selection prompt using Spectre Console.

## SYNTAX

### __AllParameterSets

```
Read-SpectreSelection [[-Message] <string>] [-Choices] <array> [[-ChoiceLabelProperty] <string>]
 [[-Color] <Color>] [[-PageSize] <int>] [[-TimeoutSeconds] <int>] [[-SearchHighlightColor] <Color>]
 [-EnableSearch] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function displays a selection prompt using Spectre Console.
The user can select an option from the list of choices provided.
The function returns the selected option.
 
With the `-EnableSearch` switch, the user can search for choices in the selection prompt by typing the characters instead of just typing up and down arrows.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates a selection prompt with a custom title and choices.
$color = Read-SpectreSelection -Message "Select your favorite color" -Choices @("Red", "Green", "Blue") -Color "Green"
# Type "↓", "↓", "↓", "↓", "↲" to wrap around the list and choose green
Write-SpectreHost "Your chosen color is '$color'"

### EXAMPLE 2

# **Example 2**  
# This example demonstrates a selection prompt with a custom title and choices, and search enabled.
$color = Read-SpectreSelection -Message "Select your favorite color" -Choices @("Blue", "Bluer", "Blue-est") -EnableSearch
# Type "b", "l", "u", "e", "r", "↲" to choose "Bluer"
Write-SpectreHost "Your chosen color is '$color'"

## PARAMETERS

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

The color of the selected option in the selection prompt.

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

### -EnableSearch

If this switch is present, the user can search for choices in the selection prompt by typing the characters instead of just typing up and down arrows.

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

The title of the selection prompt.

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

The number of choices to display per page in the selection prompt.

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

### -SearchHighlightColor

The color of the search highlight in the selection prompt.
Defaults to a slightly brighter version of the accent color.

```yaml
Type: Spectre.Console.Color
DefaultValue: $script:AccentColor.Blend([Spectre.Console.Color]::White, 0.7)
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 6
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

