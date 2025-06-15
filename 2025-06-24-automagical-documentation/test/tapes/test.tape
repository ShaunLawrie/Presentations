Output shit/site/public/demo.gif

Set Shell pwsh
Set FontSize 34
Set Width 2000
Set Height 600

Hide

Sleep 3s

Type "Install-Module PwshSpectreConsole -Scope CurrentUser -Force" Enter

Wait

Type "Clear-Host" Enter

Show

Type 'Write-SpectreHost "Hello [red]spectre[/] :smiling_face_with_sunglasses:"' Enter Sleep 500ms

Type '$color = Read-SpectreSelection -Message "Select your favorite color" -Choices @("Red", "Green", "Blue")' Sleep 500ms Enter Sleep 500ms

Down@500ms

Down@500ms

Enter

Type 'Write-SpectreHost "Your chosen color is [$color]$color[/]"' Enter

Sleep 5s