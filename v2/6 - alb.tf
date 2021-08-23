# alb.tf

resource "aws_alb" "application_load_balancer" {
  name            = "${var.app_name}-${var.app_environment}-alb"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.alb.id]
}

resource "aws_alb_target_group" "target_group" {
  name        = "${var.app_name}-${var.app_environment}-target-group"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.aws_vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  depends_on = [
    aws_vpc.aws_vpc
  ]
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.target_group.id
    type             = "forward"
  }
}