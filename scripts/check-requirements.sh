#!/bin/bash
# System Requirements Check for WebODM
# Run this script to verify your system meets the requirements

# Source common helpers (compose command & Apple Silicon detection)
source "$(dirname "$0")/common.sh"
detect_compose_cmd

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}WebODM System Requirements Check${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

all_checks_passed=true

# Check OS
echo -e "${YELLOW}[1/9] Checking operating system...${NC}"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "${GREEN}✓ Operating System: Linux${NC}"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${GREEN}✓ Operating System: macOS${NC}"
else
    echo -e "${RED}✗ Unsupported operating system${NC}"
    all_checks_passed=false
fi

# Check architecture (Apple Silicon detection)
echo -e "${YELLOW}[2/9] Checking system architecture...${NC}"
ARCH=$(uname -m)
if [[ "$OSTYPE" == "darwin"* ]] && [[ "$ARCH" == "arm64" ]]; then
    echo -e "${GREEN}✓ Architecture: Apple Silicon (arm64)${NC}"
    echo -e "${CYAN}  Note: GPU acceleration (NVIDIA) is not available on Apple Silicon.${NC}"
    echo -e "${CYAN}  CPU-only NodeODM will be used (native arm64 image).${NC}"
elif [[ "$ARCH" == "x86_64" ]] || [[ "$ARCH" == "amd64" ]]; then
    echo -e "${GREEN}✓ Architecture: x86_64${NC}"
elif [[ "$ARCH" == "aarch64" ]]; then
    echo -e "${GREEN}✓ Architecture: aarch64 (ARM 64-bit)${NC}"
else
    echo -e "${YELLOW}⚠ Architecture: $ARCH (may have limited Docker image support)${NC}"
fi

# Check bash version
echo -e "${YELLOW}[3/9] Checking bash version...${NC}"
bash_version=${BASH_VERSION%%[^0-9]*}
if [ "$bash_version" -ge 4 ]; then
    echo -e "${GREEN}✓ Bash version: $BASH_VERSION${NC}"
else
    echo -e "${YELLOW}⚠ Bash version: $BASH_VERSION (4.0+ recommended)${NC}"
fi

# Check Docker installation
echo -e "${YELLOW}[4/9] Checking Docker installation...${NC}"
if command -v docker &> /dev/null; then
    docker_version=$(docker --version)
    echo -e "${GREEN}✓ Docker installed: $docker_version${NC}"
    
    # Check if Docker is running
    echo -e "${YELLOW}[5/9] Checking if Docker is running...${NC}"
    if docker ps &> /dev/null; then
        echo -e "${GREEN}✓ Docker is running${NC}"
    else
        echo -e "${RED}✗ Docker is not running${NC}"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo -e "${YELLOW}  Start Docker Desktop from Applications${NC}"
        else
            echo -e "${YELLOW}  Start with: sudo systemctl start docker${NC}"
        fi
        all_checks_passed=false
    fi
else
    echo -e "${RED}✗ Docker not found${NC}"
    echo -e "${YELLOW}  Install: https://docs.docker.com/get-docker/${NC}"
    all_checks_passed=false
fi

# Check Docker Compose
echo -e "${YELLOW}[6/9] Checking Docker Compose...${NC}"
if docker compose version &> /dev/null; then
    compose_version=$(docker compose version)
    echo -e "${GREEN}✓ Docker Compose (v2 plugin) installed: $compose_version${NC}"
elif command -v docker-compose &> /dev/null; then
    compose_version=$(docker-compose --version)
    echo -e "${GREEN}✓ Docker Compose (standalone) installed: $compose_version${NC}"
else
    echo -e "${RED}✗ Docker Compose not found${NC}"
    echo -e "${YELLOW}  Install Docker Desktop (includes Compose) or install docker-compose separately.${NC}"
    all_checks_passed=false
fi

# Check Python installation
echo -e "${YELLOW}[7/9] Checking Python installation...${NC}"
if command -v python3 &> /dev/null; then
    python_version=$(python3 --version)
    echo -e "${GREEN}✓ Python installed: $python_version${NC}"
    
    # Check pip
    if command -v pip3 &> /dev/null; then
        echo -e "${GREEN}✓ pip installed${NC}"
    else
        echo -e "${YELLOW}⚠ pip not found (required for video processing)${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Python not installed (optional for video processing)${NC}"
    echo -e "${CYAN}  Install from: https://www.python.org/downloads/${NC}"
fi

# Check available RAM
echo -e "${YELLOW}[8/9] Checking system RAM...${NC}"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    ram_gb=$((ram_kb / 1024 / 1024))
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ram_bytes=$(sysctl -n hw.memsize)
    ram_gb=$((ram_bytes / 1024 / 1024 / 1024))
fi

if [ "$ram_gb" -ge 8 ]; then
    echo -e "${GREEN}✓ Available RAM: ${ram_gb}GB${NC}"
else
    echo -e "${YELLOW}⚠ Available RAM: ${ram_gb}GB (8GB+ recommended)${NC}"
fi

# Check available disk space
echo -e "${YELLOW}[9/9] Checking available disk space...${NC}"
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: df does not support -BG; use 512-byte blocks and convert
    disk_avail_blocks=$(df . | tail -1 | awk '{print $4}')
    disk_avail=$((disk_avail_blocks / 1024 / 1024 / 2))
else
    disk_avail=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
fi
if [ "$disk_avail" -ge 50 ]; then
    echo -e "${GREEN}✓ Available disk space: ${disk_avail}GB${NC}"
else
    echo -e "${YELLOW}⚠ Available disk space: ${disk_avail}GB (50GB+ recommended)${NC}"
fi

# Summary
echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}Summary${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

if [ "$all_checks_passed" = true ]; then
    echo -e "${GREEN}✅ All required checks passed!${NC}"
    echo ""
    echo -e "${CYAN}You can proceed with installation:${NC}"
    echo "  ./scripts/install-linux.sh"
else
    echo -e "${RED}❌ Some required components are missing${NC}"
    echo ""
    echo -e "${YELLOW}Please install missing components and run this check again${NC}"
fi

echo ""
