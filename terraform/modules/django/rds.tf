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

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster
resource "aws_rds_cluster" "cluster" {
    engine                  = "aurora-mysql"
    engine_mode             = "provisioned"
    engine_version          = "5.7"
    cluster_identifier      = var.lambda_function_name
    master_username         = "root"
    master_password         = var.db_password

    db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name

    backup_retention_period = 7
    skip_final_snapshot     = true
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance
resource "aws_rds_cluster_instance" "cluster_instances" {
    identifier         = "${var.lambda_function_name}-${count.index}"
    count              = 1
    cluster_identifier = aws_rds_cluster.cluster.id
    instance_class     = "db.t3.small"
    engine             = aws_rds_cluster.cluster.engine
    engine_version     = aws_rds_cluster.cluster.engine_version

    publicly_accessible = false
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
resource "aws_db_subnet_group" "db_subnet_group" {
    name = "${var.lambda_function_name}-db-subnet-group"

    subnet_ids = module.vpc.private_subnets

    tags = {
        Name = var.lambda_function_name
    }
}