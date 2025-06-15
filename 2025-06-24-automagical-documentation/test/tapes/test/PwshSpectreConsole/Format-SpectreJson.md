---
document type: cmdlet
external help file: PwshSpectreConsole-Help.xml
HelpUri: https://pwshspectreconsole.com/reference/formatting/format-spectrejson/
Locale: en-US
Module Name: PwshSpectreConsole
ms.date: 06/09/2025
PlatyPS schema version: 2024-05-01
sidebar:
  badge:
    text: New
    variant: tip
title: Format-SpectreJson
---

# Format-SpectreJson

## SYNOPSIS

Formats an array of objects into a Spectre Console Json.

## SYNTAX

### __AllParameterSets

```
Format-SpectreJson [-Data] <Object> [[-Depth] <int>] [[-Border] <string>] [[-Color] <string>]
 [[-Title] <string>] [[-Width] <int>] [[-Height] <int>] [[-JsonStyle] <hashtable>] [-NoBorder]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

This function takes an objects and converts them into syntax highlighted Json using the Spectre Console Json Library.
 
Thanks to [trackd](https://github.com/trackd) for adding this!  
See https://spectreconsole.net/widgets/json for more information.

## EXAMPLES

### EXAMPLE 1

# **Example 1**  
# This example demonstrates how to format an array of objects into a Spectre Console Json object with syntax highlighting.
$data = @(
    [pscustomobject]@{
        Name = "John"
        Age = 25
        City = "New York"
        IsEmployed = $true
        Salary = 10
        Hobbies = @("Reading", "Swimming")
        Address = @{
            Street = "123 Main St"
            ZipCode = $null
        }
    }
)
Format-SpectreJson -Data $data

### EXAMPLE 2

# **Example 2**  
# This example demonstrates how to display json string data using Format-SpectreJson.
$jsonString = @{
    Name = 'Alice'
    Age = 30
    Skills = @('PowerShell', 'Spectre.Console')
} | ConvertTo-Json

# Display the JSON string using Format-SpectreJson
$jsonString | Format-SpectreJson

### EXAMPLE 3

# **Example 3**  
# This example demonstrates how to display the contents of one or more JSON files directly using Format-SpectreJson.

# Create temporary JSON files for demonstration, use a random execution ID to avoid reading random json files from the temp directory.
$executionId = [guid]::NewGuid().ToString()
$tempJson1 = (New-TemporaryFile).FullName -replace '.tmp$', ".$executionId.json"
$tempJson2 = (New-TemporaryFile).FullName -replace '.tmp$', ".$executionId.json"

@{
    Name = 'Alice'
    Age = 30
    Skills = @('PowerShell', 'Spectre.Console')
} | ConvertTo-Json | Set-Content -Path $tempJson1

@{
    Name = 'Bob'
    Age = 35
    Skills = @('C#', 'JavaScript')
} | ConvertTo-Json | Set-Content -Path $tempJson2

# Display the JSON files directly using Get-ChildItem and Format-SpectreJson
$parent = Split-Path $tempJson1 -Parent
Get-ChildItem $parent -Filter "*.$executionId.json" | Format-SpectreJson

## PARAMETERS

### -Border

:::caution
This parameter is deprecated and will be removed in the future.
It takes no effect from version 2.0.
To add a border wrap this object in a panel, use `$data | Format-SpectreJson | Format-SpectrePanel`.
:::

```yaml
Type: System.String
DefaultValue: ''
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

:::caution
This parameter is deprecated and will be removed in the future.
It takes no effect from version 2.0.
To add a border with a color use `$data | Format-SpectreJson | Format-SpectrePanel -Color "color"`.
:::

```yaml
Type: System.String
DefaultValue: ''
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

The array of objects to be formatted into Json.

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

### -Depth

The maximum depth of the Json.
Default is defined by the version of powershell.

```yaml
Type: System.Int32
DefaultValue: 0
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

### -Height

:::caution
This parameter is deprecated and will be removed in the future.
It takes no effect from version 2.0.
To add a border with a width, use `$data | Format-SpectreJson | Format-SpectrePanel -Height 20`.
:::

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 6
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -JsonStyle

A hashtable of Spectre Console color names and values to style the Json output.
e.g.
```
@{
    MemberStyle    = "Yellow"
    BracesStyle    = "Red"
    BracketsStyle  = "Orange1"
    ColonStyle     = "White"
    CommaStyle     = "White"
    StringStyle    = "White"
    NumberStyle    = "Red"
    BooleanStyle   = "LightSkyBlue1"
    NullStyle      = "Gray"
}
```

```yaml
Type: System.Collections.Hashtable
DefaultValue: >-
  @{
              MemberStyle    = $script:AccentColor
              BracesStyle    = [Spectre.Console.Color]::Cyan1
              BracketsStyle  = [Spectre.Console.Color]::Orange1
              ColonStyle     = $script:AccentColor
              CommaStyle     = $script:AccentColor
              StringStyle    = [Spectre.Console.Color]::White
              NumberStyle    = [Spectre.Console.Color]::Cyan1
              BooleanStyle   = [Spectre.Console.Color]::LightSkyBlue1
              NullStyle      = $script:DefaultValueColor
          }
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 7
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoBorder

:::caution
This parameter is deprecated and will be removed in the future.
It takes no effect from version 2.0.
The json output already has no border.
:::

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

### -Title

:::caution
This parameter is deprecated and will be removed in the future.
It takes no effect from version 2.0.
To add a border with a title to the json data, use `$data | Format-SpectreJson | Format-SpectrePanel -Header "title"`.
:::

```yaml
Type: System.String
DefaultValue: ''
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

### -Width

:::caution
This parameter is deprecated and will be removed in the future.
It takes no effect from version 2.0.
To add a border with a width, use `$data | Format-SpectreJson | Format-SpectrePanel -Width 20`.
:::

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

