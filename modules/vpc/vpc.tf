data "aws_region" "current" {}

resource "aws_vpc" "vpc" {

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "internet-gateway" {

    vpc_id = aws_vpc.vpc.id

    tags = {
      Name = "internet-gateway"
    }
  
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id 
}

module "public-route" {
  
  source = "../route"

  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.internet-gateway.id

}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.vpc.id 
}

resource "aws_vpc_dhcp_options" "dhcp" {
    domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "dhcp" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp.id
}

resource "aws_vpc_endpoint" "s3" {

    vpc_id       = aws_vpc.vpc.id
    service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
    route_table_ids   = [aws_route_table.private_route_table.id]
    vpc_endpoint_type = "Gateway"
}

resource "aws_vpc_endpoint" "logs" {

    vpc_id       = aws_vpc.vpc.id
    service_name = "com.amazonaws.${data.aws_region.current.name}.logs"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [var.vpc_endpoint_sg.id]
    subnet_ids = var.subnets

}

resource "aws_vpc_endpoint" "rds" {

    vpc_id       = aws_vpc.vpc.id
    service_name = "com.amazonaws.${data.aws_region.current.name}.rds"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [var.vpc_endpoint_sg.id]
    subnet_ids = var.subnets

}


resource "aws_vpc_endpoint" "ecr-dkr-endpoint" {
    vpc_id       = aws_vpc.vpc.id
    private_dns_enabled = true
    service_name = "com.amazonaws.${data.aws_region.current.name}.ecr.dkr"
    vpc_endpoint_type = "Interface"
    security_group_ids = [var.vpc_endpoint_sg.id]
    subnet_ids = var.subnets

}

resource "aws_vpc_endpoint" "ecr-api-endpoint" {

    vpc_id       = aws_vpc.vpc.id
    service_name = "com.amazonaws.${data.aws_region.current.name}.ecr.api"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [var.vpc_endpoint_sg.id]
    subnet_ids = var.subnets

}

resource "aws_vpc_endpoint" "ecs-agent" {
  
    vpc_id       = aws_vpc.vpc.id
    service_name = "com.amazonaws.${data.aws_region.current.name}.ecs-agent"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [var.vpc_endpoint_sg.id]
    subnet_ids = var.subnets


}

resource "aws_vpc_endpoint" "ecs-telemetry" {

    vpc_id       = aws_vpc.vpc.id
    service_name = "com.amazonaws.${data.aws_region.current.name}.ecs-telemetry"
    vpc_endpoint_type = "Interface"
    private_dns_enabled = true
    security_group_ids = [var.vpc_endpoint_sg.id]
    subnet_ids = var.subnets

}