# Update WebODM - Windows PowerShell Script

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Updating WebODM..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Stop WebODM if running
Write-Host "[1/3] Stopping WebODM..." -ForegroundColor Yellow
docker-compose down

# Pull latest images
Write-Host "[2/3] Pulling latest Docker images..." -ForegroundColor Yellow
try {
    docker-compose pull
    Write-Host "✓ Images updated successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to pull images" -ForegroundColor Red
    exit 1
}

# Start WebODM
Write-Host "[3/3] Starting WebODM..." -ForegroundColor Yellow
try {
    docker-compose up -d
    Write-Host ""
    Write-Host "✓ WebODM updated and started successfully" -ForegroundColor Green
    Write-Host ""
    Write-Host "WebODM is available at: http://localhost:8000" -ForegroundColor White
} catch {
    Write-Host "✗ Failed to start WebODM" -ForegroundColor Red
    exit 1
}
