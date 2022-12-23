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