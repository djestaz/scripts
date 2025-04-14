#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root." 
    exit 1
fi

# Define the Portainer server URL and agent name
PORTAINER_SERVER_URL="http://<your_portainer_server_ip>:9000"  # Replace with your Portainer server IP
AGENT_NAME="portainer_agent"

# Pull the latest Portainer agent image
echo "Pulling the latest Portainer agent image..."
docker pull portainer/agent

# Run the Portainer agent container
echo "Starting Portainer agent..."
docker run -d \
    --name $AGENT_NAME \
    --restart always \
    -e AGENT_CLUSTER=1 \
    -e PORTAINER_AGENT_PORT=9001 \
    --pid=host \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    --volume /lib/modules:/lib/modules \
    portainer/agent \
    -H tcp://tasks.agent:9001

# Check if the agent is running
if [[ $(docker ps -q -f name=$AGENT_NAME) ]]; then
    echo "Portainer agent is running and ready to connect to Portainer."
else
    echo "There was an issue starting the Portainer agent."
    exit 1
fi

echo "Portainer agent installation script completed."