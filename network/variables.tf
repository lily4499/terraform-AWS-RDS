# Variable for vpc cidr
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}


# Create a variable for your vpc dns support
variable "dns_support" {
    type = string
   description = "This is a variable for your dns support"
}

# Variable for DNS hostnames
variable "dns_hostnames" {
   type = string
   description = "This is a variable for my vpc hostnames"
}

# Variables for Public Subnets cidrs
variable "pub_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}


# Variables for Private Subnets cidrs
variable "priv_subnet_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}



# Variable for VPC_ID
variable "vpc_id" {
    type = string
}





