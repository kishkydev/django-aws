variable "region" {
  description = "The AWS region to create resources in"
  default     = "us-west-2"
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

#Route53
# Namecheap
variable "api_username" {
  description = "Namecheap APIUsername"
  default = "Obatula"
}
variable "api_key" {
  description = "Namecheap APIKey"
  default     = "1234place567holder"
}

# Domains
variable "domain" {
  description = "Base domain for django project"
  default = "example53.xyz"
}
variable "backend" {
  description = "Backend web domain for django project"
  default = "api.example53.xyz"
}