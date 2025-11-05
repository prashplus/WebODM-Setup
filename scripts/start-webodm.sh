#!/bin/bash
# Start WebODM - Linux/macOS Script

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}Starting WebODM...${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Check if Docker is running
if ! docker ps &> /dev/null; then
    echo -e "${RED}✗ Docker is not running!${NC}"
    echo -e "${YELLOW}Please start Docker and try again${NC}"
    exit 1
fi

# Start WebODM using docker-compose
echo -e "${YELLOW}Starting WebODM containers...${NC}"
if docker-compose up -d; then
    echo ""
    echo -e "${GREEN}✓ WebODM is starting...${NC}"
    echo ""
    echo -e "${CYAN}Please wait 30-60 seconds for all services to initialize${NC}"
    echo ""
    echo -e "${GREEN}WebODM will be available at:${NC}"
    echo "http://localhost:8000"
    echo ""
    echo -e "${GREEN}NodeODM API will be available at:${NC}"
    echo "http://localhost:3000"
    echo ""
    echo -e "${CYAN}To view logs: docker-compose logs -f webapp${NC}"
    echo -e "${CYAN}To stop: ./scripts/stop-webodm.sh${NC}"
else
    echo -e "${RED}✗ Failed to start WebODM${NC}"
    exit 1
fi
