# Start WebODM - Windows PowerShell Script

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Starting WebODM..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
try {
    docker ps | Out-Null
} catch {
    Write-Host "✗ Docker is not running!" -ForegroundColor Red
    Write-Host "Please start Docker Desktop and try again" -ForegroundColor Yellow
    exit 1
}

# Start WebODM using docker-compose
Write-Host "Starting WebODM containers..." -ForegroundColor Yellow
try {
    docker-compose up -d
    Write-Host ""
    Write-Host "✓ WebODM is starting..." -ForegroundColor Green
    Write-Host ""
    Write-Host "Please wait 30-60 seconds for all services to initialize" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "WebODM will be available at:" -ForegroundColor Green
    Write-Host "http://localhost:8000" -ForegroundColor White
    Write-Host ""
    Write-Host "NodeODM API will be available at:" -ForegroundColor Green
    Write-Host "http://localhost:3000" -ForegroundColor White
    Write-Host ""
    Write-Host "To view logs: docker-compose logs -f webapp" -ForegroundColor Cyan
    Write-Host "To stop: .\scripts\stop-webodm.ps1" -ForegroundColor Cyan
} catch {
    Write-Host "✗ Failed to start WebODM" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}
