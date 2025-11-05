# WebODM Setup for Drone Video Processing

A comprehensive setup repository for WebODM installation and drone video processing workflows. This repository contains installation scripts, Docker configurations, and utilities for processing drone imagery and videos.

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Drone Video Processing](#drone-video-processing)
- [Usage](#usage)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

WebODM is an open-source drone mapping software built on OpenDroneMap. This repository provides:

- **Automated Installation Scripts** for Windows, Linux, and macOS
- **Docker Compose Configuration** for easy deployment
- **Video Processing Tools** to extract frames from drone videos
- **Batch Processing Scripts** for multiple datasets
- **Utility Scripts** for common tasks

## 📦 Prerequisites

### System Requirements

- **OS**: Windows 10/11, Ubuntu 20.04+, macOS 10.14+
- **RAM**: Minimum 8GB (16GB+ recommended)
- **Disk Space**: 50GB+ free space
- **CPU**: Multi-core processor (4+ cores recommended)
- **GPU** (Optional): NVIDIA GPU with 4GB+ VRAM for accelerated processing
  - See [GPU_SETUP.md](GPU_SETUP.md) for GPU acceleration guide

### Required Software

1. **Docker Desktop** (Windows/macOS) or **Docker Engine** (Linux)
   - [Download Docker Desktop](https://www.docker.com/products/docker-desktop)
   - Docker Compose (included with Docker Desktop)

2. **Python 3.8+** (for video processing scripts)
   - [Download Python](https://www.python.org/downloads/)

3. **Git** (for cloning the repository)
   - [Download Git](https://git-scm.com/downloads)

## 🚀 Quick Start

### Windows (PowerShell)

```powershell
# Clone the repository
git clone https://github.com/prashplus/WebODM-Setup.git
cd WebODM-Setup

# Run installation script
.\scripts\install-windows.ps1

# Start WebODM
.\scripts\start-webodm.ps1
```

### Linux/macOS (Bash)

```bash
# Clone the repository
git clone https://github.com/prashplus/WebODM-Setup.git
cd WebODM-Setup

# Make scripts executable
chmod +x scripts/*.sh

# Run installation script
./scripts/install-linux.sh

# Start WebODM
./scripts/start-webodm.sh
```

Access WebODM at: `http://localhost:8000`

## 📥 Installation

### Detailed Installation Steps

1. **Install Docker**

   ```powershell
   # Windows: Download and install Docker Desktop
   # Ensure WSL2 is enabled for Windows
   ```

2. **Clone Repository**

   ```bash
   git clone https://github.com/prashplus/WebODM-Setup.git
   cd WebODM-Setup
   ```

3. **Install Python Dependencies**

   ```bash
   pip install -r requirements.txt
   ```

4. **Configure Settings** (Optional)
   - Edit `config/webodm-config.env` for custom settings
   - Adjust Docker resources in Docker Desktop settings

5. **Run Installation Script**
   - Windows: `.\scripts\install-windows.ps1`
   - Linux/Mac: `./scripts/install-linux.sh`

## 🎥 Drone Video Processing

### Extract Frames from Drone Videos

The repository includes scripts to extract frames from drone videos at specified intervals:

```bash
# Basic usage
python scripts/extract-frames.py --input video.mp4 --output ./frames --fps 1

# Advanced usage with GPS data extraction
python scripts/extract-frames.py --input video.mp4 --output ./frames --fps 2 --extract-gps
```

### Parameters

- `--input`: Path to drone video file
- `--output`: Output directory for extracted frames
- `--fps`: Frames per second to extract (default: 1)
- `--extract-gps`: Extract GPS metadata from video (if available)
- `--format`: Output image format (default: jpg)
- `--quality`: JPEG quality 1-100 (default: 95)

### Batch Processing

Process multiple videos at once:

```bash
python scripts/batch-process.py --input-dir ./videos --output-dir ./frames
```

## 💻 Usage

### Starting WebODM

```bash
# Windows
.\scripts\start-webodm.ps1

# Linux/Mac
./scripts/start-webodm.sh
```

### Stopping WebODM

```bash
# Windows
.\scripts\stop-webodm.ps1

# Linux/Mac
./scripts/stop-webodm.sh
```

### Updating WebODM

```bash
# Windows
.\scripts\update-webodm.ps1

# Linux/Mac
./scripts/update-webodm.sh
```

### Creating a New Project

1. Access WebODM at `http://localhost:8000`
2. Create an account (first user becomes admin)
3. Click "Add Project"
4. Upload your processed drone images
5. Configure processing options
6. Start processing

## ⚙️ Configuration

### Environment Variables

Edit `config/webodm-config.env`:

```env
# WebODM Configuration
WO_PORT=8000
WO_HOST=0.0.0.0
WO_DEBUG=NO

# Processing Options
WO_DEFAULT_NODES=1
WO_BROKER_URL=redis://broker

# Storage
MEDIA_ROOT=/webodm/app/media
```

### Docker Resources

Adjust in Docker Desktop Settings:

- **CPUs**: 4+ cores recommended
- **Memory**: 8GB+ recommended
- **Disk**: 50GB+ recommended

## 🔧 Troubleshooting

### Common Issues

#### Docker not running

```bash
# Check Docker status
docker --version
docker ps

# Start Docker Desktop (Windows/Mac)
# Or start Docker service (Linux)
sudo systemctl start docker
```

#### Port 8000 already in use

Edit `config/webodm-config.env` and change `WO_PORT` to another port (e.g., 8080)

#### Out of memory errors

Increase Docker memory allocation in Docker Desktop settings

#### Video processing errors

```bash
# Ensure FFmpeg is installed
ffmpeg -version

# Install if missing
# Windows: choco install ffmpeg
# Ubuntu: sudo apt install ffmpeg
# macOS: brew install ffmpeg
```

### Logs

View WebODM logs:

```bash
docker-compose logs -f webapp
```

## 📁 Repository Structure

```
WebODM-Setup/
├── config/
│   ├── webodm-config.env
│   └── processing-presets.json
├── scripts/
│   ├── install-windows.ps1
│   ├── install-linux.sh
│   ├── start-webodm.ps1
│   ├── start-webodm.sh
│   ├── stop-webodm.ps1
│   ├── stop-webodm.sh
│   ├── update-webodm.ps1
│   ├── update-webodm.sh
│   ├── extract-frames.py
│   └── batch-process.py
├── docker-compose.yml
├── requirements.txt
├── .gitignore
├── LICENSE
└── README.md
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Resources

- [WebODM Official Documentation](https://docs.webodm.org/)
- [OpenDroneMap Community](https://community.opendronemap.org/)
- [Docker Documentation](https://docs.docker.com/)
- [Drone Mapping Best Practices](https://docs.opendronemap.org/flying/)

## 👨‍💻 Author

**Prashant Piprotar**

---

⭐ If this repository helped you, please give it a star!
