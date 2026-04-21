# Configure the AWS provider
# This tells Terraform to use AWS and which region to deploy to

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.41.0"
    }
  }

  backend "s3" {
    bucket       = "task-api-tf-state-471112980487"
    key          = "dev/terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
    encrypt      = true
  }
}


provider "aws" {
  region = var.aws_region
}