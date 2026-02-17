# macOS Apple Silicon (M1/M2/M3/M4) Guide

This guide covers running WebODM on macOS with Apple Silicon processors.

## Overview

Apple Silicon Macs use the ARM64 (aarch64) architecture. The key differences from x86 Linux/Windows setups:

- **No NVIDIA GPU support** — NVIDIA GPUs and CUDA are not available on Apple Silicon. All processing runs on CPU.
- **Native arm64 Docker images** — Docker Desktop for Apple Silicon runs arm64 containers natively (no Rosetta emulation needed for supported images).
- **Docker Compose v2** — Docker Desktop on macOS ships with `docker compose` (v2 plugin) rather than the standalone `docker-compose` binary.

All scripts in this repository **automatically detect** Apple Silicon and handle these differences. No manual configuration is required.

## Prerequisites

1. **macOS** 12 (Monterey) or later on Apple Silicon (M1/M2/M3/M4)
2. **Docker Desktop for Mac (Apple Silicon)**
   - Download from: https://www.docker.com/products/docker-desktop
   - Ensure you download the **Apple Silicon** version
   - Recommended settings:
     - **CPUs**: 4+ cores
     - **Memory**: 8GB+ (16GB recommended for large datasets)
     - **Disk**: 50GB+
3. **Python 3.8+** (optional, for video processing scripts)
   - Pre-installed on macOS or install via `brew install python3`

## Quick Start

```bash
# Clone the repository
git clone https://github.com/prashplus/WebODM-Setup.git
cd WebODM-Setup

# Make scripts executable
chmod +x scripts/*.sh

# Check system requirements
./scripts/check-requirements.sh

# Install (pulls Docker images)
./scripts/install-linux.sh

# Start WebODM
./scripts/start-webodm.sh
```

Access WebODM at: http://localhost:8000

## What Happens Automatically

When you run any script on Apple Silicon, the `common.sh` helper:

1. **Detects `arm64` architecture** via `uname -m`
2. **Selects `docker-compose.apple-silicon.yml`** instead of the default `docker-compose.yml`
3. **Uses `docker compose` (v2)** if available, falling back to `docker-compose` (v1)

### Docker Compose File Differences

| Setting | Default (`docker-compose.yml`) | Apple Silicon (`docker-compose.apple-silicon.yml`) |
|---------|-------------------------------|---------------------------------------------------|
| NodeODM image | `opendronemap/nodeodm:gpu` | `opendronemap/nodeodm:latest` |
| GPU environment | `GPU_ENABLED=true` | *(not set)* |
| NVIDIA runtime | `deploy.resources.reservations.devices` | *(not set)* |

All other services (Redis, PostgreSQL/PostGIS, WebODM webapp, worker) are identical and have native arm64 image support.

## Performance Expectations

Without GPU acceleration, processing is CPU-bound. Apple Silicon chips are powerful but expect longer processing times compared to NVIDIA GPU-accelerated setups.

### Estimated Processing Times (Apple Silicon, CPU-only)

| Dataset Size | M1/M2 (8-core) | M1 Pro/Max/M2 Pro/Max | M3 Pro/Max/M4 Pro/Max |
|-------------|-----------------|----------------------|----------------------|
| 50 images (20MP) | ~30-45 min | ~20-30 min | ~15-25 min |
| 100 images (20MP) | ~1-2 hours | ~45-90 min | ~30-60 min |
| 200 images (20MP) | ~3-5 hours | ~2-3 hours | ~1.5-2.5 hours |

*Times vary based on image quality, overlap, and processing preset.*

### Tips for Faster Processing

- Use the **Fast** preset for initial testing
- Allocate more CPU cores and memory to Docker Desktop
- Keep datasets under 200 images per task, or use the `--split` option
- Close other resource-intensive applications during processing

## Docker Desktop Settings for Apple Silicon

Open Docker Desktop → Settings → Resources:

- **CPUs**: Allocate at least 4 cores (6-8 recommended)
- **Memory**: At least 8GB (12-16GB recommended)
- **Swap**: 2-4GB
- **Disk image size**: 50GB+

### Enable Rosetta Emulation (Optional)

Docker Desktop can use Rosetta 2 to run x86 images on Apple Silicon. This is **not needed** for WebODM since all images have native arm64 support. However, if you encounter image compatibility issues:

1. Open Docker Desktop → Settings → General
2. Enable **Use Rosetta for x86_64/amd64 emulation on Apple Silicon**

## Troubleshooting

### "no matching manifest for linux/arm64" Error

This means a Docker image doesn't have an arm64 variant. The `docker-compose.apple-silicon.yml` file avoids this by using images with arm64 support. If you see this error, make sure you're not accidentally using the default `docker-compose.yml`.

Verify which compose file is being used:
```bash
./scripts/start-webodm.sh
# Should print: "Detected macOS Apple Silicon (arm64) — using CPU-only compose file"
```

### Containers Crash or Restart

- Check logs: `docker compose -f docker-compose.apple-silicon.yml logs`
- Increase Docker Desktop memory allocation
- Ensure Docker Desktop is up to date

### Slow Processing

- This is expected without GPU acceleration
- Use the **Fast** or **Default** preset instead of High Quality/Ultra
- Allocate more resources in Docker Desktop settings
- Process smaller batches of images

### "docker-compose: command not found"

Docker Desktop for Mac uses `docker compose` (v2 plugin) by default. The scripts handle this automatically. If you need the standalone binary:

```bash
brew install docker-compose
```

## Manual Usage (Without Scripts)

If you prefer to run commands directly:

```bash
# Start
docker compose -f docker-compose.apple-silicon.yml up -d

# Stop
docker compose -f docker-compose.apple-silicon.yml down

# View logs
docker compose -f docker-compose.apple-silicon.yml logs -f webapp

# Pull latest images
docker compose -f docker-compose.apple-silicon.yml pull

# Check status
docker compose -f docker-compose.apple-silicon.yml ps
```

## Switching Between Machines

If you work on both Apple Silicon and x86 machines:

- The scripts auto-detect the architecture — just run the same commands on both
- Docker volumes are not portable between architectures
- The same project data (images) can be uploaded to WebODM on any machine

---

For general WebODM usage, see the [README.md](README.md) and [QUICKSTART.md](QUICKSTART.md).
