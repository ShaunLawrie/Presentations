---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/writing/out-spectrehost/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    variant: tip
    text: New
title: Out-SpectreHost
---

# Out-SpectreHost

## SYNOPSIS

Writes a spectre renderable to the console host.

## SYNTAX

### __AllParameterSets

```
Out-SpectreHost [-Data] <Object> [-CustomItemFormatter] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Out-SpectreHost writes a spectre renderable object to the console host.
 
This function is used to output spectre renderables to the console when you want to avoid the additional newlines that the PowerShell formatter adds.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to write a spectre renderable object to the console host.
$table = Get-ChildItem | Select-Object Name, Length, LastWriteTime | Format-SpectreTable
$table | Out-SpectreHost

## PARAMETERS

### -CustomItemFormatter

The default host customitem formatter has some restrictions, it needs to be one char less wide than when outputting to the standard console or it will wrap.

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

### -Data

The data to write to the console.

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

