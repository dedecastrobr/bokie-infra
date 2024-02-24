data "aws_region" "current" {}

## VPC
module "bokie_vpc" {

    source  = "../vpc"
    vpc_name   = "bokie-vpc"
    vpc_cidr   = "13.1.0.0/16"
    subnets = [module.private_subnet_01.id, module.private_subnet_02.id]
    vpc_endpoint_sg = module.vpc_endpoint_sg
  
}

module "private_subnet_01"  {

    source = "../subnet"
    subnet-name = "private-subnet-01"
    availabilty_zone = "${data.aws_region.current.name}a"
    vpc_id = module.bokie_vpc.vpc_id
    cidr_block = "13.1.0.0/24"
    map_public_ip_on_launch = false
    route_table_id = module.bokie_vpc.private_route_table_id

}

module "private_subnet_02" {

    source = "../subnet"
    subnet-name = "private-subnet-02"
    availabilty_zone = "${data.aws_region.current.name}c"
    vpc_id = module.bokie_vpc.vpc_id
    cidr_block = "13.1.16.0/24"
    map_public_ip_on_launch = false
    route_table_id = module.bokie_vpc.private_route_table_id
  
}

## Security Groups

module "alb_sg" {

    source = "../sgroup"
    vpc_id = module.bokie_vpc.vpc_id
    name = "alb-sg"
    description = "ALB Security Group" 

}

module "vpc_endpoint_sg" {
    source = "../sgroup"
    vpc_id = module.bokie_vpc.vpc_id
    name = "vpc-endpoint-sg"
    description = "VPC endpoints Security Group"
}

module "ecs_sg" {

    source = "../sgroup"
    vpc_id = module.bokie_vpc.vpc_id
    name = "ecs-service-sg"
    description = "ECS service Security Group" 

}

module "db_sg" {

    source = "../sgroup"
    vpc_id = module.bokie_vpc.vpc_id
    name = "db-sg"
    description = "DB Security Group" 

}

## Security Group Rules
# DB
module "db_sg_irule_3306" {

    source = "../sgroup-irule"
    security_group_id = module.db_sg.id
    from_port = 5432
    to_port = 5432
    referenced_security_group_id = module.ecs_sg.id
    ip_protocol = "TCP"
    
}

module "db_sgroup_erule_all4all" {

    source = "../sgroup-erule"
    security_group_id = module.db_sg.id
    cidr_block        = "0.0.0.0/0"
    ip_protocol      = "-1"

}

# ALB
module "alb_sgroup_irule_80" {

    source = "../sgroup-irule"
    security_group_id = module.alb_sg.id
    from_port = 80
    to_port = 80
    cidr_block = "0.0.0.0/0"
    ip_protocol = "TCP"
    
}

module "alb_sgroup_erule_8080" {

    source = "../sgroup-erule"
    security_group_id = module.alb_sg.id
    from_port = "8080"
    to_port = "8080"
    referenced_security_group_id = module.ecs_sg.id
    ip_protocol = "TCP"
    
}

# VPC ENDPOINTS
module "vpc_endpoint_bokie" {

    source = "../sgroup-irule"
    security_group_id = module.vpc_endpoint_sg.id
    referenced_security_group_id = module.ecs_sg.id
    ip_protocol      = "-1"

}

module "vpc_endpoint_bokie_443" {

    source = "../sgroup-irule"
    security_group_id = module.vpc_endpoint_sg.id
    from_port = 443
    to_port = 443
    referenced_security_group_id = module.ecs_sg.id
    ip_protocol      = "tcp"

}

module "vpc_endpoint_alb" {

    source = "../sgroup-irule"
    security_group_id = module.vpc_endpoint_sg.id
    referenced_security_group_id = module.alb_sg.id
    ip_protocol      = "-1"

}

# ECS
module "ecs_sg_irule_8080" {

    source = "../sgroup-irule"
    security_group_id = module.ecs_sg.id
    from_port = 8080
    to_port = 8080
    referenced_security_group_id = module.alb_sg.id
    ip_protocol = "TCP"
    
}

module "ecs_egress" {

    source = "../sgroup-erule"
    security_group_id = module.ecs_sg.id
    cidr_block        = "0.0.0.0/0"
    ip_protocol      = "-1"

}