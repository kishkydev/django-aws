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

# Create a listener for the ALB
resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    type             = "forward"
  }
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


#Output ALB URL

output "alb_domain" {
  value = aws_alb.alb.dns_name
}