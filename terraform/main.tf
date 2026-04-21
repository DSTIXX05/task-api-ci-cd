# Security Group for EC2 instance
# Controls inbound and outbound traffic

resource "aws_security_group" "task_api" {
  name_prefix = "task-api-sg-"
  description = "Security group for Task API EC2 instance"

  # Allow SSH (port 22) from your IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS (port 443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow your API port (3000)
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "task-api-sg"
  }
}

# EC2 Instance
# This is your server that will run the Docker container

resource "aws_instance" "task_api" {
  # Use Ubuntu 22.04 LTS as the base OS (free tier eligible)
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  # Attach the security group
  security_groups = [aws_security_group.task_api.name]

  # Run the user data script on startup
  user_data = <<-EOF
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
    echo "Pulling Docker image: ${var.docker_image}"
    if docker pull ${var.docker_image}; then
      echo "Image pulled successfully"
    else
      echo "ERROR: Failed to pull image ${var.docker_image}"
      exit 1
    fi

    # Run the container
    echo "Starting container..."
    docker run -d \
      --restart always \
      -p 3000:3000 \
      --name task-api \
      ${var.docker_image}

    echo "Task API container is running on port 3000"
    echo "User data script completed at $(date)"
  EOF

  # Assign public IP if enabled
  associate_public_ip_address = var.enable_public_ip

  #user_data rerun on already created instance.
  user_data_replace_on_change = true

  # Storage configuration  

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20 # 20GB is sufficient for Docker + app
    delete_on_termination = true
  }

  #private key to ssh
  key_name = "task-api"


  tags = {
    Name = var.instance_name
  }

  depends_on = [aws_security_group.task_api]
}

# Data source to get the latest Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu maintainer)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
