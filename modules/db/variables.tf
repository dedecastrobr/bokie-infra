variable "private_subnets" {
  description = "Private subnets list"
}

variable "public_subnets" {
  description = "Public subnets list"
}

variable "allocated_storage" {
  description = "DB storage allocation"
  default = 10
}
 
 variable "db_name" {
   description = "Database name"
   default = "bokie"
 }

variable "engine" {
  description = "DB engine"
  default = "postgres"
}

variable "engine_version" {
  description = "DB engine version"
  default = "15"
}

variable "instance_class" {
  description = "DB instance class"
  default = "db.t3.micro"
}

variable "username" {
  description = "DB username"
}

variable "password" {
  description = "DB user password"
}

variable "parameter_group_name" {
  description = "DB parameter group"
  default = "default.postgres15"
}

variable "skip_final_snapshot" {
  description = "DB final snapshot boolean"
  default = true
}

variable "security_groups" {
  description = "DB security groups"
}
