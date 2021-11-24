output ecr_repository_arn {
    description = "ARN of the ECR repository."
    value       = aws_ecr_repository.hello_world_repo.arn
}

output "endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}