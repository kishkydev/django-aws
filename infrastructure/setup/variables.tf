variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name to use in resource names"
  default     = "django-aws"
}


#Placeholder for required variables
variable "username" {
  description = "RDS database username"
  default     = "django_aws"
}

variable "password" {
  description = "Postgres password for database instance"
  default     = "myDBpassworD"
}