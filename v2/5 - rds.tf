
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

  vpc_security_group_ids     = [aws_security_group.alb.id]
  allowed_security_groups = [aws_security_group.alb.id]
  enable_audit_log = true
  enabled_cloudwatch_logs_exports = ["audit","error","general","slowquery"]

  tags = {
    Name        = "${var.app_name}-rds"
    Environment = var.app_environment
  }
}