locals {
  cluster_name  = "ivs-ecs-ec2"
  node_app_port = 3000
}

provider "aws" {
  region = var.region
}

module "website" {
  source              = "./static-site"
  domain_name         = var.domain_name
  environment         = var.environment
  website_bucket_name = var.website_bucket_name
}

# Network
module "vpc" {
  source  = "registry.terraform.io/terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "main-vpc"
  cidr = "10.99.0.0/18"

  azs = ["${var.region}a", "${var.region}b", "${var.region}c"]
  // Public ECS cluster through public
  public_subnets = ["10.99.0.0/24", "10.99.1.0/24", "10.99.2.0/24"]
  // private_subnets  = ["10.99.3.0/24", "10.99.4.0/24", "10.99.5.0/24"]
  database_subnets = ["10.99.7.0/24", "10.99.8.0/24", "10.99.9.0/24"]

  create_database_subnet_group       = true
  create_database_subnet_route_table = true
  // ## Start configuration: Public db access ##
  // Database need dns for public access
  // create_database_internet_gateway_route = true

  enable_dns_hostnames = true
  enable_dns_support   = true
  // End configuration: Public db access

  tags = {
    Environment : var.environment
  }
}

module "security_group" {
  source  = "registry.terraform.io/terraform-aws-modules/security-group/aws"
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
      // More security if Define a db_access_security_groups
      // security_groups = [module.db_access_security_groups.id]
    },
  ]

  tags = {
    Environment : var.environment
  }
}

module "db" {
  source                 = "./database"
  region                 = var.region
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  subnet_ids             = module.vpc.database_subnets
  vpc_security_group_ids = [module.security_group.security_group_id]
}

module "demo-ecr" {
  source = "./ecr"
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "example-ecs-cluster-group"
  retention_in_days = 1
  tags = {
    Environment = var.environment
  }
}

module "demo-ecs" {
  source = "./ecs"
  ecs_service_network_configuration = {
    subnets          = module.vpc.public_subnets
    assign_public_ip = true
  }
  aws_cloudwatch_log_group = aws_cloudwatch_log_group.ecs_log_group.name
  region                   = var.region
  node_app_image_url       = module.demo-ecr.demo-ecr-repository.repository_url //"${module.demo-ecr.demo-ecr-repository.repository_url}:latest"
  node_app_env = [
    {
      name  = "DB_TYPE"
      value = module.db.db.db_instance_engine
    },
    {
      name  = "DB_HOST"
      value = module.db.db.db_instance_address
    },
    {
      name  = "DB_NAME"
      value = module.db.db.db_instance_name
    },
    {
      name  = "DB_USERNAME"
      value = module.db.db.db_instance_username
    },
    {
      name  = "DB_PASSWORD"
      value = module.db.db.db_instance_password
    },
    {
      name  = "DB_PORT"
      value = tostring(module.db.db.db_instance_port)
    },
    {
      name  = "PORT"
      value = tostring(local.node_app_port)
    },
    {
      name  = "TEST_TOKEN"
      value = var.test_token
    }
  ]
}
