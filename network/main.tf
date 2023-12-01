# create vpc
resource "aws_vpc" "rds_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.dns_support
  enable_dns_hostnames = var.dns_hostnames

  tags = {
    Name = "rds vpc"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "rds_igw" {
  vpc_id = aws_vpc.rds_vpc.id

  tags = {
    Name = "vpc_igw"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

output "availability_zones" {
  value = data.aws_availability_zones.available_zones.names
}


# Create 1st public subnet
resource "aws_subnet" "rds_pub_sub_one" {
  vpc_id                  = aws_vpc.rds_vpc.id
  cidr_block              = var.pub_subnet_cidr_blocks[0]
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "Pub Subnet One"
  }
}

# Create 2nd public subnet
resource "aws_subnet" "rds_pub_sub_two" {
  vpc_id                  = aws_vpc.rds_vpc.id
  cidr_block              = var.pub_subnet_cidr_blocks[1]
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "Pub Subnet two"
  }
}

# Create 1st private subnet
resource "aws_subnet" "rds_priv_sub_one" {
  vpc_id            = aws_vpc.rds_vpc.id
  cidr_block        = var.priv_subnet_cidr_blocks[0]
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags = {
    Name = "Private Subnet one"
  }
}

# Create 2nd private subnet
resource "aws_subnet" "rds_priv_sub_two" {
  vpc_id            = aws_vpc.rds_vpc.id
  cidr_block        = var.priv_subnet_cidr_blocks[1]
  availability_zone = data.aws_availability_zones.available_zones.names[1]

  tags = {
    Name = "Private Subnet two"
  }
}


output "priv_subnet_ids" {
  value = [
    aws_subnet.rds_priv_sub_one.id,
    aws_subnet.rds_priv_sub_two.id,
  ]
}



# Create an EIP for the NAT gateway
resource "aws_eip" "nat_eip" {
   domain = "vpc"
}


# Create NAT gateway
resource "aws_nat_gateway" "rds_nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.rds_pub_sub_one.id

  tags = {
    Name = "Nat GW"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.rds_igw]
}


# Create a route table for the private subnet
resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.rds_vpc.id

  tags = {
    Name = "My VPC Private Subnet Route Table"
  }
}


# Create a route table for the public subnet
resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.rds_vpc.id

  tags = {
    Name = "Public Subnet Route Table"
  }
}

# Create a route to the NAT gateway for the private subnet
resource "aws_route" "private_subnet_nat_gateway_route" {
  route_table_id         = aws_route_table.private_subnet_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.rds_nat_gw.id
}


# Create a route to the internet gateway for the public subnet
resource "aws_route" "public_subnet_internet_gateway_route" {
  route_table_id         = aws_route_table.public_subnet_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.rds_igw.id
}


# Associate the 1st public subnet with the public subnet route table
resource "aws_route_table_association" "public_subnet_route_table_association" {
  subnet_id      = aws_subnet.rds_pub_sub_one.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}


# Associate the 2nd public subnet with the public subnet route table
resource "aws_route_table_association" "public_subnet_route_table_association_2" {
  subnet_id      = aws_subnet.rds_pub_sub_two.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

# Associate the 1st private subnet with the private subnet route table
resource "aws_route_table_association" "private_subnet_route_table_association" {
  subnet_id      = aws_subnet.rds_priv_sub_one.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}


# Associate the 2nd private subnet with the private subnet route table
resource "aws_route_table_association" "private_subnet_route_table_association_2" {
  subnet_id      = aws_subnet.rds_priv_sub_two.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}


###################



