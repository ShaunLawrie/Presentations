# Slide 4: Real-World Use Cases

**How can PowerShell devs use PwshSpectreConsole?**

---

- **Dashboards**: Show system status, logs, or metrics in real time
- **Interactive scripts**: Prompt users for input, choices, or confirmations
- **Progress & Status**: Show progress bars for long-running tasks
- **Error Handling**: Format exceptions and errors for clarity
- **Data Visualization**: Display tables, charts, and trees for reports

```powershell
# Example: Interactive selection
$color = Read-SpectreSelection -Message "Pick a color" -Choices @("Red", "Green", "Blue")
Write-SpectreHost "You picked: $color"
```

![PwshSpectreConsole Live Demo](https://pwshspectreconsole.com/images/demo-live.gif)

---

[Next Slide: Getting Started](./slide5-getting-started.md)
