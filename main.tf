module "network" {
    source = "./modules/network"
}

module "identity" {
    source = "./modules/identity"
}

module "alb" {

    depends_on = [ module.network ]

    source = "./modules/alb"
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

module "keycloak_ecr" {
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

locals {
  kc_environment = [
    {
      name  = "KEYCLOAK_ADMIN"
      value = "admin"
    },
    {
      name  = "KEYCLOAK_ADMIN_PASSWORD"
      value = "admin123"
    },
    {
      name  = "KC_HEALTH_ENABLED"
      value = "true"
    },
    {
      name  = "KC_METRICS_ENABLED"
      value = "true"
    },
    {
      name  = "KC_HTTP_ENABLED"
      value = "true"
    },
    {
      name  = "KC_HTTP_RELATIVE_PATH"
      value = "/auth"
    },
    {
      name  = "QUARKUS_TRANSACTION_MANAGER_ENABLE_RECOVERY"
      value = "true"
    },
    {
      name  = "KC_DB"
      value = "postgres"
    },
    {
      name  = "KC_DB_PASSWORD"
      value = tostring(var.kc_db_password)
    },
    {
      name  = "KC_DB_URL_DATABASE"
      value = "keycloak"
    },
    {
      name  = "KC_DB_URL_HOST"
      value = tostring(module.kc_db.db_address)
    }
    
  ]
  kc_entrypoint = ["/opt/keycloak/bin/kc.sh"]
  kc_command = ["start-dev"]
}

module "kc_task_definition" {

    source = "./modules/ecs/task-definition"
    ecs_task_execution_role = module.identity.iam_role.arn
    ecs_task_role = module.identity.iam_role.arn
    image_name = "keycloak"
    log_group = "kc-logs"
    image_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/keycloak:latest"
    log_region = "${data.aws_region.current.name}"
    entrypoint = local.kc_entrypoint
    command = local.kc_command
    environment = local.kc_environment

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

# variable "bokie_db_password" {}

# locals {
#   bokie_environment = [
#     {
#       name  = "BOKIE_ENV"
#       value = "dev"
#     }
#   ]
#   bokie_entrypoint =["java", "-jar", "bokie.jar"]
# }

# module "bokie_task_definition" {

#     source = "./modules/ecs/task-definition"
#     ecs_task_execution_role = module.identity.iam_role.arn
#     ecs_task_role = module.identity.iam_role.arn
#     image_name = "bokie"
#     log_group = "bokie-logs"
#     image_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/bokie:latest"
#     log_region = "${data.aws_region.current.name}"
#     environment = local.bokie_environment
#     entrypoint = local.bokie_entrypoint

# }

# module "bokie_service" {

#     depends_on = [ module.ecs ]

#     source = "./modules/ecs/service"
#     cluster = module.ecs.id
#     task_definition = module.kc_task_definition.arn
#     name = "bokie-svc"
#     subnets = [module.network.private_subnet_01, module.network.private_subnet_02]
#     security_groups = module.network.ecs_sg
#     target_group_arn = module.alb.auth_tg_arn

# }