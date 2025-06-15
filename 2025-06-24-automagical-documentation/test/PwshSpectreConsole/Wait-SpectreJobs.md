---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/live/wait-spectrejobs/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Wait-SpectreJobs
---

# Wait-SpectreJobs

## SYNOPSIS

Waits for Spectre jobs to complete.

## SYNTAX

### __AllParameterSets

```
Wait-SpectreJobs [-Context] <Object> [-Jobs] <array> [[-TimeoutSeconds] <int>]
 [[-EstimatedDurationSeconds] <int>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function waits for Spectre jobs to complete by checking the progress of each job and updating the corresponding task value.
Adapted from https://key2consulting.com/powershell-how-to-display-job-progress/
:::note
This is only used inside `Invoke-SpectreCommandWithProgress` where the Spectre ProgressContext object is exposed.
:::

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to add two jobs to a context and wait for them to complete.

Invoke-SpectreCommandWithProgress -ScriptBlock {
    param (
        $Context
    )
    $jobs = @()
    $jobs += Add-SpectreJob -Context $Context -JobName "job 1" -Job (Start-Job { Start-Sleep -Seconds 2 })
    $jobs += Add-SpectreJob -Context $Context -JobName "job 2" -Job (Start-Job { Start-Sleep -Seconds 4 })
    Wait-SpectreJobs -Context $Context -Jobs $jobs
}

## PARAMETERS

### -Context

The Spectre progress context object.
[https://spectreconsole.net/api/spectre.console/progresscontext/](https://spectreconsole.net/api/spectre.console/progresscontext/)

```yaml
Type: System.Object
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

### -EstimatedDurationSeconds

The estimated duration of the jobs in seconds.
This is used to calculate the progress of the jobs if the job progress is not available.

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

### -Jobs

An array of Spectre jobs which are decorated PowerShell jobs.

```yaml
Type: System.Array
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TimeoutSeconds

The maximum number of seconds to wait for the jobs to complete.
Defaults to 60 seconds.

```yaml
Type: System.Int32
DefaultValue: 60
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

