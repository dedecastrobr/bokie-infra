variable "vpc_id" {
    description = "SG VPC id" 
}

variable "subnets" {
    description = "Subnets array" 
}

variable "tg_name" {
    description = "ALB Target group name" 
}  

variable "name" {
    description = "ALB name" 
}

variable "referenced_security_group_id" {
    description = "SG source for the ALB rules" 
}

variable "security_groups" {
  description = "SG list for ALB"
}