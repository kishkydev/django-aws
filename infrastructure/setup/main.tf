module "application" {
  source = "./modules/application"
  
}

module "networking" {
  source = "./modules/networking"
  
}

module "database" {
  source = ". ./modules/database"
  
}