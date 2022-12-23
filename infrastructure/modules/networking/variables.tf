variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-west"
}

variable "availability_zones" {
  description = "Availability zones"
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
}

variable "ecs_service_name" {
  description = "ECS service name"
}

#Route53
# Namecheap
variable "namecheap_api_username" {
  description = "Namecheap APIUsername"
}
variable "namecheap_api_key" {
  description = "Namecheap APIKey"
}

# Domains
variable "base_domain" {
  description = "Base domain for django project"
}
variable "backend_domain" {
  description = "Backend web domain for django project"
}