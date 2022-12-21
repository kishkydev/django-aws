# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create an ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "my-ecs-cluster"
}

# Create an ECS task definition
resource "aws_ecs_task_definition" "ecs_task" {
  family = "my-ecs-task"
  container_definitions = <<DEFINITION
[
  {
    "name": "container-1",
    "image": "nginx:latest",
    "portMappings": [
      {
        "containerPort": 80
      }
    ]
  },
  {
    "name": "container-2",
    "image": "redis:latest",
    "portMappings": [
      {
        "containerPort": 6379
      }
    ]
  },
  {
    "name": "container-3",
    "image": "mysql:latest",
    "portMappings": [
      {
        "containerPort": 3306
      }
    ]
  }
]
DEFINITION
}

# Create an ECS service
resource "aws_ecs_service" "ecs_service" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 3
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["sg-123456"]
    subnets         = ["subnet-123456", "subnet-789012"]
  }
}


# Create an ECS launch configuration
resource "aws_ecs_launch_configuration" "ecs_launch_config" {
  name                 = "my-ecs-launch-config"
  image_id             = "ami-123456"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_role.ecs_instance_role.arn
  security_groups      = ["sg-123456"]
}