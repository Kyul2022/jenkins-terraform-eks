#!/bin/bash

# Update system packages
sudo yum update -y

# Install Docker
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# Install Git
sudo yum install -y git

# Install Terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install -y terraform

# Install kubectl
sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mkdir -p /usr/local/bin
sudo mv ./kubectl /usr/local/bin/kubectl

# Verify installations
echo "Docker version:"
docker --version
echo "Git version:"
git --version
echo "Terraform version:"
terraform --version
echo "kubectl version:"
kubectl version --client
