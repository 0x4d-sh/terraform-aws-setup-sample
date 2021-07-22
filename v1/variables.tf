# variables.tf

variable "aws_region" {
    type = string
    description = "The AWS region things are created in"
}

variable "ec2_iam_role" {
    type = string
    description = "EC2 IAM role name"
}

variable "ecs_task_execution_arn" {
    type = string
    description = "ECS task execution ARN"
}

variable "az_count" {
    type = number
    description = "Number of AZs to cover in a given region"
}

variable "cidr_block" {
    type = string
    description = "CIDR block IP range"
}

variable "app_name" {
    type = string
    description = "Application Name"
}

variable "app_ssm" {
    type = string
    description = "Username"
}

variable "app_owner" {
    type = string
    description = "Project Manager (Owner)"
}

variable "app_environment" {
    type = string
    description = "Application Environment"
}

variable "app_image" {
    type = string
    description = "Docker image to run in the ECS cluster"
}

variable "app_port" {
    type = number
    description = "Port exposed by the docker image to redirect traffic to"
}

variable "app_count" {
    type = number
    description = "Number of docker containers to run"
}

variable "db_name" {
	type = string
    description = "Database Name"
}

variable "db_user" {
	type = string
    description = "Database User"
}

variable "db_password" {
	type = string
    description = "Database Password"
}

variable "health_check_path" {
    type = string
    description = "Health Check URL path"
}

variable "fargate_cpu" {
    type = string
    description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
}

variable "fargate_memory" {
    type = string
    description = "Fargate instance memory to provision (in MiB)"
}