# Terraform Configuration for Task API

This directory contains Terraform configuration to provision an EC2 instance running your Task API Docker container on AWS.

## Files

- **provider.tf** — AWS provider configuration
- **main.tf** — EC2 instance, security group, and user data script
- **variables.tf** — Input variables
- **outputs.tf** — Output values (IP address, endpoints, etc.)
- **user_data.sh** — Script that runs on instance startup (installs Docker, pulls image)
- **terraform.tfvars.example** — Template for your variables

## Prerequisites

1. **Terraform installed** — [Download here](https://www.terraform.io/downloads)
2. **AWS Account** with credentials configured:
   ```bash
   aws configure
   ```
3. **Docker image published** to Docker Hub (e.g., `yourusername/task-api:dev`)

## Setup & Deployment

### 1. Initialize Terraform

```bash
cd terraform
terraform init
```

### 2. Create terraform.tfvars

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and update:

- `aws_region` (default: eu-west-1)
- `docker_image` — your Docker Hub image URI
- `allowed_ssh_cidr` — restrict SSH to your IP for security (optional but recommended)

### 3. Plan the deployment

```bash
terraform plan
```

This shows what resources will be created.

### 4. Apply the configuration

```bash
terraform apply
```

Terraform will ask for confirmation. Type `yes` to proceed.

This will:

- Create an EC2 instance (t2.micro)
- Create a security group (allows ports 22, 80, 443, 3000)
- Run user_data.sh to install Docker and start your container

### 5. Access your API

After deployment, Terraform outputs:

- `instance_public_ip` — Your instance's public IP
- `api_endpoint` — Direct link to your API: `http://<IP>:3000`

Curl your API:

```bash
curl http://<instance-public-ip>:3000/tasks
```

## Managing the Deployment

### View current state

```bash
terraform state list
terraform show
```

### Update variables

Edit `terraform.tfvars` and run:

```bash
terraform apply
```

### Destroy everything (removes EC2 instance)

```bash
terraform destroy
```

## SSH into the Instance

```bash
ssh -i ~/.ssh/your-aws-key.pem ubuntu@<instance-public-ip>
```

Once logged in, check Docker container status:

```bash
docker ps
docker logs task-api
```

## Notes

- **Free tier eligible:** t2.micro instance is included in AWS free tier (if your account is eligible)
- **Auto-restart:** Container is configured with `--restart always` so it recovers from crashes
- **Port 3000:** Your API runs on port 3000 (exposed to the public)
- **Security:** SSH is open to the world by default. Restrict `allowed_ssh_cidr` to your IP for production

## Troubleshooting

### Container not starting?

SSH into the instance and check logs:

```bash
docker logs task-api
```

### Image pull failed?

Ensure:

- Docker image is pushed to Docker Hub
- Docker image name in terraform.tfvars is correct (format: `username/repo:tag`)

### Terraform apply fails?

- Check AWS credentials: `aws sts get-caller-identity`
- Ensure you have permissions to create EC2, security groups, etc.
