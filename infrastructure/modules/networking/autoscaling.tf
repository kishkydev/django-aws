# Create an ECS Auto Scaling group
resource "aws_appautoscaling_target" "ecs_auto_scaling_group" {
  max_capacity = 10
  min_capacity = 1
  resource_id = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

# Create a scaling policy for the ECS Auto Scaling group
resource "aws_appautoscaling_policy" "ecs_scaling_policy" {
  name = "my-ecs-scaling-policy"
  resource_id = aws_appautoscaling_target.ecs_auto_scaling_group.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_auto_scaling_group.scalable_dimension
  service_namespace = aws_appautoscaling_target.ecs_auto_scaling_group.service_namespace
  policy_type = "TargetTrackingScaling"
  target_tracking_scaling_policy_configuration {
    target_value = 50
    scale_in_cooldown = 60
    scale_out_cooldown = 60
    disable_scale_in = false
  }
depends_on = [aws_appautoscaling_target.ecs_auto_scaling_group]
}