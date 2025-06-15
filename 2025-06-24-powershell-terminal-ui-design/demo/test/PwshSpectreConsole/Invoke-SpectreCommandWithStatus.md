---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/live/invoke-spectrecommandwithstatus/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Invoke-SpectreCommandWithStatus
---

# Invoke-SpectreCommandWithStatus

## SYNOPSIS

Invokes a script block with a Spectre status spinner.

## SYNTAX

### __AllParameterSets

```
Invoke-SpectreCommandWithStatus [-ScriptBlock] <scriptblock> [[-Spinner] <string>] [-Title] <string>
 [[-Color] <Color>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function starts a Spectre status spinner with the specified title and spinner type, and invokes the specified script block.
The spinner will continue to spin until the script block completes.
 
See https://spectreconsole.net/live/status for more information.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to show a spinner while doing some work. Write-SpectreHost is used to update the host with progress without breaking the spinner animation.

$result = Invoke-SpectreCommandWithStatus -Spinner "Dots2" -Title "Showing a spinner..." -ScriptBlock {
    # Write updates to the host using Write-SpectreHost
    Start-Sleep -Seconds 1
    Write-SpectreHost "`n[grey]LOG:[/] Doing some work      "
    Start-Sleep -Seconds 1
    Write-SpectreHost "`n[grey]LOG:[/] Doing some more work "
    Start-Sleep -Seconds 1
    Write-SpectreHost "`n[grey]LOG:[/] Done                 "
    Start-Sleep -Seconds 1
    Write-SpectreHost " "
    return "Some result"
}
Write-SpectreHost "Result: $result"

## PARAMETERS

### -Color

The color of the spinner.
Valid values can be found with Get-SpectreDemoColors.

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

### -ScriptBlock

The script block to invoke.

```yaml
Type: System.Management.Automation.ScriptBlock
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Spinner

The type of spinner to display.

```yaml
Type: System.String
DefaultValue: Dots
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

### -Title

The title to display above the spinner.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
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

