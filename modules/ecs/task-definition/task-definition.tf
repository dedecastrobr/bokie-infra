data "aws_region" "current" {}

locals {
  environment = [
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
      name  = "KC_DB"
      value = "postgres"
    },
    {
      name  = "KC_DB_PASSWORD"
      value = tostring(var.kc_db_password)
    },
    {
      name  = "KC_DB_URL_DATABASE"
      value = tostring(var.kc_db_name)
    },
    {
      name  = "KC_DB_URL_HOST"
      value = tostring(var.kc_db_url)
    }
  ]
  entrypoint = ["/opt/keycloak/bin/kc.sh"]
  command = ["start-dev"]
}

resource "aws_ecs_task_definition" "task_definition" {
  family = var.family
  execution_role_arn       = var.ecs_task_execution_role
  task_role_arn            = var.ecs_task_role
  network_mode             = var.network_mode
  cpu                      = var.cpu
  memory                   = var.memory

  requires_compatibilities = var.requires_compatibilities

  container_definitions = jsonencode([
    {
      name      = var.image_name
      image     = var.image_url
      cpu       = var.cpu
      memory    = var.memory
      essential = var.essential
      entrypoint = local.entrypoint
      command = local.command
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.log_group
          "awslogs-region"        = var.log_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      environment = local.environment
    }
  ])
}

resource "aws_cloudwatch_log_group" "log-group" {
  name = "bokie-logs"
}