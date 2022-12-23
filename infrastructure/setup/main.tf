module "application" {
  source       = "../modules/application"

  rds_db_name  = module.database.outputs.rds_db_name
  rds_username = module.database.outputs.rds_username
  //use env variable to pass password
  rds_password = module.database.outputs.rds_password
  rds_hostname = module.database.outputs.rds_hostname
  
  alb_target_arn = module.networking.outputs.alb_target_arn

  subnets = module.networking.outputs.private_subnets

  vpc_id = module.networking.outputs.vpc_id
  security_groups = module.networking.outputs.alb_security_groups
}

module "networking" {
  source = "../modules/networking"

  ecs_cluster_name = module.application.outputs.ecs_cluster_name
  ecs_service_name = module.application.outputs.ecs_service_name
  
}

module "database" {
  source = "../modules/database"

  subnet_ids = module.networking.outputs.public_subnets
  vpc_id = module.networking.outputs.vpc_id
  security_groups = module.networking.outputs.ecs_security_groups
  
}