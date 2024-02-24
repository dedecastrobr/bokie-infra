resource "aws_ecs_service" "service" {
  name            = var.name
  cluster         = var.cluster
  task_definition = var.task_definition 
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  health_check_grace_period_seconds = 120


  network_configuration {
    subnets         = var.subnets
    security_groups = [var.security_groups]
    assign_public_ip = var.assign_public_ip
  }

 load_balancer {
   target_group_arn = var.target_group_arn
   container_name   = "keycloak"
   container_port   = 8080
 }
}
