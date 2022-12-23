#Outputs
output "rds_db_name" {
  value = aws_db_instance.rds_database.db_name
}

output "rds_username" {
  value = aws_db_instance.rds_database.username
}

output "rds_password" {
  value = aws_db_instance.rds_database.password
}

output "rds_hostname" {
    value = aws_db_instance.rds_database.address
}