# ✅ WebODM GPU Setup Complete

## 🎉 Success Summary

Your WebODM installation is now fully configured with **GPU acceleration** for faster drone image processing!

### What's Been Configured

✅ **WebODM Core Services**

- PostgreSQL 14 with PostGIS 3.3 (spatial database)
- Redis 7 (message broker)
- WebODM Webapp (web interface)
- WebODM Worker (background task processor)
- Processing node automatic registration

✅ **GPU Acceleration**

- NodeODM GPU image: `opendronemap/nodeodm:gpu`
- GPU: NVIDIA GeForce RTX 4060 (8GB VRAM)
- CUDA 13.0 support
- GPU_ENABLED=true
- NVIDIA runtime configured

✅ **Video Processing Tools**

- Frame extraction script (extract-frames.py)
- Batch processing script (batch-process.py)
- Multiple video format support

## 🚀 Quick Start

### 1. Access WebODM

```
http://localhost:8000
```

### 2. Login

- Username: `prashplus`
- Password: (the one you created during setup)

### 3. Verify Services

```powershell
# Check all containers are running
docker-compose ps

# Verify GPU access
.\scripts\verify-gpu.ps1
```

## 📊 Expected Performance

With your RTX 4060 GPU, you can expect:

| Dataset Size | Processing Time (Estimate) |
|--------------|---------------------------|
| 50 images (20MP) | ~10-15 minutes |
| 100 images (20MP) | ~20-30 minutes |
| 200 images (20MP) | ~40-60 minutes |
| 500 images (20MP) | ~2-3 hours |

*Times vary based on image quality, overlap, and selected processing options*

### GPU vs CPU Performance

- **2-5x faster** processing with GPU
- **Better memory efficiency** for large point clouds
- **Higher quality results** with same time budget

## 🎯 Processing Your First Drone Video

### Step 1: Extract Frames from Video

```powershell
# Extract 1 frame per second
python scripts/extract-frames.py input/drone-video.mp4 -i 1 -o extracted-frames/

# Or extract every 30 frames (for 30fps video = 1 frame/second)
python scripts/extract-frames.py input/drone-video.mp4 -f 30 -o extracted-frames/
```

### Step 2: Upload to WebODM

1. Go to <http://localhost:8000>
2. Click "**Add Project**"
3. Enter project name and click "**Create Project**"
4. Click "**Select Images and GCP**"
5. Upload the extracted frames from `extracted-frames/` folder
6. Click "**Upload**"

### Step 3: Start Processing

1. Select processing options:
   - **Fast**: Quick preview (lower quality)
   - **Default**: Good balance
   - **High Quality**: Better results (recommended)
   - **Ultra**: Best quality (slower, even with GPU)

2. Click "**Start Processing**"

### Step 4: Monitor Progress

```powershell
# Watch GPU utilization in real-time
while ($true) { Clear-Host; nvidia-smi; Start-Sleep -Seconds 2 }
```

During processing, you should see:

- **GPU Utilization**: 70-100%
- **GPU Memory**: 2-6GB used
- **Temperature**: Should stay below 80°C

## 📁 Directory Structure

```
WebODM-Setup/
├── docker-compose.yml          # Main configuration with GPU support
├── config/
│   ├── webodm-config.env       # WebODM environment variables
│   └── processing-presets.json # Processing templates
├── scripts/
│   ├── install-windows.ps1     # Automated installation
│   ├── start-windows.ps1       # Start all services
│   ├── stop-windows.ps1        # Stop all services
│   ├── extract-frames.py       # Video frame extraction
│   ├── batch-process.py        # Batch video processing
│   └── verify-gpu.ps1          # GPU verification
├── docs/
│   ├── README.md               # Main documentation
│   ├── QUICKSTART.md           # Quick start guide
│   ├── WORKFLOW.md             # Complete workflow
│   ├── GPU_SETUP.md            # GPU setup guide
│   └── FIXES.md                # Issues and solutions
└── data/
    ├── input/                  # Place your videos here
    ├── output/                 # Processed results
    └── projects/               # WebODM projects (Docker volume)
```

## 🛠️ Common Operations

### Start Services

```powershell
.\scripts\start-windows.ps1
# or
docker-compose up -d
```

### Stop Services

```powershell
.\scripts\stop-windows.ps1
# or
docker-compose down
```

### View Logs

```powershell
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f webapp
docker-compose logs -f node-odm-1
docker-compose logs -f worker
```

### Restart After Changes

```powershell
docker-compose restart
```

### Update WebODM

```powershell
.\scripts\update-windows.ps1
# or
docker-compose pull
docker-compose up -d
```

## 📊 Monitor GPU Usage

### Real-time Monitoring

```powershell
# Simple monitoring (refresh every 2 seconds)
while ($true) { Clear-Host; nvidia-smi; Start-Sleep -Seconds 2 }

# Detailed monitoring with specific metrics
nvidia-smi --query-gpu=index,name,temperature.gpu,utilization.gpu,utilization.memory,memory.used,memory.total --format=csv -l 2
```

### Check GPU from Container

```powershell
# Verify GPU is accessible
docker exec webodm-node-odm-1 nvidia-smi

# Check CUDA version
docker exec webodm-node-odm-1 nvcc --version
```

## 🎛️ Processing Options

### Recommended Settings for GPU

**For Fast Preview (5-10 minutes for 100 images):**

```
--dsm --fast-orthophoto --pc-quality low
```

**For Standard Quality (20-30 minutes for 100 images):**

```
--dsm --pc-quality medium
```

**For High Quality (40-60 minutes for 100 images):**

```
--dsm --pc-quality high --feature-quality high
```

**For Ultra Quality (1-2 hours for 100 images):**

```
--dsm --pc-quality ultra --feature-quality ultra --mesh-octree-depth 12
```

### GPU-Optimized Options

```
--feature-type sift --matcher-type flann --pc-tile
```

## 📈 Troubleshooting

### GPU Not Being Used

1. **Verify GPU access:**

   ```powershell
   .\scripts\verify-gpu.ps1
   ```

2. **Check logs:**

   ```powershell
   docker logs webodm-node-odm-1 | Select-String -Pattern "gpu|GPU"
   ```

3. **Ensure proper image:**

   ```powershell
   docker inspect webodm-node-odm-1 | Select-String -Pattern "Image"
   # Should show: opendronemap/nodeodm:gpu
   ```

### Out of Memory Errors

If you get CUDA out of memory errors:

1. **Reduce image count** per task (split into smaller batches)
2. **Lower quality settings** (use `--pc-quality medium` instead of `ultra`)
3. **Close other GPU applications** (browsers, games, etc.)
4. **Use split mode** for large datasets:

   ```
   --split 200 --split-overlap 150
   ```

### Container Won't Start

```powershell
# Check container status
docker-compose ps

# View error logs
docker-compose logs

# Restart services
docker-compose restart

# Full reset (if needed)
docker-compose down
docker-compose up -d
```

## 📚 Documentation

- **[README.md](README.md)** - Main documentation
- **[QUICKSTART.md](QUICKSTART.md)** - Quick start guide
- **[WORKFLOW.md](WORKFLOW.md)** - Complete processing workflow
- **[EXAMPLES.md](EXAMPLES.md)** - Example commands
- **[GPU_SETUP.md](GPU_SETUP.md)** - Detailed GPU configuration
- **[FIXES.md](FIXES.md)** - Issues encountered and solutions

## 🔗 Useful Links

- **WebODM**: <http://localhost:8000>
- **NodeODM API**: <http://localhost:3000/info>
- **OpenDroneMap Docs**: <https://docs.opendronemap.org/>
- **WebODM Docs**: <https://docs.webodm.org/>
- **Community Forum**: <https://community.opendronemap.org/>

## 💡 Tips for Best Results

1. **Image Overlap**: Ensure 70-80% overlap between images
2. **Image Quality**: Use high-resolution images (12MP+)
3. **Lighting**: Consistent lighting across all images
4. **Camera Settings**: Keep ISO low, avoid motion blur
5. **Flight Altitude**: Maintain consistent altitude
6. **GPS Data**: Include GPS EXIF data if available
7. **GCPs**: Use Ground Control Points for accurate georeferencing

## 🎓 Next Steps

1. **Process your first dataset** using extracted frames
2. **Experiment with different quality settings** to find the right balance
3. **Monitor GPU usage** to understand performance patterns
4. **Explore advanced options** in WORKFLOW.md
5. **Join the community** for tips and support

---

## 🌟 Your System Configuration

- **GPU**: NVIDIA GeForce RTX 4060
- **VRAM**: 8GB
- **CUDA**: 13.0
- **Driver**: 581.80
- **OS**: Windows
- **Docker**: Docker Desktop with WSL2

**Perfect for high-quality drone photogrammetry!** 🚁

---

**Need Help?**

- Check [FIXES.md](FIXES.md) for common issues
- Review [GPU_SETUP.md](GPU_SETUP.md) for GPU troubleshooting
- Visit <https://community.opendronemap.org/> for community support

**Happy Mapping!** 🗺️
