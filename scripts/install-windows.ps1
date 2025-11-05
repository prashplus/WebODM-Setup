# WebODM Installation Script for Windows
# Run this script in PowerShell with Administrator privileges

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "WebODM Setup - Windows Installation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Please right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

# Check Docker installation
Write-Host "[1/5] Checking Docker installation..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "✓ Docker is installed: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker is not installed!" -ForegroundColor Red
    Write-Host "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

# Check if Docker is running
Write-Host "[2/5] Checking if Docker is running..." -ForegroundColor Yellow
try {
    docker ps | Out-Null
    Write-Host "✓ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "✗ Docker is not running!" -ForegroundColor Red
    Write-Host "Please start Docker Desktop and try again" -ForegroundColor Yellow
    exit 1
}

# Check Python installation
Write-Host "[3/5] Checking Python installation..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version
    Write-Host "✓ Python is installed: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "⚠ Python is not installed (optional for video processing)" -ForegroundColor Yellow
    Write-Host "Install from: https://www.python.org/downloads/" -ForegroundColor Yellow
}

# Install Python dependencies
if (Test-Path "requirements.txt") {
    Write-Host "[4/5] Installing Python dependencies..." -ForegroundColor Yellow
    try {
        pip install -r requirements.txt
        Write-Host "✓ Python dependencies installed" -ForegroundColor Green
    } catch {
        Write-Host "⚠ Failed to install Python dependencies" -ForegroundColor Yellow
    }
} else {
    Write-Host "[4/5] Skipping Python dependencies (requirements.txt not found)" -ForegroundColor Yellow
}

# Pull Docker images
Write-Host "[5/5] Pulling WebODM Docker images..." -ForegroundColor Yellow
Write-Host "This may take several minutes depending on your internet connection..." -ForegroundColor Cyan

try {
    docker-compose pull
    Write-Host "✓ Docker images pulled successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to pull Docker images" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Start WebODM: .\scripts\start-webodm.ps1" -ForegroundColor White
Write-Host "2. Open browser: http://localhost:8000" -ForegroundColor White
Write-Host "3. Create your first account (becomes admin)" -ForegroundColor White
Write-Host ""
