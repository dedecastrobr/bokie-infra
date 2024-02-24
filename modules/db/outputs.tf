output "db_address" {
    value = aws_db_instance.db.address
}

output "db_port" {
  value = aws_db_instance.db.port
}

output "db_user" {
  value = aws_db_instance.db.username
}

output "db_db" {
  value = aws_db_instance.db.db_name
}