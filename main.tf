provider "aws" {
  region = "us-west-2"  
}

# VPC, Subnets, and Security Groups Configuration
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "eks_subnet_a" {
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "eks_subnet_b" {
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_security_group" "eks_sg" {
  name        = "eks-security-group"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.eks_vpc.id
}

resource "aws_security_group_rule" "allow_all_inbound" {
  security_group_id = aws_security_group.eks_sg.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
}

# ECR Repository Configuration
resource "aws_ecr_repository" "my_app" {
  name = "my-app-repo"
}

# IAM Role for EKS
resource "aws_iam_role" "eks_role" {
  name = "eks-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Effect = "Allow"
      Sid    = ""
    }]
  })
}

# IAM Policy Attachment for EKS Role
resource "aws_iam_role_policy_attachment" "eks_policy_attach" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# IAM Role for Jenkins
resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Effect = "Allow"
      Sid    = ""
    }]
  })
}

# IAM Policy Attachment for Jenkins Role
resource "aws_iam_role_policy_attachment" "jenkins_policy_attach" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECRFullAccess"
}

# EKS Cluster Configuration
resource "aws_eks_cluster" "my_eks_cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.eks_subnet_a.id, aws_subnet.eks_subnet_b.id]
    security_group_ids = [aws_security_group.eks_sg.id]
  }
}

# EKS Node Group Configuration
resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_eks_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.jenkins_role.arn
  subnet_ids      = [aws_subnet.eks_subnet_a.id, aws_subnet.eks_subnet_b.id]

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }
}

# Outputs for EKS Cluster and ECR Repo
output "eks_cluster_name" {
  value = aws_eks_cluster.my_eks_cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.my_eks_cluster.endpoint
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.my_eks_cluster.arn
}

output "ecr_repo_url" {
  value = aws_ecr_repository.my_app.repository_url
}
