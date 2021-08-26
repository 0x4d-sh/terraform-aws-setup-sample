resource "aws_db_subnet_group" "rds" {
  name       = "rds"
  subnet_ids = aws_subnet.private.*.id

  tags = {
    Name        = "${var.app_name}-rds-subnet"
    Environment = var.app_environment
  }
}

resource "aws_rds_cluster" "default" {
  cluster_identifier      = "${var.app_name}-${var.app_environment}-rds"
  engine                  = "mysql"
  engine_version          = "5.7.34"
  database_name           = var.db_name
  master_username         = var.db_user
  master_password         = aws_secretsmanager_secret.database_password_secret.arn

  allocated_storage       = 100
  max_allocated_storage   = 200

  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"

  publicly_accessible     = true
  monitoring_interval     = "30"
  monitoring_role_name    = "AWSServiceRoleForRDS"
  create_monitoring_role  = false

  auto_minor_version_upgrade = "30"
  performance_insights_enabled = true
  performance_insights_retention_period = 30
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  backup_retention_period = 30
  preferred_backup_window = "07:00-09:00"

  db_subnet_group_name    = "${aws_db_subnet_group.rds.name}"
  vpc_security_group_ids  = [aws_security_group.rds_sg.id, aws_security_group.ecs_sg.id]

  skip_final_snapshot     = true

  tags = {
    Name        = "${var.app_name}-rds"
    Environment = var.app_environment
  }
}