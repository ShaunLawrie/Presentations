---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/live/invoke-spectrescriptblockquietly/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Invoke-SpectreScriptBlockQuietly
---

# Invoke-SpectreScriptBlockQuietly

## SYNOPSIS

This is a test function for invoking a script block in a background job inside Invoke-SpectreCommandWithProgress to help with https://github.com/ShaunLawrie/PwshSpectreConsole/issues/7  
Some commands cause output that interferes with the progress bar, this function is an attempt to suppress that output when all other attempts have failed.

## SYNTAX

### __AllParameterSets

```
Invoke-SpectreScriptBlockQuietly [[-Command] <scriptblock>] [[-Level] <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function invokes a script block in a background job and returns the output.
It also provides an option to suppress the output even more if there is garbage being printed to stderr if using Level = Quieter.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to use this function to suppress all output from a script block so it doesn't break the progress bar.

$result = Invoke-SpectreCommandWithProgress {
    param (
        $Context
    )
    $task1 = $Context.AddTask("Starting a process that generates noise")
    $task1.Increment(50)
    $value = Invoke-SpectreScriptBlockQuietly -Level Quiet -Command {
        Write-Output "Things..."
        Write-Output "And stuff..."
        Write-Error "This is an error"
        Start-Sleep -Seconds 3
        Write-Output "But it shouldn't break progress bar rendering"
    }
    $task1.Increment(50)
    return $value
}
Write-SpectreHost "Result: $result"

## PARAMETERS

### -Command

The script block to be invoked.

```yaml
Type: System.Management.Automation.ScriptBlock
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

### -Level

Suppresses the output by varying amounts.

```yaml
Type: System.String
DefaultValue: Quiet
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

