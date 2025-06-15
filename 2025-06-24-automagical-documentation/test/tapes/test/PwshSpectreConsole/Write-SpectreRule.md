---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/writing/write-spectrerule/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    text: New
    variant: tip
title: Write-SpectreRule
---

# Write-SpectreRule

## SYNOPSIS

Writes a Spectre horizontal-rule to the console.

## SYNTAX

### Default (Default)

```
Write-SpectreRule [[-Title] <string>] [-Alignment <string>] [-Color <Color>] [-LineColor <Color>]
 [-PassThru] [<CommonParameters>]
```

### PercentWidth

```
Write-SpectreRule [[-Title] <string>] [-Alignment <string>] [-Color <Color>] [-LineColor <Color>]
 [-WidthPercent <int>] [-PassThru] [<CommonParameters>]
```

### FixedWidth

```
Write-SpectreRule [[-Title] <string>] [-Alignment <string>] [-Color <Color>] [-LineColor <Color>]
 [-Width <int>] [-PassThru] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The Write-SpectreRule function writes a Spectre horizontal-rule to the console with the specified title, alignment, and color.
You can control the width of the rule by specifying either the Width or WidthPercent parameter.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to write a rule to the console.
Write-SpectreRule -Title "My Rule" -Alignment Center -Color Yellow

### EXAMPLE 2

# **Example 2**  
# This example demonstrates how to write a rule with a specific width.
Write-SpectreRule -Title "Fixed Width Rule" -Width 40

### EXAMPLE 3

# **Example 3**  
# This example demonstrates how to write a rule with a width that's a percentage of the console width.
Write-SpectreRule -Title "Half Width Rule" -WidthPercent 50 -Alignment Center

### EXAMPLE 4

# **Example 4**
# This example demonstrates writing a rule by directly providing the title text.
Write-SpectreRule "Simple Rule Title"

## PARAMETERS

### -Alignment

The alignment of the text in the rule.
The default value is Left.

```yaml
Type: System.String
DefaultValue: Left
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

### -Color

The color of the rule.
The default value is the accent color of the script.

```yaml
Type: Spectre.Console.Color
DefaultValue: $script:AccentColor
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

### -LineColor

The color of the rule's line.
The default value is the default value color of the script.

```yaml
Type: Spectre.Console.Color
DefaultValue: $script:DefaultValueColor
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

### -PassThru

Returns the Spectre Rule object instead of writing it to the console.

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

### -Title

The title of the rule.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: PercentWidth
  Position: 0
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: FixedWidth
  Position: 0
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Default
  Position: 0
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Width

The width of the rule in characters.
If not specified, the rule will span the full width of the console.
Cannot be used together with WidthPercent.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: FixedWidth
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WidthPercent

The width of the rule as a percentage of the console width.
Value must be between 1 and 100.
Cannot be used together with Width.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: PercentWidth
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

### System.String

{{ Fill in the Description }}

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

