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
  engine_version          = "5.7.34"

  database_name           = var.db_name
  master_username         = var.db_user
  master_password         = aws_secretsmanager_secret_version.default.secret_string

  db_subnet_group_name    = "${aws_db_subnet_group.rds.name}"
  vpc_security_group_ids  = [aws_security_group.rds_sg.id, aws_security_group.ecs_sg.id]

  allocated_storage       = 20
  max_allocated_storage   = 200

  publicly_accessible     = true
  monitoring_interval     = "30"
  monitoring_role_arn     = data.aws_iam_role.rds_monitoring_role.arn

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  enabled_cloudwatch_logs_exports       = ["audit", "error", "general", "slowquery"]

  backup_retention_period = 30
  preferred_backup_window = "07:00-09:00"

  allow_major_version_upgrade = true

  skip_final_snapshot     = true

  tags = {
    Name        = "${var.app_name}-rds"
    Environment = var.app_environment
  }
}

resource "aws_rds_cluster_instance" "default" {
  count              = 1
  identifier         = "${var.app_name}-${var.app_environment}-rds-${count.index}"
  cluster_identifier = aws_rds_cluster.default.id
  
  instance_class     = "db.m5.large"
  engine             = aws_rds_cluster.default.engine
  engine_version     = aws_rds_cluster.default.engine_version

  tags = {
    Name        = "${var.app_name}-rds-${count.index}"
    Environment = var.app_environment
  }
}