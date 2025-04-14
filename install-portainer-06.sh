#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Function to check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Docker is not installed. Please install Docker first."
        exit 1
    fi
}

# Check if Docker is installed
check_docker

# Pull the latest Portainer image
echo "Pulling the latest Portainer image..."
docker pull portainer/portainer-ce

# Create a new Docker volume for Portainer data
echo "Creating Docker volume for Portainer data..."
docker volume create portainer_data

# Run Portainer as a Docker container
echo "Starting Portainer container..."
docker run -d \
    --name portainer \
    --restart always \
    -p 9000:9000 \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume portainer_data:/data \
    portainer/portainer-ce

# Check if Portainer is running
if [[ $(docker ps -q -f name=portainer) ]]; then
    echo "Portainer is running and accessible at http://<your_proxmox_node_ip>:9000"
else
    echo "There was an issue starting Portainer."
    exit 1
fi

echo "Portainer installation script completed."