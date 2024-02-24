data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_ecs_cluster" "ecs" {
  name = var.name

    setting {
        name  = "containerInsights"
        value = "enabled"
    }

}

resource "aws_ecs_cluster_capacity_providers" "capacity_provider" {
  cluster_name = aws_ecs_cluster.ecs.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}

module "kc_task_definition" {

    source = "./task-definition"
    ecs_task_execution_role = var.ecs_task_execution_role
    ecs_task_role = var.ecs_task_role  
    image_name = "keycloak"
    image_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/keycloak:latest"
    log_region = "${data.aws_region.current.name}"
    kc_db_name = var.kc_db_name
    kc_db_password = var.kc_db_password
    keycloak_db_user = var.keycloak_db_user
    kc_db_url = var.kc_db_url

}

module "kc_service" {

    source = "./service"
    cluster = aws_ecs_cluster.ecs.id
    task_definition = module.kc_task_definition.arn
    name = "keycloak-svc"
    subnets = var.subnets
    security_groups = var.security_groups
    target_group_arn = var.target_group_arn

}