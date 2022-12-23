module "application" {
  source       = "../modules/application"

  rds_db_name  = module.database.var.rds_db_name
  rds_username = module.database.var.rds_username
  //use env variable to pass password
  rds_password = module.database.var.rds_password
  rds_hostname = module.database.aws_db_instance.rds_database.address
  
  alb_target_arn = module.networking.aws_alb_target_group.alb_target_group.arn

  subnet = [module.networking.aws_subnet.private_subnet_1.id, module.networking.aws_subnet.private_subnet_2.id, module.networking.aws_subnet.private_subnet_3.id]

  vpc_id = module.networking.aws_vpc.vpc.id
  security_groups = [module.networking.aws_security_group.alb.id]
}

module "networking" {
  source = "../modules/networking"

  ecs_cluster_name = module.application.aws_ecs_cluster.ecs_cluster.name
  ecs_service_name = module.application.aws_ecs_service.ecs_service.name
  
}

module "database" {
  source = "../modules/database"

  subnet_ids = [module.networking.aws_subnet.public_subnet_1.id, module.networking.aws_subnet.public_subnet_2.id, module.networking.aws_subnet.public_subnet_3.id]
  vpc_id = module.networking.aws_vpc.vpc.id
  security_groups = [module.networking.aws_security_group.ecs_security_group.id]
  
}