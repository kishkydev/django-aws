# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create an RDS security group that allows traffic from the ECS cluster
resource "aws_security_group" "rds_security_group" {
  name        = "rds_security_group"
  description = "Security group for RDS database"
  vpc_id      = module.networking.aws_vpc.vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = aws_security_group.ecs_security_group.id
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
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "12.5"
  instance_class       = var.rds_instance_class
  name                 = var.rds_db_name
  username             = var.rds_username
  password             = var.rds_password
  # vpc_id               = module.networking.aws_vpc.vpc.id
  vpc_security_group_ids   = [aws_security_group.rds_security_group.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  publicly_accessible  = false
}

# Create an RDS subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [module.networking.aws_subnet.public_subnet_1.id, module.networking.aws_subnet.public_subnet_2.id, module.networking.aws_subnet.public_subnet_3.id]
  description = "Subnet group for RDS database"
}


# #import networking module
# module "networking" {
#   source = "../../modules/networking"
  
# }