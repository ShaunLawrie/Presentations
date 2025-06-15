---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/formatting/new-spectrelayout/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    text: New
    variant: tip
title: New-SpectreLayout
---

# New-SpectreLayout

## SYNOPSIS

Creates a new Spectre Layout object.

## SYNTAX

### Data

```
New-SpectreLayout [-Data <Object>] [-Ratio <int>] [-Name <string>] [-MinimumSize <int>]
 [<CommonParameters>]
```

### Columns

```
New-SpectreLayout -Columns <array> [-Ratio <int>] [-Name <string>] [-MinimumSize <int>]
 [<CommonParameters>]
```

### Rows

```
New-SpectreLayout -Rows <array> [-Ratio <int>] [-Name <string>] [-MinimumSize <int>]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The New-SpectreLayout function creates a new Spectre Layout object with the specified data, columns, or rows.
This function is used to create a layout object that can be used to split the console into multiple sections.
 
You can only have either rows OR columns in a layout and can compose layouts of layouts to create complex layouts.
 

:::note  
If you need to know the size of the layout panels you can use the [`Get-SpectreLayoutSizes`](https://pwshspectreconsole.com/reference/measurement/get-spectrelayoutsizes/) function.
 
:::  

See https://spectreconsole.net/widgets/layout for more information.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to create a layout with a calendar, a list of files, and a panel with a calendar aligned to the middle and center.
$calendar = Write-SpectreCalendar -Date (Get-Date) -PassThru
$files = Get-ChildItem | Select-Object Name, LastWriteTime -First 3 | Format-SpectreTable | Format-SpectreAligned -HorizontalAlignment Right -VerticalAlignment Bottom

$panel1 = $files | Format-SpectrePanel -Header "panel 1 (align bottom right)" -Expand -Color Green
$panel2 = "hello row 2" | Format-SpectrePanel -Header "panel 2" -Expand -Color Blue
$panel3 = $calendar | Format-SpectreAligned | Format-SpectrePanel -Header "panel 3 (align middle center)" -Expand -Color Yellow

$row1 = New-SpectreLayout -Name "row1" -Data $panel1 -Ratio 1
$row2 = New-SpectreLayout -Name "row2" -Columns @($panel2, $panel3) -Ratio 2
$root = New-SpectreLayout -Name "root" -Rows @($row1, $row2)

$root | Out-SpectreHost

## PARAMETERS

### -Columns

The columns to be displayed in the layout.

```yaml
Type: System.Array
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Columns
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Data

The data to be displayed in the layout.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Data
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MinimumSize

The minimum size of the layout, this can be used to ensure a layout is at least the minimum width.

```yaml
Type: System.Int32
DefaultValue: 1
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

### -Name

The name of the layout, this is used when you want to access one of the layouts in a nested layout to update the contents.
 
e.g.
in the example below to update the contents of row1 you would use `$root = $root["row1"].Update(("hello row 1 again" | Format-SpectrePanel))`

```yaml
Type: System.String
DefaultValue: ''
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

### -Ratio

The ratio of the layout, when composing layouts of layouts you can use a higher ratio in one layout to make it larger than the other layouts.

```yaml
Type: System.Int32
DefaultValue: 1
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

### -Rows

The rows to be displayed in the layout.

```yaml
Type: System.Array
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Rows
  Position: Named
  IsRequired: true
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

