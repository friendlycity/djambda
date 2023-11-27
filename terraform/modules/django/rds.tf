#########################
# Database security group
#########################
module "mysql_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/mysql"
  version = "5.1.0"

  name = "database_sg"
  vpc_id = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

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

resource "aws_rds_cluster" "cluster" {
  engine                  = local.engine
  engine_mode             = "provisioned"
  engine_version          = local.engine_version
  cluster_identifier      = "aurora-mysqlcluster"
  master_username         = "root"
  master_password         = var.db_password
  port                    = local.port
  db_subnet_group_name    = module.vpc.database_subnet_group_name
  
  #vpc_security_group_ids  = [module.mysql_security_group.security_group_id]
  
  backup_retention_period = 7
  skip_final_snapshot     = true
}

resource "aws_rds_cluster_instance" "cluster_instance" {
  identifier         = "aurora-mysqlcluster-instance"
  cluster_identifier = aws_rds_cluster.cluster.id
  instance_class     = local.instance_class
  engine             = aws_rds_cluster.cluster.engine
  engine_version     = aws_rds_cluster.cluster.engine_version
  
  publicly_accessible = true
  db_subnet_group_name    = module.vpc.database_subnet_group_name

}

resource "aws_rds_cluster_endpoint" "static" {
  cluster_identifier          = aws_rds_cluster.cluster.id
  cluster_endpoint_identifier = "static"
  custom_endpoint_type        = "ANY"

  static_members = [aws_rds_cluster_instance.cluster_instance.id]
}

#resource "aws_db_subnet_group" "db_subnet_group" {
#  name = "${var.project_name}-db-subnet-group"
#  subnet_ids = module.vpc.private_subnets
#}