data "aws_region" "current" {}

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
      entrypoint = var.entrypoint
      command = var.command
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
      environment = var.environment
    }
  ])
}

resource "aws_cloudwatch_log_group" "log-group" {
  name = var.log_group
}