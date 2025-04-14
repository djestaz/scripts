#!/bin/bash

# Perplexity

# Script to install Docker Engine on a Proxmox node

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Please use sudo or log in as root."
  exit 1
fi

# Update the package database
echo "Updating system packages..."
apt-get update && apt-get dist-upgrade -y

echo "Installing prerequisites..."
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "Adding Docker's official GPG key..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating package index and installing Docker Engine..."
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "Verifying Docker installation..."
docker --version && systemctl status docker

echo "Docker installation completed successfully!"
