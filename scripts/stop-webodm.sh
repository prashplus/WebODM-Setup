#!/bin/bash
# Stop WebODM - Linux/macOS Script

GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}Stopping WebODM...${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

if docker-compose down; then
    echo ""
    echo -e "${GREEN}✓ WebODM stopped successfully${NC}"
else
    echo -e "${RED}✗ Failed to stop WebODM${NC}"
    exit 1
fi
