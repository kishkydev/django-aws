# ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

# Backend web task definition and service
resource "aws_ecs_task_definition" "backend_web" {
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  family = "backend-web"
  container_definitions = templatefile(
    "templates/backends.tftpl",
    {
      region     = var.region
      name       = "backend-web"
      image      = aws_ecr_repository.backend.repository_url
      command    = ["gunicorn", "-w", "3", "-b", ":8000", "django_aws.wsgi:application"]
      log_group  = aws_cloudwatch_log_group.backend.name
      log_stream = aws_cloudwatch_log_stream.backend_web.name

      rds_db_name  = var.rds_db_name
      rds_username = var.rds_username
      rds_password = var.rds_password
      rds_hostname = var.rds_hostname
    },
  )
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  task_role_arn      = aws_iam_role.backend_task.arn
}

resource "aws_ecs_service" "ecs_service" {
  name                               = "backend-web"
  cluster                            = aws_ecs_cluster.ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.backend_web.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  enable_execute_command             = true

  load_balancer {
    target_group_arn = var.alb_target_arn
    container_name   = "backend-web"
    container_port   = 8000
  }

  network_configuration {
    security_groups  = [aws_security_group.ecs_backend.id]
    subnets          = var.subnets
    assign_public_ip = false
  }
}

# Security Group
resource "aws_security_group" "ecs_backend" {
  name        = "ecs-backend"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = var.security_groups
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM roles and policies
resource "aws_iam_role" "backend_task" {
  name = "backend-task"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })

  inline_policy {
    name = "backend-task-ssmmessages"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = [
            "ssmmessages:CreateControlChannel",
            "ssmmessages:CreateDataChannel",
            "ssmmessages:OpenControlChannel",
            "ssmmessages:OpenDataChannel",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "ecs-task-execution"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Action = "sts:AssumeRole",
          Principal = {
            Service = "ecs-tasks.amazonaws.com"
          },
          Effect = "Allow",
          Sid    = ""
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Cloudwatch Logs
resource "aws_cloudwatch_log_group" "backend" {
  name              = "ecs-backend"
  retention_in_days = var.backend_retention_days
}

resource "aws_cloudwatch_log_stream" "backend_web" {
  name           = "ecs-backend-web"
  log_group_name = aws_cloudwatch_log_group.backend.name
}