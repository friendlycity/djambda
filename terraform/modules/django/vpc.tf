module "vpc_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  namespace  = var.lambda_function_name
  stage      = var.stage
  name       = "vpc"
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.1.2"

    name = module.vpc_label.id
    cidr = "10.0.0.0/16"
    azs  = ["us-east-1a", "us-east-1b"]

    public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets      = ["10.0.3.0/24", "10.0.4.0/24"]
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        Name = module.vpc_label.id
    }
}

resource "aws_default_security_group" "vpc_security_group" {
    vpc_id = module.vpc.vpc_id

    # allow all inbound traffic 
    ingress {
        protocol  = -1
        from_port = 0
        to_port   = 0
        self      = true
    }

    # allow all outbound traffic
    egress {
        protocol    = -1
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}
