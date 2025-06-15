---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/writing/write-spectrefiglettext/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    text: New
    variant: tip
title: Write-SpectreFigletText
---

# Write-SpectreFigletText

## SYNOPSIS

Writes a Spectre Console Figlet text to the console.

## SYNTAX

### __AllParameterSets

```
Write-SpectreFigletText [[-Text] <string>] [[-Alignment] <string>] [[-Color] <Color>]
 [[-FigletFontPath] <string>] [-PassThru] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function writes a Spectre Console Figlet text to the console.
The text can be aligned to the left, right, or center, and can be displayed in a specified color.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to write Figlet text to the console.
Write-SpectreFigletText -Text "Hello Spectre!" -Alignment "Center" -Color "Red"

### EXAMPLE 2

# **Example 2**  
# This example demonstrates how to write Figlet text to the console using a custom Figlet font.
Write-SpectreFigletText -Text "Whoa?!" -FigletFontPath "..\PwshSpectreConsole.Docs\src\assets\3d.flf"

## PARAMETERS

### -Alignment

The alignment of the text.
The default value is "Left".

```yaml
Type: System.String
DefaultValue: Left
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

### -Color

The color of the text.
The default value is the accent color of the script.

```yaml
Type: Spectre.Console.Color
DefaultValue: $script:AccentColor
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

### -FigletFontPath

The path to the Figlet font file to use.
If this parameter is not specified, the default built-in Figlet font is used.
The figlet font format is usually *.flf, see https://spectreconsole.net/widgets/figlet for more.

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

### -PassThru

Returns the Spectre Figlet text object instead of writing it to the console.

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

### -Text

The text to display in the Figlet format.

```yaml
Type: System.String
DefaultValue: Hello Spectre!
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

## RELATED LINKS

{{ Fill in the related links here }}

