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

  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.07.5"

  database_name           = var.db_name
  master_username         = var.db_user
  master_password         = aws_secretsmanager_secret_version.default.secret_string

  db_subnet_group_name    = "${aws_db_subnet_group.rds.name}"
  vpc_security_group_ids  = [aws_security_group.rds_sg.id, aws_security_group.ecs_sg.id]
  
  # backup_retention_period = 30
  # preferred_backup_window = "07:00-09:00"
  
  enabled_cloudwatch_logs_exports       = ["audit", "error", "general", "slowquery"]
  
  apply_immediately           = true
  skip_final_snapshot         = true
  allow_major_version_upgrade = true
  
  tags = {
    Name        = "${var.app_name}-rds"
    Environment = var.app_environment
  }
}

resource "aws_rds_cluster_instance" "default" {
  count              = 1
  identifier         = "${var.app_name}-${var.app_environment}-rds-${count.index}"
  cluster_identifier = aws_rds_cluster.default.id
  
  instance_class     = "db.m5"
  engine             = aws_rds_cluster.default.engine
  engine_version     = aws_rds_cluster.default.engine_version

  publicly_accessible     = true
  monitoring_interval     = 30
  monitoring_role_arn     = data.aws_iam_role.rds_monitoring_role.arn

  performance_insights_enabled          = true

  tags = {
    Name        = "${var.app_name}-rds"
    Environment = var.app_environment
  }
}