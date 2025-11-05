#!/bin/bash
# Update WebODM - Linux/macOS Script

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}Updating WebODM...${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Stop WebODM if running
echo -e "${YELLOW}[1/3] Stopping WebODM...${NC}"
docker-compose down

# Pull latest images
echo -e "${YELLOW}[2/3] Pulling latest Docker images...${NC}"
if docker-compose pull; then
    echo -e "${GREEN}✓ Images updated successfully${NC}"
else
    echo -e "${RED}✗ Failed to pull images${NC}"
    exit 1
fi

# Start WebODM
echo -e "${YELLOW}[3/3] Starting WebODM...${NC}"
if docker-compose up -d; then
    echo ""
    echo -e "${GREEN}✓ WebODM updated and started successfully${NC}"
    echo ""
    echo "WebODM is available at: http://localhost:8000"
else
    echo -e "${RED}✗ Failed to start WebODM${NC}"
    exit 1
fi
