---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/measurement/get-spectrerenderablesize/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Get-SpectreRenderableSize
---

# Get-SpectreRenderableSize

## SYNOPSIS

Gets the width and height of a Spectre Console widget.

## SYNTAX

### __AllParameterSets

```
Get-SpectreRenderableSize [-Renderable] <Renderable> [[-ContainerHeight] <int>]
 [[-ContainerWidth] <int>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The Get-SpectreRenderableSize function gets the height of a Spectre Console renderable object.
The width and height is estimated.
 
This method of size calculation is not perfect, but it is a good approximation for most use cases.
There are factors outside of the control of this function that can affect the size of the widget once it's rendered to the console.
 
The size of a containing object can influence the size of the widget when it's expandable.
If you know the width and height of a container that this widget will be rendered inside you can provide that as a parameter to get a more accurate size.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example calculates the height of a small panel
$panel = "hello`nworld" | Format-SpectrePanel
$panelSize = $panel | Get-SpectreRenderableSize
Write-SpectreHost "Panel width: $($panelSize.Width), height: $($panelSize.Height)"
$panel | Out-SpectreHost

## PARAMETERS

### -ContainerHeight

The height of the container that the widget will be rendered inside.

```yaml
Type: System.Int32
DefaultValue: '[Spectre.Console.AnsiConsole]::Console.Profile.Height'
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

### -ContainerWidth

The width of the container that the widget will be rendered inside.

```yaml
Type: System.Int32
DefaultValue: '[Spectre.Console.AnsiConsole]::Console.Profile.Width'
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

### -Renderable

The widget to calculate the size of.

```yaml
Type: Spectre.Console.Rendering.Renderable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
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

### Spectre.Console.Rendering.Renderable

{{ Fill in the Description }}

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

