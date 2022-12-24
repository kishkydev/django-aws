# Configure the AWS provider
provider "aws" {
  region = var.region
}

# Create an RDS security group that allows traffic from the ECS cluster
resource "aws_security_group" "rds_security_group" {
  name        = "rds_security_group"
  description = "Security group for RDS database"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 54322
    to_port     = 5432
    protocol    = "tcp"
    security_groups = var.security_groups
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an RDS PostgreSQL database
resource "aws_db_instance" "rds_database" {
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  engine               = "postgres"
  engine_version       = var.engine_version
  instance_class       = var.rds_instance_class
  db_name                 = var.rds_db_name
  username             = var.rds_username
  password             = var.rds_password
  vpc_security_group_ids   = [aws_security_group.rds_security_group.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  publicly_accessible  = false
}

# Create an RDS subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = var.subnet_ids
  description = "Subnet group for RDS database"
}