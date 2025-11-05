#!/bin/bash
# WebODM Utilities - Linux/macOS Script
# Collection of useful commands for managing WebODM

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

show_menu() {
    echo ""
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}WebODM Utilities${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""
    echo "1. View logs"
    echo "2. Check status"
    echo "3. Clean unused data"
    echo "4. Backup data"
    echo "5. Restart services"
    echo "6. Exit"
    echo ""
}

show_logs() {
    echo -e "${YELLOW}📋 Showing WebODM logs (Ctrl+C to exit)...${NC}"
    docker-compose logs -f webapp
}

show_status() {
    echo -e "${YELLOW}📊 WebODM Service Status:${NC}"
    docker-compose ps
    echo ""
    echo -e "${YELLOW}💾 Disk Usage:${NC}"
    docker system df
}

clean_data() {
    echo -e "${YELLOW}🧹 Cleaning unused Docker data...${NC}"
    echo -e "${CYAN}This will remove unused containers, networks, and images.${NC}"
    read -p "Continue? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker system prune -f
        echo -e "${GREEN}✓ Cleanup complete${NC}"
    fi
}

backup_data() {
    timestamp=$(date +"%Y%m%d_%H%M%S")
    backup_dir="backups/webodm_backup_$timestamp"
    
    echo -e "${YELLOW}💾 Creating backup...${NC}"
    mkdir -p "$backup_dir"
    
    # Backup volumes
    docker run --rm -v webodm-setup_webodm-data:/data -v $(pwd)/$backup_dir:/backup alpine tar czf /backup/webodm-data.tar.gz -C /data .
    docker run --rm -v webodm-setup_postgres-data:/data -v $(pwd)/$backup_dir:/backup alpine tar czf /backup/postgres-data.tar.gz -C /data .
    
    echo -e "${GREEN}✓ Backup created at: $backup_dir${NC}"
}

restart_services() {
    echo -e "${YELLOW}🔄 Restarting WebODM services...${NC}"
    docker-compose restart
    echo -e "${GREEN}✓ Services restarted${NC}"
}

# Main logic
if [ $# -eq 1 ]; then
    case "$1" in
        logs) show_logs ;;
        status) show_status ;;
        clean) clean_data ;;
        backup) backup_data ;;
        restart) restart_services ;;
        *) echo "Invalid action. Use: logs, status, clean, backup, or restart" ;;
    esac
else
    while true; do
        show_menu
        read -p "Select an option (1-6): " choice
        
        case $choice in
            1) show_logs ;;
            2) show_status ;;
            3) clean_data ;;
            4) backup_data ;;
            5) restart_services ;;
            6) exit 0 ;;
            *) echo -e "${RED}Invalid option${NC}" ;;
        esac
    done
fi
