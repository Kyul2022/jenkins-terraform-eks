module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "myapp-eks-cluster"
  cluster_version = "1.24"

  # Public endpoint access
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

  # VPC configuration
  vpc_id     = module.myapp-vpc.vpc_id
  subnet_ids = module.myapp-vpc.private_subnets

  # Tags for resources
  tags = {
    environment = "development"
    application = "myapp"
  }

  eks_managed_node_groups = {
    dev = {
      min_size     = 1
      max_size     = 5
      desired_size = 2

      instance_types        = ["t3.medium"]
      key_name              = "my-key-pair" # Replace with your actual key pair
      disk_size             = 20            # Adjust as needed
      iam_role_additional_policies = [
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      ]

      labels = {
        environment = "development"
        application = "myapp"
      }

      taints = [
        {
          key    = "workload-type"
          value  = "critical"
          effect = "NO_SCHEDULE"
        }
      ]
    }
  }

  # Enable EKS add-ons for better functionality
  eks_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  # Logging Configuration
  cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}
