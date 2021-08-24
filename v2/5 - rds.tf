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
  engine_mode             = "serverless"
  enable_http_endpoint    = true  
  database_name           = var.db_name
  master_username         = var.db_user
  master_password         = var.db_password
  backup_retention_period = 30
  preferred_backup_window = "07:00-09:00"

  db_subnet_group_name    = "${aws_db_subnet_group.rds.name}"
  vpc_security_group_ids     = [aws_security_group.rds_sg.id, aws_security_group.ecs_sg.id]

  skip_final_snapshot     = true
  
  scaling_configuration {
    auto_pause               = true
    min_capacity             = 1    
    max_capacity             = 2
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }  

  tags = {
    Name        = "${var.app_name}-rds"
    Environment = var.app_environment
  }
}