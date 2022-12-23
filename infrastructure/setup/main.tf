module "application" {
  source       = "../modules/application"

  rds_db_name  = module.database.rds_db_name
  rds_username = module.database.rds_username
  //use env variable to pass password
  rds_password = module.database.rds_password
  rds_hostname = module.database.rds_hostname
  
  alb_target_arn = module.networking.alb_target_arn

  subnets = module.networking.private_subnets

  vpc_id = module.networking.vpc_id
  security_groups = module.networking.alb_security_groups
}

module "networking" {
  source = "../modules/networking"

  ecs_cluster_name = module.application.ecs_cluster_name
  ecs_service_name = module.application.ecs_service_name
  
}

module "database" {
  source        = "../modules/database"
  rds_username  = var.username
  rds_password  = var.password

  subnet_ids = module.networking.public_subnets
  vpc_id = module.networking.vpc_id
  security_groups = module.application.ecs_security_groups
  
}