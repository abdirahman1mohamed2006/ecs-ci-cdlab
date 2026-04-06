

module "VPC" {
  source = "./modules/VPC"
}

module "ACM" {
  source = "./modules/ACM"

  zone_name   = var.zone_name
  domain_name = var.domain_name

}

module "ALB" {
  source          = "./modules/ALB"
  vpc_id          = module.VPC.vpc_id
  lb_name         = var.lb_name
  certificate_arn = module.ACM.certificate_arn
  public_subnet_1_id  = module.VPC.public_subnet_1_id
  public_subnet_2_id = module.VPC.public_subnet_2_id

}

module "ECS" {
  source = "./modules/ECS"

  vpc_id              = module.VPC.vpc_id
  alb_sg_id           = module.ALB.alb_sg_id
  private_subnet_1_id = module.VPC.private_subnet_1_id
  private_subnet_2_id = module.VPC.private_subnet_2_id

  cluster          = "memo_cluster"
  app_name         = var.app_name
  app_name_service = var.app_name_service
  family           = var.family

  cpu    = "256"
  memory = "512"

  frontend_image = var.frontend_image
  backend_image  = var.backend_image

  frontend_port = var.frontend_port
  backend_port  = var.backend_port

  target_group_arn = module.ALB.target_group_arn

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  frontend_log_group = var.frontend_log_group
  backend_log_group  = var.backend_log_group
  aws_region         = var.aws_region
}





module "ECR" {
  source    = "./modules/ECR"
  repo_name = var.repo_name


}