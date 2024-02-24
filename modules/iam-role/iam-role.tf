
resource "aws_iam_role" "iam_role" {

  name               = var.name
  assume_role_policy = var.assume_role_policy

}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {

  role       = aws_iam_role.iam_role.name
  policy_arn = var.policy_arn

}
