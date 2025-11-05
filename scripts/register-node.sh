#!/bin/bash
# Script to automatically register the NodeODM processing node with WebODM

echo "Checking if NodeODM processing node is registered..."

# Wait a bit for the webapp to be fully ready
sleep 5

# Add the processing node if it doesn't exist
# The command will fail if the node already exists, which is fine
python /webodm/manage.py addnode node-odm-1 3000 --label "NodeODM-1" 2>/dev/null || true

echo "Processing node registration complete."
