module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name = "base-vpc-${var.environment}"
    cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-2a", "ap-southeast-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  
  public_subnet_tags = {"kubernetes.io/cluster/${var.cluster_name}"="shared"}
  private_subnet_tags = {"kubernetes.io/cluster/${var.cluster_name}"="shared"}

  tags = local.common_tags
}