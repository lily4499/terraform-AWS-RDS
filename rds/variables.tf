variable "vpc_id" {
  description = "ID of the VPC"
}

variable "db_subnet_group_name" {
  description = "Name of the database subnet group"
  default     = "database_subnets"
}


variable "webserver_sg_name" {
  description = "Name of the web server security group"
  default     = "webserver security group"
}

variable "database_sg_name" {
  description = "Name of the database security group"
  default     = "database security group"
}





variable "subnet_ids" {
  description = "IDs of the database subnets"
  type        = list(string)
}

variable "db_engine" {
  description = "Database engine for RDS instance"
  default     = "mysql"
}


variable "db_engine_version" {
  description = "Database engine version for RDS instance"
  default     = "8.0.31"
}

variable "db_multi_az" {
  description = "Whether to enable Multi-AZ for the RDS instance"
  type        = bool
  default     = false
}

variable "db_identifier" {
  description = "Identifier for the RDS instance"
  default     = "dev-rds-instance"
}

variable "db_username" {
  description = "Username for the RDS instance"
  default     = "liliane"
}

variable "db_password" {
  description = "Password for the RDS instance"
  default     = "liliane123"
}

variable "db_class" {
  description = "Instance class for the RDS instance"
  default     = "db.t2.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for the RDS instance (in GB)"
  default     = 200
}

variable "db_name" {
  description = "Name of the RDS database"
  default     = "applicationdb"
}

variable "db_skip_final_snapshot" {
  description = "Whether to skip the final snapshot when deleting the RDS instance"
  type        = bool
  default     = true
}


