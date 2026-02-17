#!/bin/bash
# Update WebODM - Linux/macOS Script

# Source common helpers (compose command & Apple Silicon detection)
source "$(dirname "$0")/common.sh"
init_webodm

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}Updating WebODM...${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# Stop WebODM if running
echo -e "${YELLOW}[1/3] Stopping WebODM...${NC}"
run_compose down

# Pull latest images
echo -e "${YELLOW}[2/3] Pulling latest Docker images...${NC}"
if run_compose pull; then
    echo -e "${GREEN}✓ Images updated successfully${NC}"
else
    echo -e "${RED}✗ Failed to pull images${NC}"
    exit 1
fi

# Start WebODM
echo -e "${YELLOW}[3/3] Starting WebODM...${NC}"
if run_compose up -d; then
    echo ""
    echo -e "${GREEN}✓ WebODM updated and started successfully${NC}"
    echo ""
    echo "WebODM is available at: http://localhost:8000"
else
    echo -e "${RED}✗ Failed to start WebODM${NC}"
    exit 1
fi
