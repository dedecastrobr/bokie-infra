
variable "family" {
    description = "Task definition family name"
    default = "bokie-td"
}

variable "image_name" {
    description = "ECR image name on ECS"
}

variable "image_url" {
    description = "ECR image URL"
}

variable "cpu" {
  description = "Container CPU"
  default = 1024
}

variable "memory" {
  description = "Container memory"
  default = 3072
}

variable "network_mode" {
  description = "Container network mode"
  default = "awsvpc"
}

variable "requires_compatibilities" {
  description = "Container launch type"
  default = ["FARGATE"]
}

variable "essential" {
  description = "Container essential"
  default = true
}

variable "ecs_task_execution_role" {
    description = "Task execution permissions role"
}

variable "ecs_task_role" {
  description = "Task permissions role"
}

variable "container_port" {
  description = "Image container port"
  default = 8080
}

variable "host_port" {
    description = "Image host port"
    default = 8080
}

variable "log_region" {
  description = "Container log region"
}

variable "log_group" {
  description = "Container log group"
  default = "bokie-logs"
}

variable "keycloak_db_user" {
  description = "KC databse user"
}

variable "kc_db_password" {
  description = "KC database password"
}

variable "kc_db_name" {
  description = "KC database name"
}

variable "kc_db_url" {
  description = "KC database host"
}