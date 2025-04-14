#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root." 
    exit 1
fi

# Update package lists
echo "Updating package lists..."
apt update

# Install Git
echo "Installing Git..."
apt install -y git

# Verify installation
echo "Verifying Git installation..."
git --version

echo "Git installation script completed successfully."