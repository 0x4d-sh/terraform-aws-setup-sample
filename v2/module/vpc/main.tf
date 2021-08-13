# Fetch AZs in the current region
data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_vpc" "default" {
  cidr_block = var.cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project}-vpc"
    Owner       = var.owner
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name        = "${var.project}-igw"
    Owner       = var.owner
    Environment = var.environment
  }
}
# 1. public igw
# 2. private with igw (so have internet)
# 3. Private with endpoints (for ssm + ec2)

# Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "nat" {
  count      = length(var.private_subnets)
  vpc        = true

  tags = {
    Name        = "${var.project}-eip"
    Owner       = var.owner
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.default]
}

resource "aws_nat_gateway" "default" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.eip.*.id, count.index)

  tags = {
    Name        = "${var.app_name}-nat-${count.index + 1}"
    Environment = var.app_environment
  }

  depends_on    = [aws_internet_gateway.default, aws_eip.nat]
}

# Route table for private subnets
resource "aws_route_table" "private" {
  count = length(var.private_subnet)

  vpc_id = aws_vpc.default.id

  tags = {
    Name        = "${var.project}-rt-private"
    Owner       = var.owner
    Environment = var.environment
  }
}