#!/usr/bin/env bash

# Check if script is run with sudo/root privileges
if [ "$EUID" -ne 0 ]; then 
    echo "Error: This script must be run with sudo privileges"
    echo "Please run: sudo $0"
    exit 1
fi

# Function to handle errors
handle_error() {
    local action=$1
    echo "Error: Failed to $action"
    exit 1
}

# Update package lists
echo "Updating package lists..."
if ! apt update; then
    handle_error "update package lists"
fi
echo "Package lists updated successfully"

# Upgrade packages
echo "Upgrading packages..."
if ! apt upgrade -y; then
    handle_error "upgrade packages"
fi
echo -e "\nSystem update completed successfully!"

# Optionally display system information
echo -e "\nSystem status:"
echo "Available disk space:"
df -h /
