#!/bin/bash
# System Requirements Check for WebODM
# Run this script to verify your system meets the requirements

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}WebODM System Requirements Check${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

all_checks_passed=true

# Check OS
echo -e "${YELLOW}[1/8] Checking operating system...${NC}"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "${GREEN}✓ Operating System: Linux${NC}"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "${GREEN}✓ Operating System: macOS${NC}"
else
    echo -e "${RED}✗ Unsupported operating system${NC}"
    all_checks_passed=false
fi

# Check bash version
echo -e "${YELLOW}[2/8] Checking bash version...${NC}"
bash_version=${BASH_VERSION%%[^0-9]*}
if [ "$bash_version" -ge 4 ]; then
    echo -e "${GREEN}✓ Bash version: $BASH_VERSION${NC}"
else
    echo -e "${YELLOW}⚠ Bash version: $BASH_VERSION (4.0+ recommended)${NC}"
fi

# Check Docker installation
echo -e "${YELLOW}[3/8] Checking Docker installation...${NC}"
if command -v docker &> /dev/null; then
    docker_version=$(docker --version)
    echo -e "${GREEN}✓ Docker installed: $docker_version${NC}"
    
    # Check if Docker is running
    echo -e "${YELLOW}[4/8] Checking if Docker is running...${NC}"
    if docker ps &> /dev/null; then
        echo -e "${GREEN}✓ Docker is running${NC}"
    else
        echo -e "${RED}✗ Docker is not running${NC}"
        echo -e "${YELLOW}  Start with: sudo systemctl start docker (Linux)${NC}"
        all_checks_passed=false
    fi
else
    echo -e "${RED}✗ Docker not found${NC}"
    echo -e "${YELLOW}  Install: https://docs.docker.com/get-docker/${NC}"
    all_checks_passed=false
fi

# Check Docker Compose
echo -e "${YELLOW}[5/8] Checking Docker Compose...${NC}"
if command -v docker-compose &> /dev/null; then
    compose_version=$(docker-compose --version)
    echo -e "${GREEN}✓ Docker Compose installed: $compose_version${NC}"
else
    echo -e "${RED}✗ Docker Compose not found${NC}"
    all_checks_passed=false
fi

# Check Python installation
echo -e "${YELLOW}[6/8] Checking Python installation...${NC}"
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
echo -e "${YELLOW}[7/8] Checking system RAM...${NC}"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    ram_gb=$((ram_kb / 1024 / 1024))
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ram_bytes=$(sysctl hw.memsize | awk '{print $2}')
    ram_gb=$((ram_bytes / 1024 / 1024 / 1024))
fi

if [ "$ram_gb" -ge 8 ]; then
    echo -e "${GREEN}✓ Available RAM: ${ram_gb}GB${NC}"
else
    echo -e "${YELLOW}⚠ Available RAM: ${ram_gb}GB (8GB+ recommended)${NC}"
fi

# Check available disk space
echo -e "${YELLOW}[8/8] Checking available disk space...${NC}"
disk_avail=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
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
