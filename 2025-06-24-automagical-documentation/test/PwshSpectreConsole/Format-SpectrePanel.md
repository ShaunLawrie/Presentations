---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/formatting/format-spectrepanel/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Format-SpectrePanel
---

# Format-SpectrePanel

## SYNOPSIS

Formats a string as a Spectre Console panel with optional title, border, and color.

## SYNTAX

### __AllParameterSets

```
Format-SpectrePanel [-Data] <Object> [[-Header] <string>] [[-Border] <string>] [[-Color] <Color>]
 [[-Width] <int>] [[-Height] <int>] [-Expand] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function takes a string and formats it as a Spectre Console panel with optional title, border, and color.
The resulting panel can be displayed in the console using the Write-Host command.
 
This function takes a string or renderable object and formats it as a Spectre Console panel with optional title, border, and color.
The resulting panel can be displayed in the console using the Write-Host command.
 

:::note  
A panel can only contain a single renderable object.
To combine multiple items (such as text and images) in one panel, you'll need to wrap them in a container like Format-SpectreRows or Format-SpectreColumns first.
Without this wrapping, Format-SpectrePanel will render each item in a separate panel.
:::  

See https://spectreconsole.net/widgets/panel for more information.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to display a panel with a title and a rounded border.
Format-SpectrePanel -Data "Hello, world!" -Title "My Panel" -Border "Rounded" -Color "Red"

### EXAMPLE 2

# **Example 2**  
# This example demonstrates how to display a panel with a title and a double border that's expanded to take up the whole console width.
"Hello, big panel!" | Format-SpectrePanel -Title "My Big Panel" -Border "Double" -Color "Magenta1" -Expand

### EXAMPLE 3

# **Example 3**  
# This example demonstrates how to combine text and images in a single panel.
# When combining multiple items in a panel, use Format-SpectreRows or Format-SpectreColumns to wrap them into a single renderable object.
$message = "Thanks Jeff!"
$image = Get-SpectreImage -ImagePath ".\private\images\smiley.png" -MaxWidth 25
@($message, $image) | Format-SpectreRows | Format-SpectrePanel

### EXAMPLE 4

# **Example 4**  
# This example demonstrates how to combine text and images in a single panel with side-by-side layout.
$message = "Thanks Jeff!"
$image = Get-SpectreImage -ImagePath ".\private\images\smiley.png" -MaxWidth 25  
@($message, $image) | Format-SpectreColumns | Format-SpectrePanel

## PARAMETERS

### -Border

The type of border to be displayed around the panel.

```yaml
Type: System.String
DefaultValue: Rounded
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

### -Color

The color of the panel border.

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

### -Data

The renderable item to be formatted as a panel.

```yaml
Type: System.Object
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

### -Expand

Switch parameter that specifies whether the panel should be expanded to fill the available space.

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

### -Header

The title to be displayed at the top of the panel.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Title
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

### -Height

The height of the panel.

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

### -Width

The width of the panel.

```yaml
Type: System.Int32
DefaultValue: 0
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

{{ Fill in the Description }}

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

