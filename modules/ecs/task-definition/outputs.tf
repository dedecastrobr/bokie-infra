output "arn" {
  value = aws_ecs_task_definition.task_definition.arn
  description = "ARN for the task definition"
}