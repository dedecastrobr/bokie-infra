
variable "name" {
  description = "Service name"
}

variable "cluster" {
  description = "Cluster for running the service"
}

variable "task_definition" {
  description = "Task definition to be instantiated"
}

variable "desired_count" {
  description = "Number of desired instances"
  default = 1
}

variable "subnets" {
  description = "List of subnets for the service"
}


variable "security_groups" {
  description = "List of SGs for the service"
}

variable "assign_public_ip" {
  description = "Define if it assigns public ip for the ECS service"
  default = false
}

variable "target_group_arn" {
  description = "ARN for the TG"
}