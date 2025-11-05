# 🚀 WebODM Setup Repository

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-lightgrey.svg)

**Complete setup repository for WebODM installation and drone video processing workflows.**

This repository provides everything you need to set up WebODM for drone photogrammetry, including automated installation scripts, Docker configurations, and powerful video frame extraction tools.

---

## ✨ What's Included

### 📦 Core Components
- **Docker Compose Configuration** - Production-ready WebODM deployment
- **Installation Scripts** - Automated setup for Windows, Linux, and macOS
- **Management Scripts** - Start, stop, update, and maintain WebODM
- **Configuration Files** - Pre-configured settings and processing presets

### 🎥 Video Processing Tools
- **Frame Extraction Script** - Extract frames from drone videos with precise control
- **Batch Processing** - Process multiple videos in parallel
- **Quality Control** - Automatic metadata extraction and quality settings
- **Format Support** - MP4, MOV, AVI, and more

### 📚 Documentation
- **Quick Start Guide** - Get running in minutes
- **Complete Workflow** - From video capture to 3D models
- **Usage Examples** - Real-world processing scenarios
- **Troubleshooting** - Common issues and solutions

---

## ⚡ Quick Start

### 1️⃣ Check Requirements

**Windows (PowerShell as Admin)**:
```powershell
.\scripts\check-requirements.ps1
```

**Linux/macOS**:
```bash
chmod +x scripts/*.sh
./scripts/check-requirements.sh
```

### 2️⃣ Install

**Windows**:
```powershell
.\scripts\install-windows.ps1
```

**Linux/macOS**:
```bash
./scripts/install-linux.sh
```

### 3️⃣ Start WebODM

**Windows**:
```powershell
.\scripts\start-webodm.ps1
```

**Linux/macOS**:
```bash
./scripts/start-webodm.sh
```

### 4️⃣ Access WebODM

Open your browser: **http://localhost:8000**

Create your admin account and start mapping!

---

## 📖 Full Documentation

| Document | Description |
|----------|-------------|
| [QUICKSTART.md](QUICKSTART.md) | Step-by-step installation and first project |
| [WORKFLOW.md](WORKFLOW.md) | Complete drone mapping workflow |
| [EXAMPLES.md](EXAMPLES.md) | Processing configurations and use cases |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Contribution guidelines |

---

## 🎥 Drone Video Processing

### Extract Frames from Video

```bash
python scripts/extract-frames.py \
  --input DJI_0001.MP4 \
  --output ./frames \
  --fps 1 \
  --quality 95
```

**Parameters**:
- `--input`: Video file path
- `--output`: Output directory
- `--fps`: Frames per second to extract (default: 1)
- `--quality`: JPEG quality 1-100 (default: 95)
- `--format`: Output format: jpg, png (default: jpg)
- `--start`: Start time in seconds
- `--end`: End time in seconds

### Batch Process Multiple Videos

```bash
python scripts/batch-process.py \
  --input-dir ./videos \
  --output-dir ./frames \
  --fps 1 \
  --workers 4
```

**Process hundreds of videos efficiently with parallel processing!**

---

## 🛠️ Available Scripts

### Installation & Setup
- `install-windows.ps1` / `install-linux.sh` - Install WebODM and dependencies
- `check-requirements.ps1` / `check-requirements.sh` - Verify system requirements

### WebODM Management
- `start-webodm.ps1` / `start-webodm.sh` - Start WebODM services
- `stop-webodm.ps1` / `stop-webodm.sh` - Stop WebODM services
- `update-webodm.ps1` / `update-webodm.sh` - Update to latest version
- `utils.ps1` / `utils.sh` - Utility commands (logs, backup, etc.)

### Video Processing
- `extract-frames.py` - Extract frames from single video
- `batch-process.py` - Batch process multiple videos

---

## 💻 System Requirements

### Minimum
- **OS**: Windows 10/11, Ubuntu 20.04+, macOS 10.14+
- **RAM**: 8GB
- **CPU**: 4 cores
- **Disk**: 50GB free space
- **Docker**: Docker Desktop or Docker Engine

### Recommended
- **RAM**: 16GB+
- **CPU**: 8+ cores
- **Disk**: 100GB+ SSD
- **GPU**: Optional (for advanced processing)

---

## 📁 Repository Structure

```
WebODM-Setup/
├── 📄 README.md                    # This file
├── 📄 QUICKSTART.md                # Quick start guide
├── 📄 WORKFLOW.md                  # Complete workflow
├── 📄 EXAMPLES.md                  # Usage examples
├── 📄 CONTRIBUTING.md              # Contribution guide
├── 📄 LICENSE                      # MIT License
├── 📄 docker-compose.yml           # Docker services
├── 📄 requirements.txt             # Python dependencies
├── 📄 .gitignore                   # Git ignore rules
│
├── 📁 config/                      # Configuration files
│   ├── webodm-config.env          # WebODM environment variables
│   └── processing-presets.json    # Processing presets
│
└── 📁 scripts/                     # All scripts
    ├── install-windows.ps1        # Windows installer
    ├── install-linux.sh           # Linux/macOS installer
    ├── check-requirements.ps1     # Windows requirements check
    ├── check-requirements.sh      # Linux/macOS requirements check
    ├── start-webodm.ps1           # Start (Windows)
    ├── start-webodm.sh            # Start (Linux/macOS)
    ├── stop-webodm.ps1            # Stop (Windows)
    ├── stop-webodm.sh             # Stop (Linux/macOS)
    ├── update-webodm.ps1          # Update (Windows)
    ├── update-webodm.sh           # Update (Linux/macOS)
    ├── utils.ps1                  # Utilities (Windows)
    ├── utils.sh                   # Utilities (Linux/macOS)
    ├── extract-frames.py          # Frame extraction
    └── batch-process.py           # Batch processing
```

---

## 🎯 Common Use Cases

### 🌾 Agriculture Mapping
Extract frames at 0.5-1 FPS, process with Default preset, export orthophotos for NDVI analysis.

### 🏗️ Construction Site Surveys
Extract 1 FPS, High Quality preset, export DEMs and orthophotos for volume calculations.

### 🏛️ 3D Building Models
Extract 2 FPS from circular flights, High Quality preset, export textured 3D models.

### 🔍 Infrastructure Inspection
Extract 1-2 FPS, High Quality with texture, export 3D models for detailed inspection.

See [EXAMPLES.md](EXAMPLES.md) for detailed configurations.

---

## 🔧 Useful Commands

### View Logs
```bash
docker-compose logs -f webapp
```

### Check Service Status
```bash
docker-compose ps
```

### Backup Data (Windows)
```powershell
.\scripts\utils.ps1 backup
```

### Backup Data (Linux/macOS)
```bash
./scripts/utils.sh backup
```

### Restart Services
```bash
docker-compose restart
```

---

## ❓ Troubleshooting

### WebODM won't start
```bash
# Check Docker
docker ps

# Check logs
docker-compose logs webapp
```

### Port 8000 in use
Edit `config/webodm-config.env` and change `WO_PORT=8000` to another port.

### Out of memory
- Increase Docker memory allocation
- Use Fast preset for testing
- Process fewer images

### Video processing errors
Ensure Python dependencies are installed:
```bash
pip install -r requirements.txt
```

See [QUICKSTART.md](QUICKSTART.md) for more troubleshooting tips.

---

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Ways to Contribute
- 🐛 Report bugs
- 💡 Suggest features
- 📝 Improve documentation
- 🔧 Submit pull requests
- ⭐ Star the repository

---

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details.

---

## 🔗 Resources

- **WebODM Documentation**: https://docs.webodm.org/
- **OpenDroneMap**: https://opendronemap.org/
- **Community Forum**: https://community.opendronemap.org/
- **Docker Documentation**: https://docs.docker.com/

---

## 👨‍💻 Author

**Prashant Piprotar**
- GitHub: [@prashplus](https://github.com/prashplus)

---

## ⭐ Show Your Support

If this repository helped you, please give it a star! ⭐

It helps others discover the project and motivates continued development.

---

## 📮 Support

- **Issues**: [GitHub Issues](https://github.com/prashplus/WebODM-Setup/issues)
- **Discussions**: [GitHub Discussions](https://github.com/prashplus/WebODM-Setup/discussions)
- **Email**: Create an issue for support

---

**Happy Mapping! 🗺️✨**
