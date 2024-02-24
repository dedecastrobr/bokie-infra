variable "cidr_block" {
  description = "CIDR rule block"
  default = null
}

variable "from_port" {
  description = "From rule port"
  default = null
}

variable "ip_protocol" {
  description = "Rule IP protocol"
}

variable "to_port" {
  description = "To rule port"
  default = null
}

variable "security_group_id" {
  description = "SG Id"
}

variable "referenced_security_group_id" {
  description = "Source SG"
  default = null
}
