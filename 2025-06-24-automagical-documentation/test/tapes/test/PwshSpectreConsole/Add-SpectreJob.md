---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/live/add-spectrejob/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    text: New
    variant: tip
title: Add-SpectreJob
---

# Add-SpectreJob

## SYNOPSIS

Adds a Spectre job to a list of jobs.

## SYNTAX

### __AllParameterSets

```
Add-SpectreJob [-Context] <ProgressContext> [-JobName] <string> [-Job] <Job> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function adds a Spectre job to the list of jobs you want to wait for with Wait-SpectreJobs.
 
To retrieve the outcome of the job you need to use the standard PowerShell Receive-Job cmdlet.
:::note
This is only used inside `Invoke-SpectreCommandWithProgress` where the Spectre ProgressContext object is exposed.
:::

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to add two jobs to a context and wait for them to complete.

$jobOutcomes = Invoke-SpectreCommandWithProgress -ScriptBlock {
    param (
        [Spectre.Console.ProgressContext] $Context
    )
    $jobs = @()
    $jobs += Add-SpectreJob -Context $Context -JobName "job 1" -Job (Start-Job { Start-Sleep -Seconds 2 })
    $jobs += Add-SpectreJob -Context $Context -JobName "job 2" -Job (Start-Job { Start-Sleep -Seconds 4 })
    Wait-SpectreJobs -Context $Context -Jobs $jobs
    return $jobs.Job
}
$jobOutcomes | Format-SpectreTable -Property Id, Name, PSJobTypeName, State, Command

## PARAMETERS

### -Context

The Spectre context to add the job to.
The context object is only available inside Invoke-SpectreCommandWithProgress.
[https://spectreconsole.net/api/spectre.console/progresscontext/](https://spectreconsole.net/api/spectre.console/progresscontext/)

```yaml
Type: Spectre.Console.ProgressContext
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

### -Job

The PowerShell job to add to the context.

```yaml
Type: System.Management.Automation.Job
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

### -JobName

The name of the job to add.

```yaml
Type: System.String
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

