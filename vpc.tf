# vpc.tf

# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}

resource "aws_vpc" "aws_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name        = "${var.app_name}-vpc"
    Environment = var.app_environment
  }
}