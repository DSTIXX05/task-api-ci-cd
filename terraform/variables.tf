# Variables for the Terraform configuration
# These are inputs that you can customize

variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "EC2 instance type (t2.micro is free tier eligible)"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "task-api-server"
}

variable "docker_image" {
  description = "Docker image URI (e.g., yourusername/task-api:dev)"
  type        = string
  default     = "dstixx05/task-api:dev"
}

variable "enable_public_ip" {
  description = "Whether to assign a public IP to the instance"
  type        = bool
  default     = true
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access (restrict for security)"
  type        = string
  default     = "0.0.0.0/0" # WARNING: This allows SSH from anywhere. Restrict to your IP for production
}
