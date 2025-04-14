#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update package index and install prerequisites
echo "Updating package index and installing prerequisites..."
sudo apt-get update -y
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
echo "Adding Docker's official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the stable repository for Docker
echo "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package index again
echo "Updating package index after adding Docker repository..."
sudo apt-get update -y

# Install Docker Engine, CLI, and containerd
echo "Installing Docker Engine, CLI, and containerd..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker service
echo "Starting and enabling Docker service..."
sudo systemctl enable --now docker

# Verify installation by running hello-world container
echo "Verifying Docker installation..."
sudo docker run hello-world

echo "Docker Engine installation completed successfully!"