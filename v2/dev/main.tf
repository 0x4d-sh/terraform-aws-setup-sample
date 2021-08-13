module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "aws-vpc"
  cidr = var.aws_cidr

  azs             = var.aws_azs
  private_subnets = var.aws_prv_sub
  public_subnets  = var.aws_pub_sub

    enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.aws_proj_name}-vpc"
    Terraform = "true"
    Environment = "dev"
  }
}