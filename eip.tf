# eip.tf

# Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "eip" {
  count      = var.az_count
  vpc        = true
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name        = "${var.app_name}-elastic-ip"
    Environment = var.app_environment
  }
}