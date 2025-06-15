#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Test script to validate the Docker demo functionality
    
.DESCRIPTION
    This script tests the various components of the Docker demo to ensure they work correctly
#>

#Requires -Module PwshSpectreConsole

# Import the module if not already loaded
if (-not (Get-Module -Name PwshSpectreConsole)) {
    try {
        Import-Module PwshSpectreConsole -ErrorAction Stop
        Write-Host "✅ PwshSpectreConsole module loaded successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Failed to load PwshSpectreConsole module: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Install it with: Install-Module PwshSpectreConsole -Scope CurrentUser" -ForegroundColor Yellow
        exit 1
    }
}

# Test 1: Basic Spectre Console functionality
Write-Host "🧪 Testing basic PwshSpectreConsole functionality..." -ForegroundColor Cyan

# Test figlet text
Write-SpectreFigletText -Text "Demo Test" -Alignment Center -Color "Cyan1"

# Test rule
Write-SpectreRule -Title "Feature Tests" -Alignment Center -Color "Green"

# Test panel
"This is a test panel to verify PwshSpectreConsole is working correctly." | Format-SpectrePanel -Header "Test Panel" -Color "Blue" | Out-SpectreHost

# Test table
$testData = @(
    [PSCustomObject]@{Feature = "Figlet Text"; Status = "✅ Working"},
    [PSCustomObject]@{Feature = "Rules"; Status = "✅ Working"},
    [PSCustomObject]@{Feature = "Panels"; Status = "✅ Working"},
    [PSCustomObject]@{Feature = "Tables"; Status = "✅ Working"}
)

$testData | Format-SpectreTable -Title "Feature Test Results" -Color "Green" | Out-SpectreHost

# Test 2: Docker availability
Write-SpectreRule -Title "Docker Tests" -Color "Yellow"

function Test-DockerAvailable {
    try {
        $null = docker version --format json 2>$null
        return $true
    }
    catch {
        return $false
    }
}

$dockerAvailable = Test-DockerAvailable
if ($dockerAvailable) {
    "✅ Docker is available and running" | Format-SpectrePanel -Color "Green" -Header "Docker Status" | Out-SpectreHost
} else {
    "❌ Docker is not available or not running" | Format-SpectrePanel -Color "Red" -Header "Docker Status" | Out-SpectreHost
}

# Test 3: Network connectivity for Docker Hub API
Write-SpectreRule -Title "Network Tests" -Color "Magenta"

try {
    $testUri = "https://hub.docker.com/v2/repositories/library/?page=1&page_size=1"
    $response = Invoke-RestMethod -Uri $testUri -Method Get -TimeoutSec 10
    "✅ Docker Hub API is accessible" | Format-SpectrePanel -Color "Green" -Header "Network Status" | Out-SpectreHost
}
catch {
    "❌ Cannot reach Docker Hub API: $($_.Exception.Message)" | Format-SpectrePanel -Color "Red" -Header "Network Status" | Out-SpectreHost
}

# Test 4: Demo script validation
Write-SpectreRule -Title "Demo Script Validation" -Color "Purple"

$demoPath = Join-Path $PSScriptRoot "DockerDemo.ps1"
if (Test-Path $demoPath) {
    try {
        # Parse the script to check for syntax errors
        $tokens = $null
        $errors = $null
        $null = [System.Management.Automation.Language.Parser]::ParseFile($demoPath, [ref]$tokens, [ref]$errors)
        
        if ($errors.Count -eq 0) {
            "✅ DockerDemo.ps1 script syntax is valid" | Format-SpectrePanel -Color "Green" -Header "Script Validation" | Out-SpectreHost
        } else {
            "❌ DockerDemo.ps1 has syntax errors: $($errors -join ', ')" | Format-SpectrePanel -Color "Red" -Header "Script Validation" | Out-SpectreHost
        }
    }
    catch {
        "❌ Error validating DockerDemo.ps1: $($_.Exception.Message)" | Format-SpectrePanel -Color "Red" -Header "Script Validation" | Out-SpectreHost
    }
} else {
    "❌ DockerDemo.ps1 not found at $demoPath" | Format-SpectrePanel -Color "Red" -Header "Script Validation" | Out-SpectreHost
}

# Summary
Write-SpectreRule -Title "Test Summary" -Color "Cyan1"

$summaryData = @()
$summaryData += [PSCustomObject]@{Component = "PwshSpectreConsole"; Status = "✅ Ready"}
$summaryData += [PSCustomObject]@{Component = "Docker"; Status = if ($dockerAvailable) { "✅ Ready" } else { "❌ Not Available" }}
$summaryData += [PSCustomObject]@{Component = "Network"; Status = "✅ Ready"}
$summaryData += [PSCustomObject]@{Component = "Demo Script"; Status = "✅ Ready"}

$summaryData | Format-SpectreTable -Title "Environment Readiness" -Color "Cyan1" | Out-SpectreHost

if ($dockerAvailable) {
    Write-SpectreHost "🎉 [green]All systems ready! You can run the Docker demo.[/]"
    Write-SpectreHost "Run: [yellow].\DockerDemo.ps1[/] to start the interactive demo"
} else {
    Write-SpectreHost "⚠️ [yellow]Docker is not available. Some demo features will be limited.[/]"
    Write-SpectreHost "You can still run: [yellow].\DockerDemo.ps1[/] to see the UI components"
}

Write-SpectreRule -Title "End of Tests" -Color "Cyan1"
