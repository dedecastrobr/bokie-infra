variable "route_table_id" {
    description = "ID of the route table"
}

variable "destination_cidr_block" {
  description = "CIDR block for the destination"
}

variable "gateway_id" {
    description = "ID of the gateway"
    nullable = true
}