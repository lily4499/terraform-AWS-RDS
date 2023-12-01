


# create the subnet group for the rds instance
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = var.db_subnet_group_name
  subnet_ids  = var.subnet_ids
  description = "subnets for database instance"

  tags = {
    Name = var.db_subnet_group_name
  }
}


# create security group for the web server
resource "aws_security_group" "webserver_security_group" {
  name        = var.webserver_sg_name
  description = "enable http access on port 80"
  vpc_id      = var.vpc_id

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.webserver_sg_name
  }
}



# create security group for the database
resource "aws_security_group" "database_security_group" {
  name        = var.database_sg_name
  description = "enable mysql/aurora access on port 3306"
  vpc_id      = var.vpc_id

  ingress {
    description     = "mysql/aurora access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name =  var.database_sg_name
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

output "availability_zones" {
  value = data.aws_availability_zones.available_zones.names
}


# create the rds instance
resource "aws_db_instance" "db_instance" {
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  multi_az               = var.db_multi_az
  identifier             = var.db_identifier
  username               = var.db_username
  password               = var.db_password
  instance_class         = var.db_class
  allocated_storage      = var.db_allocated_storage
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [aws_security_group.database_security_group.id]
  availability_zone      = data.aws_availability_zones.available_zones.names[0]
  db_name                = var.db_name
  skip_final_snapshot    = var.db_skip_final_snapshot
}