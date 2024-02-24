variable "name" {
  description = "ECS cluster name"
}

variable "subnets" {
  description = "List of subnets for the ECS cluster service"
}

variable "security_groups" {
  description = "List of SGs for the ESC cluster service"
}

variable "target_group_arn" {
  description = "ARN for the TG"
  
}

variable "ecs_task_execution_role" {
  description = "Task execution role"
}

variable "ecs_task_role" {
  description = "Task role"
}

variable "kc_db_name" {
  description = "KC database name"
}

variable "kc_db_password" {
  description = "KC database password"
}

variable "keycloak_db_user" {
  description = "KC dtabase user"
}

variable "kc_db_url" {
  description = "KC database host"
}