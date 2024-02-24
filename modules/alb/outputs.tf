output "auth_tg_arn" {
  value = aws_lb_target_group.auth_tg.arn
}

output "alb_url" {
  value = aws_lb.auth_lb.dns_name
}