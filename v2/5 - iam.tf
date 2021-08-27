data "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_iam_role" "rds_monitoring_role" {
  name = "rds-monitoring-role"
}