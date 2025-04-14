#!/bin/bash

# Perplexity

# Script to install Docker Engine on a Proxmox node

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Update the package database
echo "Updating package database..."
apt-get update

# Install necessary packages to allow apt to use a repository over HTTPS
echo "Installing required packages..."
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
echo "Adding Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Add Docker repository
echo "Adding Docker repository..."
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the package database again
echo "Updating package database again..."
apt-get update

# Install Docker Engine
echo "Installing Docker Engine..."
apt-get install -y docker-ce

# Verify Docker installation
echo "Verifying Docker installation..."
if docker --version > /dev/null 2>&1; then
    echo "Docker installed successfully!"
else
    echo "There was an issue installing Docker."
    exit 1
fi

# Start Docker service
echo "Starting Docker service..."
systemctl start docker

# Enable Docker to start on boot
echo "Enabling Docker to start on boot..."
systemctl enable docker

# Optionally add the current user to the Docker group
echo "Do you want to add the current user to the Docker group? (y/n)"
read -r USER_INPUT
if [[ "$USER_INPUT" == "y" || "$USER_INPUT" == "Y" ]]; then
    usermod -aG docker "$USER"
    echo "You need to log out and log back in for the changes to take effect."
fi

echo "Docker installation script completed."
