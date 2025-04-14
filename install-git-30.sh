#!/bin/bash

# Script to install Git on a Proxmox VE 8 node

# Update package lists
echo "Updating package lists..."
apt update -y

# Check if Git is already installed
if command -v git &>/dev/null; then
    echo "Git is already installed. Version: $(git --version)"
else
    # Install Git
    echo "Installing Git..."
    apt install -y git

    # Verify installation
    if command -v git &>/dev/null; then
        echo "Git successfully installed. Version: $(git --version)"
    else
        echo "Failed to install Git."
        exit 1
    fi
fi

echo "Git installation complete!"