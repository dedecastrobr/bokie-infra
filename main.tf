module "network" {
    source = "./modules/network"
}

module "identity" {
    source = "./modules/identity"
}

module "alb" {

    depends_on = [ module.network ]

    source = "./modules/alb"
    name = "auth-alb"
    vpc_id = module.network.vpc_id
    referenced_security_group_id = module.network.ecs_sg
    tg_name = "auth-tg"
    subnets = [module.network.public_subnet_01, module.network.public_subnet_02]
    security_groups = [module.network.alb_sg]

}

variable "kc_db_username" {}
variable "kc_db_password" {}

module "kc_db" {

    source = "./modules/db"
    private_subnets = [module.network.private_subnet_01, module.network.private_subnet_02]
    public_subnets = [module.network.public_subnet_01, module.network.public_subnet_02]
    username = var.kc_db_username
    password = var.kc_db_password
    db_name = var.kc_db_username
    security_groups = [module.network.db_sg]

}

module "ecr" {
    source = "./modules/ecr"
    name = "keycloak"
}

module "ecs" {

    source = "./modules/ecs"
    depends_on = [ module.network, module.identity, module.alb, module.kc_db ]

    # ECS
    name = "BokieDev"
    subnets = [module.network.private_subnet_01, module.network.private_subnet_02]
    security_groups = module.network.ecs_sg
    target_group_arn = module.alb.auth_tg_arn

    # TASK DEFINITION

    ecs_task_execution_role = module.identity.iam_role.arn
    ecs_task_role = module.identity.iam_role.arn
    kc_db_name = "keycloak"
    kc_db_password = var.kc_db_password
    keycloak_db_user = "keycloak"
    kc_db_url = module.kc_db.db_address

}