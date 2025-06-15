---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/config/start-spectrerecording/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    text: New
    variant: tip
title: Start-SpectreRecording
---

# Start-SpectreRecording

## SYNOPSIS

Starts a recording of the current console output. This can be used to record a demo of a script or module.

## SYNTAX

### __AllParameterSets

```
Start-SpectreRecording [[-Width] <int>] [[-Height] <int>] [[-RecordingType] <string>]
 [-CountdownAndClear] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Starts a recording of the current console output.
This can be used to record all of the spectre console interactions in a PowerShell session.
 
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

### -CountdownAndClear

If this switch is present, the console will be cleared and a countdown will be displayed before the recording starts.

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

### -Height

The height of the recording.

```yaml
Type: System.Int32
DefaultValue: (Get-HostHeight)
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

### -RecordingType

The type of recording to create.

```yaml
Type: System.String
DefaultValue: asciinema
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

### -Width

The width of the recording.

```yaml
Type: System.Int32
DefaultValue: (Get-HostWidth)
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

