# System Requirements Check for WebODM
# Run this script to verify your system meets the requirements

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "WebODM System Requirements Check" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$allChecksPassed = $true

# Check Windows version
Write-Host "[1/8] Checking Windows version..." -ForegroundColor Yellow
$osVersion = [System.Environment]::OSVersion.Version
if ($osVersion.Major -ge 10) {
    Write-Host "✓ Windows version: $($osVersion.Major).$($osVersion.Minor)" -ForegroundColor Green
} else {
    Write-Host "✗ Windows 10 or later required" -ForegroundColor Red
    $allChecksPassed = $false
}

# Check PowerShell version
Write-Host "[2/8] Checking PowerShell version..." -ForegroundColor Yellow
$psVersion = $PSVersionTable.PSVersion
if ($psVersion.Major -ge 5) {
    Write-Host "✓ PowerShell version: $($psVersion.Major).$($psVersion.Minor)" -ForegroundColor Green
} else {
    Write-Host "✗ PowerShell 5.0 or later required" -ForegroundColor Red
    $allChecksPassed = $false
}

# Check Docker installation
Write-Host "[3/8] Checking Docker installation..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "✓ Docker installed: $dockerVersion" -ForegroundColor Green
    
    # Check if Docker is running
    Write-Host "[4/8] Checking if Docker is running..." -ForegroundColor Yellow
    docker ps | Out-Null
    Write-Host "✓ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker not found or not running" -ForegroundColor Red
    Write-Host "  Install from: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    $allChecksPassed = $false
}

# Check Docker Compose
Write-Host "[5/8] Checking Docker Compose..." -ForegroundColor Yellow
try {
    $composeVersion = docker-compose --version
    Write-Host "✓ Docker Compose installed: $composeVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker Compose not found" -ForegroundColor Red
    $allChecksPassed = $false
}

# Check Python installation
Write-Host "[6/8] Checking Python installation..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version
    Write-Host "✓ Python installed: $pythonVersion" -ForegroundColor Green
    
    # Check pip
    try {
        $pipVersion = pip --version
        Write-Host "✓ pip installed" -ForegroundColor Green
    } catch {
        Write-Host "⚠ pip not found (required for video processing)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "⚠ Python not installed (optional for video processing)" -ForegroundColor Yellow
    Write-Host "  Install from: https://www.python.org/downloads/" -ForegroundColor Cyan
}

# Check available RAM
Write-Host "[7/8] Checking system RAM..." -ForegroundColor Yellow
$ram = Get-CimInstance Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory
$ramGB = [math]::Round($ram / 1GB, 2)
if ($ramGB -ge 8) {
    Write-Host "✓ Available RAM: $ramGB GB" -ForegroundColor Green
} else {
    Write-Host "⚠ Available RAM: $ramGB GB (8GB+ recommended)" -ForegroundColor Yellow
}

# Check available disk space
Write-Host "[8/8] Checking available disk space..." -ForegroundColor Yellow
$disk = Get-PSDrive C | Select-Object -ExpandProperty Free
$diskGB = [math]::Round($disk / 1GB, 2)
if ($diskGB -ge 50) {
    Write-Host "✓ Available disk space: $diskGB GB" -ForegroundColor Green
} else {
    Write-Host "⚠ Available disk space: $diskGB GB (50GB+ recommended)" -ForegroundColor Yellow
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($allChecksPassed) {
    Write-Host "✅ All required checks passed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "You can proceed with installation:" -ForegroundColor Cyan
    Write-Host "  .\scripts\install-windows.ps1" -ForegroundColor White
} else {
    Write-Host "❌ Some required components are missing" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install missing components and run this check again" -ForegroundColor Yellow
}

Write-Host ""
