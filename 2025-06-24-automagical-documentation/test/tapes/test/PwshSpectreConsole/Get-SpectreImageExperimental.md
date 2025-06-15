---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/images/get-spectreimageexperimental/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    text: New
    variant: tip
title: Get-SpectreImageExperimental
---

# Get-SpectreImageExperimental

## SYNOPSIS

Displays an image in the console using block characters and ANSI escape codes.

## SYNTAX

### __AllParameterSets

```
Get-SpectreImageExperimental [[-ImagePath] <string>] [[-ImageUrl] <uri>] [[-Width] <int>]
 [[-LoopCount] <int>] [[-Resampler] <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function loads an image from a file and displays it in the console using block characters and ANSI escape codes.
The image is scaled to fit within the specified maximum width while maintaining its aspect ratio.
If the image is an animated GIF, each frame is displayed in sequence.
 
The images rendered by this experimental function are not handled by Spectre Console, it's using a PowerShell script to render the image in a higher resolution than Spectre.Console does by using half-block characters.
:::danger
This has been deprecated and will be removed in PwshSpectreConsole v3.0.
 
:::

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to display an animated image in the console that loops 4 times.
Get-SpectreImageExperimental -ImagePath ".\private\images\harveyspecter.gif" -LoopCount 4 -Width 82

### EXAMPLE 2

# **Example 2**  
# This example demonstrates how to display a static image in the console.
Get-SpectreImageExperimental -ImagePath ".\private\images\smiley.png" -Width 80

## PARAMETERS

### -ImagePath

The path to the image file to display.

```yaml
Type: System.String
DefaultValue: ''
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

### -ImageUrl

The URL to the image file to display.
If specified, the image is downloaded to a temporary file and then displayed.

```yaml
Type: System.Uri
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

### -LoopCount

The number of times to repeat the animation.
The default value is 0, which means the animation will repeat forever.
Press ctrl-c to stop the animation.

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

### -Resampler

The resampling algorithm to use when scaling the image.
Valid values are "Bicubic" and "NearestNeighbor".
The default value is "Bicubic".

```yaml
Type: System.String
DefaultValue: Bicubic
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

### -Width

The width of the image in characters.
The image is scaled to fit within this width while maintaining its aspect ratio.

```yaml
Type: System.Int32
DefaultValue: 0
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

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

