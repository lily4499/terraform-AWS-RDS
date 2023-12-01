output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.rds_vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the created public subnets"
  value       = [aws_subnet.rds_pub_sub_one.id, aws_subnet.rds_pub_sub_two.id]
}

output "private_subnet_ids" {
  description = "IDs of the created private subnets"
  value       = [aws_subnet.rds_priv_sub_one.id, aws_subnet.rds_priv_sub_two.id]
}





