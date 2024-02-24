resource "aws_subnet" "subnet" {

    vpc_id = var.vpc_id
    cidr_block =  var.cidr_block
    availability_zone = var.availabilty_zone
    map_public_ip_on_launch = var.map_public_ip_on_launch

    tags = {
      Name = var.subnet-name
    }
  
}

resource "aws_route_table_association" "route-table" {
    subnet_id = aws_subnet.subnet.id
    route_table_id = var.route_table_id
}