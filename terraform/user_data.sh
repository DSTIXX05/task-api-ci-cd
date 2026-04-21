#!/bin/bash

# User data script for EC2 instance
# Runs as root on first boot
# Installs Docker and pulls your image

set -e # Exit on any error

# Log all output to a file for debugging
exec >> /var/log/user-data.log 2>&1
echo "Starting user data script at $(date)"

# Update system packages
echo "Updating packages..."
apt-get update
apt-get upgrade -y

# Install Docker
echo "Installing Docker..."
apt-get install -y docker.io

# Enable Docker service to start on boot
echo "Starting Docker service..."
systemctl enable docker
systemctl start docker

# Wait for Docker daemon to be ready
sleep 5

# Add ubuntu user to docker group (so we don't need sudo)
usermod -aG docker ubuntu

# Pull the Docker image from Docker Hub
echo "Pulling Docker image: ${docker_image}"
if docker pull ${docker_image}; then
  echo "Image pulled successfully"
else
  echo "ERROR: Failed to pull image ${docker_image}"
  exit 1
fi

# Run the container
echo "Starting container..."
docker run -d \
  --restart always \
  -p 3000:3000 \
  --name task-api \
  ${docker_image}

echo "Task API container is running on port 3000"
echo "User data script completed at $(date)"
