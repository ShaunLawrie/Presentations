# Execute tape commands to generate the recordings
Set-Location "C:\Dev\psconfeu\automagical-documentation\test\tapes"
docker run --rm -v .:/vhs vhs-pwsh test.tape

# Conver the command data into a platyps commandhelp object
$command = Get-Command Format-SpectrePanel
$commandHelp = New-CommandHelp $command

# Mess with the example format
$commandHelp.Examples | ForEach-Object {
  # Format with code fences
  $_.Remarks = "``````powershell`n" + $_.Remarks + "`n```````n`n![demo](/demo.gif)"
}

# Dump the markdown
Export-MarkdownCommandHelp -CommandHelp $commandHelp -OutputFolder C:\Dev\psconfeu\automagical-documentation\test\tapes\shit\site\src\content\docs\reference -Force

# Tweak the generated markdown
$c = Get-Content C:\Dev\psconfeu\automagical-documentation\test\tapes\shit\site\src\content\docs\reference\PwshSpectreConsole\Format-SpectrePanel.md -Raw
$c -replace '(?m)^# Format-SpectrePanel$', '' `
    -replace '(?ms)## SYNOPSIS.+?^## ', '## ' `
    -replace '(?ms)## INPUTS.+?^## ', '## ' `
    -replace '(?ms)## OUTPUTS.+?^## ', '## ' `
    -replace '(?ms)## NOTES.+?^## ', '## ' `
    -replace '(?ms)## RELATED LINKS.+', '' `
    -replace '(?ms)## SYNTAX.+?^## ', '## ' `
    -replace '(?ms)## ALIASES.+?^## ', '## ' | Set-Content 'C:\Dev\psconfeu\automagical-documentation\test\tapes\shit\site\src\content\docs\reference\PwshSpectreConsole\Format-SpectrePanel.md'
