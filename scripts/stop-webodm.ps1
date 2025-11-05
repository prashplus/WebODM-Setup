# Stop WebODM - Windows PowerShell Script

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Stopping WebODM..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

try {
    docker-compose down
    Write-Host ""
    Write-Host "✓ WebODM stopped successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to stop WebODM" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}
