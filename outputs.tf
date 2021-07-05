
# outputs.tf

output "alb_hostname" {
  value = aws_alb.application_load_balancer.dns_name
}

output "mysql_endpoint" {
    value = aws_db_instance.mysql.endpoint
}

output "ecr_repository_worker_endpoint" {
    value = aws_ecr_repository.worker.repository_url
}