output "public_route_table_id" {
  value = aws_route_table.public-route-table.id
}

output "private_route_table_id" {
  value = aws_route_table.private-route-table.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.internet-gateway.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}