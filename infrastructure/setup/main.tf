module "ECS" {
  source = ". ./modules/application"
  
}

module "VPC" {
  source = ". ./modules/networking"
  
}

module "RDS" {
  source = ". ./modules/database"
  
}
