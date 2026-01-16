# ACS CLI Installer for Windows
# Run with: irm https://raw.githubusercontent.com/Alaa-Taieb/asc-cli/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "  Installing ACS CLI..." -ForegroundColor Cyan
Write-Host ""

# Install the package
try {
    pip install acs-cli --quiet
    Write-Host "  [OK] Package installed" -ForegroundColor Green
} catch {
    Write-Host "  [ERROR] Failed to install package: $_" -ForegroundColor Red
    exit 1
}

# Get the Python Scripts directory
$pythonPath = (Get-Command python).Source
$pythonDir = Split-Path $pythonPath
$scriptsDir = Join-Path $pythonDir "Scripts"

# Check if it's a user install (different path)
$userScriptsDir = Join-Path $env:APPDATA "Python" | Get-ChildItem -Directory -ErrorAction SilentlyContinue | 
    ForEach-Object { Join-Path $_.FullName "Scripts" } | 
    Where-Object { Test-Path $_ } | 
    Select-Object -First 1

if ($userScriptsDir -and (Test-Path (Join-Path $userScriptsDir "acs.exe"))) {
    $scriptsDir = $userScriptsDir
}

# Check if acs.exe exists
$acsPath = Join-Path $scriptsDir "acs.exe"
if (-not (Test-Path $acsPath)) {
    Write-Host "  [WARN] Could not locate acs.exe" -ForegroundColor Yellow
    Write-Host "  You may need to add Python Scripts to your PATH manually." -ForegroundColor Yellow
    exit 0
}

# Check if Scripts dir is already in PATH
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$scriptsDir*") {
    Write-Host "  Adding $scriptsDir to PATH..." -ForegroundColor Cyan
    
    try {
        [Environment]::SetEnvironmentVariable(
            "Path", 
            "$currentPath;$scriptsDir", 
            "User"
        )
        Write-Host "  [OK] Added to PATH" -ForegroundColor Green
        Write-Host ""
        Write-Host "  NOTE: Restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
    } catch {
        Write-Host "  [WARN] Could not modify PATH automatically." -ForegroundColor Yellow
        Write-Host "  Please add this to your PATH manually: $scriptsDir" -ForegroundColor Yellow
    }
} else {
    Write-Host "  [OK] Scripts directory already in PATH" -ForegroundColor Green
}

Write-Host ""
Write-Host "  Installation complete!" -ForegroundColor Green
Write-Host "  Run 'acs init' in any project to get started." -ForegroundColor Cyan
Write-Host ""
