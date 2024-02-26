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

module "kc_ecr" {
    source = "./modules/ecr"
    name = "keycloak"
}

module "bokie_ecr" {
    source = "./modules/ecr"
    name = "bokie"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

module "ecs" {

    source = "./modules/ecs"
    depends_on = [ module.network, module.identity, module.alb, module.kc_db ]
    name = "BokieDev"

}

module "kc_task_definition" {

    source = "./modules/ecs/task-definition"
    ecs_task_execution_role = module.identity.iam_role.arn
    ecs_task_role = module.identity.iam_role.arn
    image_name = "keycloak"
    image_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/keycloak:latest"
    log_region = "${data.aws_region.current.name}"
    kc_db_name = "keycloak"
    kc_db_password = var.kc_db_password
    keycloak_db_user = "keycloak"
    kc_db_url = module.kc_db.db_address

}

module "kc_service" {

    depends_on = [ module.ecs ]

    source = "./modules/ecs/service"
    cluster = module.ecs.id
    task_definition = module.kc_task_definition.arn
    name = "keycloak-svc"
    subnets = [module.network.private_subnet_01, module.network.private_subnet_02]
    security_groups = module.network.ecs_sg
    target_group_arn = module.alb.auth_tg_arn

}