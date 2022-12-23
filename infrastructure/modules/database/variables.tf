variable "region" {
  description = "The AWS region to create resources in."
  default     = "us-east-1"
}

# rds
variable "rds_db_name" {
  description = "RDS database name"
  default     = "django_aws"
}
variable "rds_username" {
  description = "RDS database username"
  default     = "django_aws"
}
variable "rds_password" {
  description = "postgres password for database instance"
  default     = "myDBpassworD"
}
variable "rds_instance_class" {
  description = "RDS instance type"
  default     = "db.t2.micro"
}

#Netorking
variable "vpc_id" {
  description = "VPC ID"
}

variable "security_groups" {
  description = "ECS security groups"
}

variable "subnet_ids" {
  description = "VPC subnet IDs"
}

#database
variable "storage_type" {
  description = "RDS storage type"
  default = "gp2"
}

variable "allocated_storage" {
  description = "RDS allocated storage"
  default = 20
}

variable "engine_version" {
  description = "Postgres engine version"
  default     = "12.5"
}