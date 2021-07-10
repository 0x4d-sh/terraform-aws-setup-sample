
# outputs.tf

output "alb_hostname" {
  value = aws_alb.application_load_balancer.dns_name
}

output "rds_endpoint" {
    value = aws_db_instance.aws_rds.endpoint
}