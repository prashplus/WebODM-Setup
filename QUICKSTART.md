# WebODM Quick Start Guide

Welcome to WebODM! This guide will help you get started quickly.

## Prerequisites Check

Before starting, ensure you have:

- [ ] Docker Desktop installed and running
- [ ] At least 8GB RAM available
- [ ] 50GB+ free disk space
- [ ] Python 3.8+ (for video processing)

## Installation Steps

### Windows

1. **Open PowerShell as Administrator**
2. **Navigate to the repository**

   ```powershell
   cd d:\Github\WebODM-Setup
   ```

3. **Run installation**

   ```powershell
   .\scripts\install-windows.ps1
   ```

4. **Start WebODM**

   ```powershell
   .\scripts\start-webodm.ps1
   ```

5. **Access WebODM**
   - Open browser: <http://localhost:8000>
   - Create your admin account

### Linux/macOS

1. **Open Terminal**
2. **Navigate to the repository**

   ```bash
   cd ~/WebODM-Setup
   ```

3. **Make scripts executable**

   ```bash
   chmod +x scripts/*.sh
   ```

4. **Run installation**

   ```bash
   ./scripts/install-linux.sh
   ```

5. **Start WebODM**

   ```bash
   ./scripts/start-webodm.sh
   ```

6. **Access WebODM**
   - Open browser: <http://localhost:8000>
   - Create your admin account

## Processing Your First Drone Video

### Extract Frames from Video

```bash
# Windows
python scripts\extract-frames.py --input your_video.mp4 --output .\frames --fps 1

# Linux/macOS
python scripts/extract-frames.py --input your_video.mp4 --output ./frames --fps 1
```

### Batch Process Multiple Videos

```bash
# Windows
python scripts\batch-process.py --input-dir .\videos --output-dir .\frames

# Linux/macOS
python scripts/batch-process.py --input-dir ./videos --output-dir ./frames
```

## Creating Your First Project in WebODM

1. **Login to WebODM** at <http://localhost:8000>

2. **Create a New Project**
   - Click "Add Project"
   - Enter project name and description
   - Click "Create Project"

3. **Upload Images**
   - Click "Select Images and GCP"
   - Upload extracted frames from your drone video
   - Or upload drone images directly

4. **Configure Processing Options**
   - Choose a preset (Fast, Default, High Quality, or Ultra Quality)
   - Or customize processing options
   - Click "Start Processing"

5. **Monitor Progress**
   - Watch the processing progress
   - View logs if needed

6. **View Results**
   - Once complete, view:
     - Orthophoto (2D map)
     - 3D Model
     - Point Cloud
     - Digital Elevation Model (DEM)

## Common Commands

### Start WebODM

```bash
# Windows
.\scripts\start-webodm.ps1

# Linux/macOS
./scripts/start-webodm.sh
```

### Stop WebODM

```bash
# Windows
.\scripts\stop-webodm.ps1

# Linux/macOS
./scripts/stop-webodm.sh
```

### Update WebODM

```bash
# Windows
.\scripts\update-webodm.ps1

# Linux/macOS
./scripts/update-webodm.sh
```

### View Logs

```bash
docker-compose logs -f webapp
```

### Check Status

```bash
docker-compose ps
```

## Tips for Best Results

### Drone Video Recording

- **Overlap**: Ensure 70-80% overlap between images
- **Flight Pattern**: Use systematic flight patterns (grid or parallel lines)
- **Altitude**: Maintain consistent altitude
- **Speed**: Fly slowly for better image quality
- **Lighting**: Avoid harsh shadows, cloudy days are ideal

### Frame Extraction

- **FPS**: 0.5-2 FPS is usually sufficient
  - 0.5 FPS for slow flights
  - 1 FPS for normal flights
  - 2 FPS for fast flights or detailed mapping

- **Quality**: Use 90-95 for JPEG quality
- **Format**: JPG is recommended for most cases

### Processing Options

- **Fast**: Quick preview (low quality)
- **Default**: Good balance of speed and quality
- **High Quality**: For important projects
- **Ultra Quality**: For maximum detail (very slow)

## Troubleshooting

### WebODM won't start

- Check if Docker is running: `docker ps`
- Check port 8000 is not in use
- View logs: `docker-compose logs`

### Out of memory

- Increase Docker memory allocation
- Process fewer images at once
- Use "Fast" preset

### Video processing fails

- Install FFmpeg
- Check video file is not corrupted
- Ensure sufficient disk space

## Next Steps

- Read the [full README](README.md)
- Check [WebODM documentation](https://docs.webodm.org/)
- Join [OpenDroneMap community](https://community.opendronemap.org/)

## Support

For issues or questions:

- Open an issue on GitHub
- Check WebODM documentation
- Visit OpenDroneMap community forum

---

Happy mapping! 🗺️✨
