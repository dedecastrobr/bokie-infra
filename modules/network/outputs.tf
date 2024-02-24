output "vpc_id" {
    value = module.bokie_vpc.vpc_id
}

output "alb_sg" {
  value = module.alb_sg.id
  description = "ALB SG id"
}

output "db_sg" {
  value = module.db_sg.id
  description = "DB SG id"
}

output "vpce_sg" {
  value = module.vpc_endpoint_sg.id
  description = "VPC Endpoint SG id"
}

output "ecs_sg" {
  value = module.ecs_sg.id
  description = "ECS SG id"
}

output "private_subnet_01" {
    value = module.private_subnet_01.id
    description = "Private Subnet 01"
}

output "private_subnet_02" {
    value = module.private_subnet_02.id
    description = "Private Subnet 02"
}