# WebODM Utilities - Windows PowerShell Script
# Collection of useful commands for managing WebODM

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('logs', 'status', 'clean', 'backup', 'restore', 'restart')]
    [string]$Action
)

function Show-Menu {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "WebODM Utilities" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. View logs" -ForegroundColor White
    Write-Host "2. Check status" -ForegroundColor White
    Write-Host "3. Clean unused data" -ForegroundColor White
    Write-Host "4. Backup data" -ForegroundColor White
    Write-Host "5. Restart services" -ForegroundColor White
    Write-Host "6. Exit" -ForegroundColor White
    Write-Host ""
}

function Show-Logs {
    Write-Host "📋 Showing WebODM logs (Ctrl+C to exit)..." -ForegroundColor Yellow
    docker-compose logs -f webapp
}

function Show-Status {
    Write-Host "📊 WebODM Service Status:" -ForegroundColor Yellow
    docker-compose ps
    Write-Host ""
    Write-Host "💾 Disk Usage:" -ForegroundColor Yellow
    docker system df
}

function Clean-Data {
    Write-Host "🧹 Cleaning unused Docker data..." -ForegroundColor Yellow
    Write-Host "This will remove unused containers, networks, and images." -ForegroundColor Cyan
    $confirm = Read-Host "Continue? (y/n)"
    if ($confirm -eq 'y') {
        docker system prune -f
        Write-Host "✓ Cleanup complete" -ForegroundColor Green
    }
}

function Backup-Data {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupDir = "backups\webodm_backup_$timestamp"
    
    Write-Host "💾 Creating backup..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
    
    # Backup volumes
    docker run --rm -v webodm-setup_webodm-data:/data -v ${PWD}\${backupDir}:/backup alpine tar czf /backup/webodm-data.tar.gz -C /data .
    docker run --rm -v webodm-setup_postgres-data:/data -v ${PWD}\${backupDir}:/backup alpine tar czf /backup/postgres-data.tar.gz -C /data .
    
    Write-Host "✓ Backup created at: $backupDir" -ForegroundColor Green
}

function Restart-Services {
    Write-Host "🔄 Restarting WebODM services..." -ForegroundColor Yellow
    docker-compose restart
    Write-Host "✓ Services restarted" -ForegroundColor Green
}

# Main logic
if ($Action) {
    switch ($Action) {
        'logs' { Show-Logs }
        'status' { Show-Status }
        'clean' { Clean-Data }
        'backup' { Backup-Data }
        'restart' { Restart-Services }
    }
} else {
    while ($true) {
        Show-Menu
        $choice = Read-Host "Select an option (1-6)"
        
        switch ($choice) {
            '1' { Show-Logs }
            '2' { Show-Status }
            '3' { Clean-Data }
            '4' { Backup-Data }
            '5' { Restart-Services }
            '6' { exit 0 }
            default { Write-Host "Invalid option" -ForegroundColor Red }
        }
    }
}
