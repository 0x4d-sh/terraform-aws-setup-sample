# ecs.tf

resource "aws_ecs_cluster" "aws_ecs_cluster" {
  name = "${var.app_name}-${var.app_environment}-cluster"
}

data "template_file" "in_app" {
  template = file("./templates/app.json.tpl")

  vars = {
    app_name        = var.app_name
    app_environment = var.app_environment
    app_image       = var.app_image
    app_port        = var.app_port
    db_url          = var.db_url
    db_name         = var.db_name
    db_user         = var.db_user 
    db_password     = var.db_password
    fargate_cpu     = var.fargate_cpu
    fargate_memory  = var.fargate_memory
    aws_region      = var.aws_region
    sso_ssp         = var.sso_ssp
    sso_metadata    = var.sso_metadata
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.app_name}-${var.app_environment}-task"
  execution_role_arn       = var.ecs_task_execution_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.in_app.rendered
}

resource "aws_ecs_service" "aws_ecs_service" {
  name            = "${var.app_name}-${var.app_environment}-service"
  cluster         = aws_ecs_cluster.aws_ecs_cluster.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.target_group.id
    container_name   = "${var.app_name}"
    container_port   = var.app_port
  }

  depends_on = [
    aws_alb_listener.front_end, 
    # aws_iam_role_policy_attachment.ecs_task_execution_role
  ]
}