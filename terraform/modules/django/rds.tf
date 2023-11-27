locals {
  port              = "3306"
  engine            = "aurora-mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3.small"
  storage_encrypted = false
  allocated_storage = 5
}

resource "random_password" "password" {
  length  = 16
  special = false
}

module "rds-aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "8.5.0"

  name            = module.vpc_label.id
  engine          = local.engine
  engine_version  = local.engine_version
  master_username = "root"
  master_password = var.db_password

  instances = {
    1 = {}
  }

  vpc_id               = module.vpc.vpc_id
  #db_subnet_group_name = module.vpc.database_subnet_group_name
  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = module.vpc.private_subnets_cidr_blocks
    }
  }

  storage_encrypted   = true
  apply_immediately   = true
  skip_final_snapshot = true

  monitoring_interval = 10

  enabled_cloudwatch_logs_exports = ["general"]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}