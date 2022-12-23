variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "Availability zones"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
}

variable "ecs_service_name" {
  description = "ECS service name"
}