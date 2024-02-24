variable "subnet-name" {
    description = "Subnet name"
}

variable "vpc_id" {
    description = "VPC Id for the subnet"
}

variable "cidr_block" {
    description = "CIDR block for the subnet"
}

variable "availabilty_zone" {
    description = "AZ for the subnet"
}

variable "map_public_ip_on_launch" {
    description = "If the subnet should map to a public IP" 
}

variable "route_table_id" {
  description = "Route table ID"
}
