#!/bin/bash
# WebODM Installation Script for Linux/macOS

echo "========================================"
echo "WebODM Setup - Linux/macOS Installation"
echo "========================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if running as root (not recommended for Docker)
if [ "$EUID" -eq 0 ]; then 
    echo -e "${YELLOW}Warning: Running as root is not recommended${NC}"
    echo -e "${YELLOW}Consider running without sudo if Docker is configured for non-root users${NC}"
fi

# Check Docker installation
echo -e "${YELLOW}[1/5] Checking Docker installation...${NC}"
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo -e "${GREEN}✓ Docker is installed: $DOCKER_VERSION${NC}"
else
    echo -e "${RED}✗ Docker is not installed!${NC}"
    echo -e "${YELLOW}Install Docker:${NC}"
    echo "Ubuntu: sudo apt install docker.io docker-compose"
    echo "macOS: brew install docker docker-compose"
    exit 1
fi

# Check if Docker is running
echo -e "${YELLOW}[2/5] Checking if Docker is running...${NC}"
if docker ps &> /dev/null; then
    echo -e "${GREEN}✓ Docker is running${NC}"
else
    echo -e "${RED}✗ Docker is not running!${NC}"
    echo -e "${YELLOW}Start Docker:${NC}"
    echo "Ubuntu: sudo systemctl start docker"
    echo "macOS: Open Docker Desktop"
    exit 1
fi

# Check Docker Compose installation
echo -e "${YELLOW}[3/5] Checking Docker Compose installation...${NC}"
if command -v docker-compose &> /dev/null; then
    COMPOSE_VERSION=$(docker-compose --version)
    echo -e "${GREEN}✓ Docker Compose is installed: $COMPOSE_VERSION${NC}"
else
    echo -e "${RED}✗ Docker Compose is not installed!${NC}"
    echo -e "${YELLOW}Install Docker Compose:${NC}"
    echo "Ubuntu: sudo apt install docker-compose"
    echo "macOS: brew install docker-compose"
    exit 1
fi

# Check Python installation
echo -e "${YELLOW}[4/5] Checking Python installation...${NC}"
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo -e "${GREEN}✓ Python is installed: $PYTHON_VERSION${NC}"
    
    # Install Python dependencies
    if [ -f "requirements.txt" ]; then
        echo -e "${YELLOW}Installing Python dependencies...${NC}"
        pip3 install -r requirements.txt
        echo -e "${GREEN}✓ Python dependencies installed${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Python is not installed (optional for video processing)${NC}"
    echo "Install: sudo apt install python3 python3-pip (Ubuntu) or brew install python3 (macOS)"
fi

# Pull Docker images
echo -e "${YELLOW}[5/5] Pulling WebODM Docker images...${NC}"
echo -e "${CYAN}This may take several minutes depending on your internet connection...${NC}"

if docker-compose pull; then
    echo -e "${GREEN}✓ Docker images pulled successfully${NC}"
else
    echo -e "${RED}✗ Failed to pull Docker images${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo "1. Start WebODM: ./scripts/start-webodm.sh"
echo "2. Open browser: http://localhost:8000"
echo "3. Create your first account (becomes admin)"
echo ""
