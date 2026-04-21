# Configure the AWS provider
# This tells Terraform to use AWS and which region to deploy to

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.41.0"
    }
  }
}

provider "aws" {
region = var.aws_region
}