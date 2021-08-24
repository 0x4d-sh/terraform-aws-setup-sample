data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_rds_cluster" "default" {
  cluster_identifier      = "${var.app_name}-${var.app_environment}-rds"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.03.2"
  availability_zones      = data.aws_availability_zones.available
  database_name           = var.db_name
  master_username         = var.db_user
  master_password         = var.db_password
  backup_retention_period = 30
  preferred_backup_window = "07:00-09:00"

  vpc_id  = aws_vpc.aws_vpc.id
  subnets = aws_subnet.private.*.id

  replica_count           = 1
  allowed_security_groups = [aws_security_group.alb.id]

  monitoring_interval = 10
  enabled_cloudwatch_logs_exports = ["sec-dev-mgmt-domain-mysql"]

  tags = {
    Name        = "${var.app_name}-rds"
    Environment = var.app_environment
  }
}