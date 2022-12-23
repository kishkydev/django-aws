output "alb_target_arn" {
    value = aws_alb_target_group.alb_target_group.arn
}

output "private_subnets" {
    value = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]
}

output "public_subnets" {
    value = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]
}

output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "alb_security_groups" {
    value = [aws_security_group.alb.id]
}

output "ecs_security_groups" {
    value = [aws_security_group.ecs_security_group.id]
}

#Output ALB URL

output "alb_domain" {
  value = aws_alb.alb.dns_name
}