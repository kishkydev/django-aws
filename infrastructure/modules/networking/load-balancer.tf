# Create an ALB
resource "aws_alb" "alb" {
  name            = "my-alb"
  internal        = false
  security_groups = [aws_security_group.alb.id]
  subnets         = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]

  tags = {
    Name = "my-alb"
  }
}

# Create a target group for the ALB
resource "aws_alb_target_group" "alb_target_group" {
  name     = "my-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 29
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }
}

# Target listener for http:80
resource "aws_lb_listener" "prod_http" {
  load_balancer_arn = aws_alb.alb.id
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_alb_target_group.alb_target_group]

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Target listener for https:443
resource "aws_alb_listener" "prod_https" {
  load_balancer_arn = aws_alb.alb.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  depends_on        = [aws_alb_target_group.alb_target_group]

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }

  certificate_arn = aws_acm_certificate_validation.backend.certificate_arn
}


# Allow traffic from 80 and 443 ports only
resource "aws_security_group" "alb" {
  name        = "alb"
  description = "Controls access to the ALB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}