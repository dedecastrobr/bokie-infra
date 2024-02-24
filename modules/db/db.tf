resource "aws_db_subnet_group" "default" {
  subnet_ids = var.subnets
}

resource "aws_db_instance" "db" {
  allocated_storage    = var.allocated_storage
  db_name              = var.db_name
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = var.skip_final_snapshot
  db_subnet_group_name  = aws_db_subnet_group.default.name
  vpc_security_group_ids = var.security_groups

}
