#!/bin/bash
# Common helper functions for WebODM scripts
# Source this file from other scripts: source "$(dirname "$0")/common.sh"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Detect Docker Compose command (v2 plugin vs v1 standalone)
# Uses an array so that 'docker compose' splits correctly in both bash and zsh.
detect_compose_cmd() {
    if docker compose version &> /dev/null; then
        COMPOSE_CMD=(docker compose)
    elif command -v docker-compose &> /dev/null; then
        COMPOSE_CMD=(docker-compose)
    else
        echo -e "${RED}✗ Neither 'docker compose' nor 'docker-compose' found!${NC}"
        echo -e "${YELLOW}Install Docker Desktop (includes Compose) or install docker-compose separately.${NC}"
        exit 1
    fi
}

# Detect if running on macOS Apple Silicon and set the compose file accordingly
detect_compose_file() {
    # Support both bash (BASH_SOURCE) and zsh (${(%):-%x})
    local _src="${BASH_SOURCE[0]:-${(%):-%x}}"
    SCRIPT_DIR="$(cd "$(dirname "$_src")" && pwd)"
    PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

    COMPOSE_FILE="$PROJECT_DIR/docker-compose.yml"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        ARCH=$(uname -m)
        if [[ "$ARCH" == "arm64" ]]; then
            COMPOSE_FILE="$PROJECT_DIR/docker-compose.apple-silicon.yml"
            echo -e "${CYAN}Detected macOS Apple Silicon (arm64) — using CPU-only compose file${NC}"
        fi
    fi
}

# Run docker compose with the correct command and compose file
run_compose() {
    "${COMPOSE_CMD[@]}" -f "$COMPOSE_FILE" "$@"
}

# Initialize: call both detection functions
init_webodm() {
    detect_compose_cmd
    detect_compose_file
}
