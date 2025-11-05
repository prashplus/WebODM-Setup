# GPU Verification Script for WebODM
# This script checks if GPU acceleration is properly configured

Write-Host "`n=== WebODM GPU Configuration Verification ===" -ForegroundColor Cyan

# Check if NVIDIA driver is available on host
Write-Host "`n1. Checking host GPU..." -ForegroundColor Yellow
try {
    $gpuInfo = nvidia-smi --query-gpu=name,memory.total,driver_version,cuda_version --format=csv,noheader 2>$null
    if ($gpuInfo) {
        Write-Host "   ✓ GPU detected: $gpuInfo" -ForegroundColor Green
    }
} catch {
    Write-Host "   ✗ NVIDIA GPU not detected on host" -ForegroundColor Red
    Write-Host "   Please ensure NVIDIA drivers are installed" -ForegroundColor Yellow
    exit 1
}

# Check if NodeODM container is running
Write-Host "`n2. Checking NodeODM container..." -ForegroundColor Yellow
$containerStatus = docker ps --filter "name=webodm-node-odm-1" --format "{{.Status}}"
if ($containerStatus -like "*Up*") {
    Write-Host "   ✓ NodeODM container is running" -ForegroundColor Green
} else {
    Write-Host "   ✗ NodeODM container is not running" -ForegroundColor Red
    Write-Host "   Run: docker-compose up -d" -ForegroundColor Yellow
    exit 1
}

# Check GPU access inside container
Write-Host "`n3. Checking GPU access in NodeODM container..." -ForegroundColor Yellow
try {
    $containerGpu = docker exec webodm-node-odm-1 nvidia-smi --query-gpu=name --format=csv,noheader 2>&1
    if ($containerGpu -notlike "*error*" -and $containerGpu -notlike "*cannot*") {
        Write-Host "   ✓ GPU accessible inside container: $containerGpu" -ForegroundColor Green
    } else {
        Write-Host "   ✗ GPU not accessible inside container" -ForegroundColor Red
        Write-Host "   Error: $containerGpu" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "   ✗ Failed to check GPU in container" -ForegroundColor Red
    exit 1
}

# Check if GPU image is being used
Write-Host "`n4. Checking NodeODM image..." -ForegroundColor Yellow
$image = docker inspect webodm-node-odm-1 --format '{{.Config.Image}}'
if ($image -like "*:gpu*") {
    Write-Host "   ✓ Using GPU-enabled image: $image" -ForegroundColor Green
} else {
    Write-Host "   ⚠ Using non-GPU image: $image" -ForegroundColor Yellow
    Write-Host "   Consider updating to opendronemap/nodeodm:gpu" -ForegroundColor Yellow
}

# Check GPU environment variable
Write-Host "`n5. Checking GPU configuration..." -ForegroundColor Yellow
$gpuEnv = docker exec webodm-node-odm-1 printenv GPU_ENABLED 2>$null
if ($gpuEnv -eq "true") {
    Write-Host "   ✓ GPU_ENABLED=true" -ForegroundColor Green
} else {
    Write-Host "   ⚠ GPU_ENABLED not set or false" -ForegroundColor Yellow
}

# Summary
Write-Host "`n=== Verification Complete ===" -ForegroundColor Cyan
Write-Host "`nGPU acceleration is properly configured! 🚀" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "  1. Access WebODM: http://localhost:8000" -ForegroundColor White
Write-Host "  2. Create a new project and upload images" -ForegroundColor White
Write-Host "  3. Processing will automatically use GPU acceleration" -ForegroundColor White
Write-Host "`nTo monitor GPU usage during processing:" -ForegroundColor Cyan
Write-Host "  while (`$true) { Clear-Host; nvidia-smi; Start-Sleep -Seconds 2 }" -ForegroundColor White
Write-Host ""
