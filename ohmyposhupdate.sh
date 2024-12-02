#!/usr/bin/env bash

# Check if script is run with sudo privileges
if [ "$EUID" -ne 0 ]; then 
    echo "Error: This script must be run with sudo privileges"
    echo "Please run: sudo $0"
    exit 1
fi

# Function to check internet connectivity
check_connection() {
    echo "Checking internet connectivity..."
    # Try to connect to GitHub (since that's where we're downloading from)
    if ! ping -c 1 github.com &> /dev/null; then
        if ! wget -q --spider https://github.com; then
            echo "Error: No internet connection or GitHub is not accessible"
            return 1
        fi
    fi
    echo "Internet connectivity confirmed"
    return 0
}

# Check if oh-my-posh is installed
if ! command -v oh-my-posh &> /dev/null; then
    echo "Error: oh-my-posh is not installed"
    exit 1
fi

# Check internet connectivity before proceeding
if ! check_connection; then
    exit 1
fi

# Store the current version
echo "Checking current version of Oh My Posh..."
if ! current_version=$(oh-my-posh --version); then
    echo "Error: Failed to get current version"
    exit 1
fi
echo "Current version: $current_version"

# Create temporary directory for download
temp_dir=$(mktemp -d)
cd "$temp_dir" || exit 1

echo "Downloading latest version of Oh My Posh..."
if ! wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O oh-my-posh.new; then
    echo "Error: Download failed"
    rm -rf "$temp_dir"
    exit 1
fi

# Make the new binary executable
chmod +x oh-my-posh.new

# Verify the new binary works before installing
echo "Verifying downloaded binary..."
if ! ./oh-my-posh.new --version &> /dev/null; then
    echo "Error: Downloaded binary verification failed"
    rm -rf "$temp_dir"
    exit 1
fi

# Install the new binary
echo "Installing new version..."
if ! mv oh-my-posh.new /usr/local/bin/oh-my-posh; then
    echo "Error: Installation failed"
    rm -rf "$temp_dir"
    exit 1
fi

# Clean up
rm -rf "$temp_dir"

# Get new version
if ! new_version=$(oh-my-posh --version); then
    echo "Error: Failed to get new version"
    exit 1
fi

echo -e "\nUpdate completed successfully!"
echo "Previous version: $current_version"
echo "New version: $new_version"

# Check if version changed
if [ "$current_version" = "$new_version" ]; then
    echo "Note: You were already on the latest version"
fi
