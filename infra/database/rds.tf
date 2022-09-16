locals {
  name = "complete-postgresql"
}

module "db" {
  source     = "terraform-aws-modules/rds/aws"
  version    = "5.1.0"
  identifier = local.name

  engine               = "postgres"
  engine_version       = "14.1"
  family               = "postgres14" # DB parameter group
  major_engine_version = "14"         # DB option group
  instance_class       = "db.t3.micro"

  allocated_storage = 20

  db_name  = "postgresDb"
  username = "tranvandung"
  port     = "5432"

  multi_az               = false
  subnet_ids             = var.subnet_ids
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false
}
