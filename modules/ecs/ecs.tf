resource "aws_ecs_cluster" "ecs" {
  name = var.name

    setting {
        name  = "containerInsights"
        value = "enabled"
    }

}

resource "aws_ecs_cluster_capacity_providers" "capacity_provider" {
  cluster_name = aws_ecs_cluster.ecs.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}


output "id" {
  value = aws_ecs_cluster.ecs.id
}