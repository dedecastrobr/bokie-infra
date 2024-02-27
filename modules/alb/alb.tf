resource "aws_lb" "auth_lb" {

    internal = false
    load_balancer_type = "application"
    security_groups = var.security_groups
    subnets = var.subnets

    xff_header_processing_mode = "preserve"

}

# LISTENERS
resource "aws_lb_listener" "auth_listener" {
  load_balancer_arn = aws_lb.auth_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.auth_tg.arn
    type             = "forward"
  }
  
}

# TARGET GROUPS
resource "aws_lb_target_group" "auth_tg" {

    name        = var.tg_name
    vpc_id      = var.vpc_id
    port        = 8080
    protocol    = "HTTP"
    target_type = "ip"

    health_check {
        enabled = true
        interval = 30
        path = "/auth/health"
        protocol = "HTTP"
        port = "traffic-port"
    }
}
