resource "aws_eks_cluster" "myapp_eks_cluster" {
  name     = "myapp-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.24"

  vpc_config {
    subnet_ids = aws_subnet.private_subnets[*].id
  }

  tags = {
    environment = "development"
    application = "myapp"
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "myapp-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "eks.amazonaws.com" }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_policy" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ])

  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = each.value
}

resource "aws_eks_node_group" "myapp_node_group" {
  cluster_name    = aws_eks_cluster.myapp_eks_cluster.name
  node_role       = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = aws_subnet.private_subnets[*].id
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t2.small"]

  tags = {
    environment = "development"
    application = "myapp"
  }
}

resource "aws_iam_role" "eks_node_group_role" {
  name = "myapp-eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_group_role_policy" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ])

  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = each.value
}
