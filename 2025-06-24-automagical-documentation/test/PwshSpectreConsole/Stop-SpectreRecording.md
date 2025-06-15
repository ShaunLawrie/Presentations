---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/config/stop-spectrerecording/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Stop-SpectreRecording
---

# Stop-SpectreRecording

## SYNOPSIS

Stops a recording of the current console output and returns the recording.

## SYNTAX

### __AllParameterSets

```
Stop-SpectreRecording [[-Title] <string>] [[-OutputPath] <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Stops a recording of the current console output and returns the recording.
 
I've used this to record the examples on the docs help site.
:::caution
This is experimental.
 
Experimental features are unstable and subject to change.
:::

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to record the spectre console output.
$recording = Start-SpectreRecording -RecordingType "Html" -CountdownAndClear
# Use spectre console functions, these will be recorded
Write-SpectreHost "Hello [red]world[/]"
# Finish the recording
$result = Stop-SpectreRecording
# Output the results
Write-SpectreHost "Result:`n$result"

## PARAMETERS

### -OutputPath

The path to save the recording to.

```yaml
Type: System.String
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

### -Title

The title of the recording, only used for asciinema recordings.

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

