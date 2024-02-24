module "iam_policy" {
    source = "../iam-policy"
    name = "ECSPolicyForTasks"
    description = "Policy for tasks on ECS"
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Effect   = "Allow",
            Action   = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetRepositoryPolicy",
            "ecr:DescribeRepositories",
            "ecr:ListImages",
            "ecr:DescribeImages",
            "ecr:BatchGetImage",
            "elasticloadbalancing:DeregisterTargets",
            "elasticloadbalancing:RegisterTargets",
            "elasticloadbalancing:DescribeTargetGroups"
            ],
            Resource = "*"
        }
        ]
    }) 
}

module "iam_role" {
    source = "../iam-role"

    name = "TaskExecution"
    policy_arn = module.iam_policy.arn
    assume_role_policy = jsonencode({
        Version   = "2012-10-17",
        Statement = [
        {
            Effect    = "Allow",
            Principal = {
            Service = "ecs-tasks.amazonaws.com"
            },
            Action    = "sts:AssumeRole"
        }
        ]
    })
    
}

resource "aws_iam_role_policy_attachment" "CloudWatchLogsFullAccess" {

  role       = module.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"

}