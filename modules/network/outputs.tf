output "alb_dns_name" {
  value = aws_lb.example.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.example.arn
  description = "The ARN of the target group"
}


