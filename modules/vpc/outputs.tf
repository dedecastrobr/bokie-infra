output "public_route_table_id" {
  value = aws_route_table.public_route_table.id
}

output "private_route_table_id" {
  value = aws_route_table.private_route_table.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.internet-gateway.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}