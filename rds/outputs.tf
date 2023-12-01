
output "db_subnet_group_id" {
  description = "ID of the database subnet group"
  value       = aws_db_subnet_group.database_subnet_group.id
}

output "db_instance_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.db_instance.endpoint
}

output "database_security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.database_security_group.id
}


output "webserver_security_group_id" {
  description = "ID of the web server security group"
  value       = aws_security_group.webserver_security_group.id
}
