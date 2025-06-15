---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/images/get-spectreimage/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Get-SpectreImage
---

# Get-SpectreImage

## SYNOPSIS

Displays an image in the console using CanvasImage or SixelImage if the terminal supports Sixel.

## SYNTAX

### __AllParameterSets

```
Get-SpectreImage [-ImagePath] <string> [[-MaxWidth] <int>] [[-Format] <string>] [-Force]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Displays an image in the console using CanvasImage or SixelImage if the terminal supports Sixel.
The image can be resized to a maximum width if desired.

Windows Terminal supports Sixel in the [latest preview builds](https://apps.microsoft.com/detail/9n8g5rfz9xk3) so it will be available in the production builds soon 🤞
See https://www.arewesixelyet.com/ for Sixel support status for your terminal.

## EXAMPLES

### EXAMPLE 1

# **Example 1**
# When Sixel is not supported the image will use the standard Canvas renderer which draws the image using character cells to represent the image.
Get-SpectreImage -ImagePath ".\private\images\smiley.png" -MaxWidth 40

### EXAMPLE 2

# **Example 2**
# For Sixel images, the image returned by `Get-SpectreImage` will render a new frame every time it's drawn so if it's an animated GIF it will appear animated if you render it repeatedly and move the cursor back to the same start position before each image output.
#
# ![Spectre Sixel Example](/lapras-terminal.gif)
#
NORECORDING
$image = Get-SpectreImage ".\private\images\lapras-pokemon.gif" -MaxWidth 50

Clear-Host
[Console]::CursorVisible = $false

for($frame = 0; $frame -lt 100; $frame++) {
    [Console]::SetCursorPosition(0, 0)
    $image | Format-SpectrePanel -Title "Frame: $frame" -Color White | Out-SpectreHost
    Start-Sleep -Milliseconds 150
}

## PARAMETERS

### -Force

Forces the image to be displayed using the specified format, even if we can't detect Sixel support in the terminal.

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

### -Format

The preferred format to use when rendering the image.
If not specified, the image will be rendered using Sixel if the terminal supports it, otherwise it will use Canvas.

```yaml
Type: System.String
DefaultValue: Auto
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

### -ImagePath

The path to the image file to be displayed, as a local path or remote path using http/https.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Uri
- FullName
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MaxWidth

The maximum width of the image.
If not specified, the image will be displayed at its original size.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases:
- Width
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
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

### System.Int32

{{ Fill in the Description }}

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

