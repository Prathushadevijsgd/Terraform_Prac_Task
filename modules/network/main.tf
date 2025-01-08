resource "aws_lb" "example" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnet_ids
  enable_deletion_protection = false

  tags = {
    Name = "example-alb"
  }
}

resource "aws_lb_target_group" "example" {
  name     = "example-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval = 30
    path     = "/"
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "example-target-group"
  }
}

# ALB Listener for HTTP traffic on Port 80
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  # Default action: forward to the target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

