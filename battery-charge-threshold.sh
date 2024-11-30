#!/usr/bin/env bash

# Check if script is run with sudo/root privileges
if [ "$EUID" -ne 0 ]; then 
    echo "Error: This script must be run with sudo privileges"
    echo "Please run: sudo $0"
    exit 1
fi

# Function to handle errors
handle_error() {
    local service=$1
    local action=$2
    echo "Error: Failed to $action battery-charge-threshold.service"
    echo "Please check if the service exists and try again"
    exit 1
}

# Enable the service
echo "Enabling battery charge threshold service..."
if ! systemctl enable battery-charge-threshold.service; then
    handle_error "battery-charge-threshold.service" "enable"
fi
echo "Service enabled successfully"

# Start the service
echo "Starting battery charge threshold service..."
if ! systemctl start battery-charge-threshold.service; then
    handle_error "battery-charge-threshold.service" "start"
fi
echo "Service started successfully"

# Verify service status
echo -e "\nChecking service status:"
systemctl status battery-charge-threshold.service --no-pager

echo -e "\nScript completed successfully!"
