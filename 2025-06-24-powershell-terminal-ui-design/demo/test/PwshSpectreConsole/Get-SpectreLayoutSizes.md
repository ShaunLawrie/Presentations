---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/measurement/get-spectrelayoutsizes/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Get-SpectreLayoutSizes
---

# Get-SpectreLayoutSizes

## SYNOPSIS

Gets the width and height of all of the layouts in a Spectre Console Layout.

## SYNTAX

### __AllParameterSets

```
Get-SpectreLayoutSizes [-Layout] <Layout> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The Get-SpectreLayoutSizes function gets the height of a Spectre Console layout object and all of its children.
The result is a hashtable where you can access the size details for each layout object by its name.
 
When using sizes you need to be aware that this may include the size of the border if you specified one so you may need to subtract the border size from the total dimensions.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example calculates the heights of all the layouts in a layout tree and tells you how high the content layout will be based on their ratios.

$layout = New-SpectreLayout -Name "root" -Rows @(
    # Row 1
    (New-SpectreLayout -Name "title" -Ratio 1 -Data ("Title goes here" | Format-SpectrePanel -Expand)),
    # Row 2
    (New-SpectreLayout -Name "body" -Ratio 3 -Columns @(
        # Column 1
        (New-SpectreLayout -Name "left" -Ratio 1 -Data ("Left goes here" | Format-SpectrePanel -Expand)),
        # Column 2
        (New-SpectreLayout -Name "right" -Ratio 2 -Data ("Right goes here" | Format-SpectrePanel -Expand))
    ))
)

# Get the sizes of the layouts in the layout tree before populating them with data
$sizes = $layout | Get-SpectreLayoutSizes

# Subtract the border sizes!
$titleWidth = $sizes["title"].Width - 2
$titleHeight = $sizes["title"].Height - 2
$leftWidth = $sizes["left"].Width - 2
$leftHeight = $sizes["left"].Height - 2
$rightWidth = $sizes["right"].Width - 2
$rightHeight = $sizes["right"].Height - 2

# Populate the layouts with data that takes up the full height of the layout
$titleContent = ((1..($titleHeight + 1)) | ForEach-Object { "Title line $_" }) -join "`n"
$leftContent = ((1..($leftHeight + 1)) | ForEach-Object { "Left line $_" }) -join "`n"
$rightContent = ((1..($rightHeight + 1)) | ForEach-Object { "Right line $_" }) -join "`n"

$null = $layout["title"].Update(($titleContent | Format-SpectrePanel -Title "I am $titleWidth x $titleHeight" -Expand))
$null = $layout["left"].Update(($leftContent | Format-SpectrePanel -Title "I am $leftWidth x $leftHeight" -Expand))
$null = $layout["right"].Update(($rightContent | Format-SpectrePanel -Title "I am $rightWidth x $rightHeight" -Expand))

$layout | Out-SpectreHost

## PARAMETERS

### -Layout

The root layout to calculate the size for including all of its children.

```yaml
Type: Spectre.Console.Layout
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

### Spectre.Console.Layout

{{ Fill in the Description }}

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

