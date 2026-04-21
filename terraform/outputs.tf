# Outputs from Terraform
# These display useful information after deployment

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.task_api.id
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.task_api.public_ip
}

output "instance_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.task_api.private_ip
}

output "api_endpoint" {
  description = "The endpoint to access your Task API"
  value       = "http://${aws_instance.task_api.public_ip}:3000"
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i task-api.pem ubuntu@${aws_instance.task_api.public_ip}"
}

output "security_group_id" {
  description = "The security group ID"
  value       = aws_security_group.task_api.id
}
