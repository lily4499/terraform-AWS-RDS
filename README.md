# Terraform Project

This project uses Terraform to manage infrastructure on AWS.  It is organized into modules for better maintainability.

## Modules

### IAM Module

The IAM module (`./modules/iam`) includes configurations for managing Identity and Access Management resources.

- **main.tf**: Defines IAM resources.
- **variables.tf**: Declares input variables.
- **outputs.tf**: Specifies output values.

### Network Module

The Network module (`./modules/network`) contains configurations for networking resources.

- **main.tf**: Defines network-related resources.
- **variables.tf**: Declares input variables.
- **outputs.tf**: Specifies output values.

### RDS Module

The RDS module (`./modules/rds`) includes configurations for managing Relational Database Service resources.

- **main.tf**: Defines RDS resources.
- **variables.tf**: Declares input variables.
- **outputs.tf**: Specifies output values.

## Usage

To use this Terraform configuration, you can call this code from GitHub by following these steps:

1.Create a folder in your local machine, then cd to it.
2.Create a file name main.tf, copy the code below and paste it.
3.Set your desired region and Give your desired values to those declared variables
4.Save and close the file
5.Run terraform init, validate, plan , apply


###################################################################################

*******************************     Code start here    ***************************


provider "aws" {  
  region = "us-east-1" // Set your desired region here  
}  
  
// Use the iam module  
module "iam" {  

  source  = "lily4499/rds/aws//iam"  
  version = "1.0.2"  
  iam_role_name           = "RDSRole"  
}  
  
// Use the network module  
module "network" {  

   
  source  = "lily4499/rds/aws//network"  
  version = "1.0.2"  
  vpc_id                  = "aws_vpc.rds_vpc.id"  
  dns_hostnames           = true  
  dns_support             = true  
  vpc_cidr_block          = "10.0.0.0/16"  
  pub_subnet_cidr_blocks  = ["10.0.1.0/24", "10.0.2.0/24"]  
  priv_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]  
}  
  
// Use the RDS module  
module "rds" {  

  source  = "lily4499/rds/aws//rds"  
  version = "1.0.2"  
  subnet_ids              = module.network.priv_subnet_ids  
  vpc_id                  = module.network.vpc_id  
  db_engine               = "mysql"  
  db_engine_version       = "8.0.31"  
  db_multi_az             = false  
  db_identifier           = "dev-rds-instance"  
  db_username             = "liliane"  
  db_password             = "liliane123"  
  db_class                = "db.t2.micro"  
  db_allocated_storage    = 200  
  db_name                 = "applicationdb"  
  db_skip_final_snapshot  = true  
}  

