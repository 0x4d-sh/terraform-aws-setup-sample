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

variable "app_environment" {
    type = string
    description = "Application Environment"
}

variable "app_image" {
    type = string
    description = "Docker image to run in the ECS cluster"
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