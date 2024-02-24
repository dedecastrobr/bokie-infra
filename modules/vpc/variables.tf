
variable "vpc_name" {
  description = "Name of the VPC"
}

variable "vpc_cidr" {
  description = "CIDR block"
}

variable "subnets" {
  description = "Private Subnets array for VPC endpoints"
}

variable "vpc_endpoint_sg" {
  description = "SG for the VPC endpoints"
}
