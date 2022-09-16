locals {
  region = "ap-southeast-1"
}

provider "aws" {
  region = local.region
}

module "website" {
  source              = "./static-site"
  domain_name         = var.domain_name
  environment         = var.environment
  website_bucket_name = var.website_bucket_name
}

# Network
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "main-vpc"
  cidr = "10.99.0.0/18"

  azs              = ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnets   = ["10.99.0.0/24", "10.99.1.0/24", "10.99.2.0/24"]
  private_subnets  = ["10.99.3.0/24", "10.99.4.0/24", "10.99.5.0/24"]
  database_subnets = ["10.99.7.0/24", "10.99.8.0/24", "10.99.9.0/24"]

  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  // Start configuration: Public db access
  create_database_internet_gateway_route = true

  enable_dns_hostnames = true
  enable_dns_support   = true
  // End configuration: Public db access

  tags = {
    Environment : var.environment
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "db-security-group"
  description = "Complete PostgreSQL example security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = {
    Environment : var.environment
  }
}

module "db" {
  source                 = "./database"
  region                 = local.region
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  subnet_ids             = module.vpc.database_subnets
  vpc_security_group_ids = [module.security_group.security_group_id]
}
