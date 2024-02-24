module "network" {
    source = "./modules/network"
}

module "identity" {
    source = "./modules/identity"
}

module "alb" {

    source = "./modules/alb"
    name = "auth-alb"
    vpc_id = module.network.vpc_id
    referenced_security_group_id = module.network.ecs_sg
    tg_name = "auth-tg"
    subnets = [module.network.private_subnet_01, module.network.private_subnet_02]
    security_groups = [module.network.alb_sg]

}

variable "db_auth_pwd" {}

module "db_auth" {

    source = "./modules/db"
    subnets = [module.network.private_subnet_01, module.network.private_subnet_02]
    password = var.db_auth_pwd
    db_name = "keycloak"
    security_groups = [module.network.db_sg]

}

module "ecr" {
    source = "./modules/ecr"
    name = "keycloak"
}

module "ecs" {

    source = "./modules/ecs"
    depends_on = [ module.network, module.identity, module.alb, module.db_auth ]

    # ECS
    name = "BokieDev"
    subnets = [module.network.private_subnet_01, module.network.private_subnet_02]
    security_groups = module.network.ecs_sg
    target_group_arn = module.alb.auth_tg_arn

    # TASK DEFINITION
    ecs_task_execution_role = module.identity.iam_role.arn
    ecs_task_role = module.identity.iam_role.arn
    kc_db_name = "keycloak"
    kc_db_password = var.db_auth_pwd
    keycloak_db_user = "keycloak"
    kc_db_url = module.db_auth.db_address

}