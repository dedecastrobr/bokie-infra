resource "aws_vpc_security_group_egress_rule" "rule" {

  security_group_id = var.security_group_id
  cidr_ipv4   = var.cidr_block
  from_port   = var.from_port
  ip_protocol = var.ip_protocol
  to_port     = var.to_port
  referenced_security_group_id = var.referenced_security_group_id

}