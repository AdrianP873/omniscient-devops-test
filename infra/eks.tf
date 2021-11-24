locals {
  common_tags = {
      environment = var.environment
      owner       = var.code_owner
      repo        = var.repository
  }
}

resource "aws_ecr_repository" "hello_world_repo" {
  name                 = "hello-world"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.common_tags
}


resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    subnet_ids = concat(module.vpc.private_subnets, module.vpc.public_subnets)
  }

  depends_on = [
    aws_iam_role.cluster_role,
    aws_iam_role.worker_node_role,
    module.vpc
  ]
}


resource "aws_eks_node_group" "nodegroup" {
  cluster_name    = var.cluster_name
  node_group_name = "eks-nodegroup-${var.environment}"
  node_role_arn   = aws_iam_role.worker_node_role.arn
  subnet_ids      = module.vpc.private_subnets

  scaling_config {
    desired_size = var.node_group_desired_capacity
    max_size     = var.node_group_max_capacity
    min_size     = var.node_group_min_capacity
  }

  labels = {
    Environment = var.environment
  }
  
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config[0].desired_size]
  }

  depends_on = [
    aws_eks_cluster.cluster
  ]

  tags = local.common_tags

}