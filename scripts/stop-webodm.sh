#!/bin/bash
# Stop WebODM - Linux/macOS Script

# Source common helpers (compose command & Apple Silicon detection)
source "$(dirname "$0")/common.sh"
init_webodm

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}Stopping WebODM...${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

if run_compose down; then
    echo ""
    echo -e "${GREEN}✓ WebODM stopped successfully${NC}"
else
    echo -e "${RED}✗ Failed to stop WebODM${NC}"
    exit 1
fi
