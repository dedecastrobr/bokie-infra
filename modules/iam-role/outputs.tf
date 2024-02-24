output "arn" {
    value = aws_iam_role.iam_role.arn
    description = "ARN for the role"
}

output "name" {
  value = aws_iam_role.iam_role.name
  description = "Role name"
}