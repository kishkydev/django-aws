variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-west"
}

variable "backend_retention_days" {
  description = "Retention period for backend logs"
  default     = 30
}

variable "project_name" {
  description = "Project name to use in resource names"
  default     = "django-aws"
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  default     = "ecs"
}

#Database
variable "rds_db_name" {
  description = "RDS database name"
}
variable "rds_username" {
  description = "RDS database username"
}
variable "rds_password" {
  description = "postgres password for database instance"
}
variable "rds_hostname" {
  description = "RDS instamce hostname"
}

#Load balancer
variable "alb_target_arn" {
  description = "ALB Target group ARN"
}

#Network
variable "subnets" {
  description = "ECS subnets"
}

#Security group
variable "vpc_id" {
  description = "VPC ID"
}

variable "security_groups" {
  description = "VPC security groups"
}