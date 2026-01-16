# ACS CLI Installer for Windows
# Run with: irm https://raw.githubusercontent.com/Alaa-Taieb/asc-cli/main/install.ps1 | iex

Write-Host ""
Write-Host "  Installing Agentic Coding Standard CLI..." -ForegroundColor Cyan
Write-Host ""

# Install the package
$installResult = pip install agentic-std --quiet 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  [ERROR] Failed to install package" -ForegroundColor Red
    Write-Host "  $installResult" -ForegroundColor Red
    return
}
Write-Host "  [OK] Package installed" -ForegroundColor Green

# Get the Python Scripts directory
try {
    $pythonPath = (Get-Command python -ErrorAction Stop).Source
    $pythonDir = Split-Path $pythonPath
    $scriptsDir = Join-Path $pythonDir "Scripts"
} catch {
    Write-Host "  [WARN] Could not find Python installation" -ForegroundColor Yellow
    return
}

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
    return
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
