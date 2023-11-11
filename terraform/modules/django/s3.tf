module "s3_bucket_app" {
  source                 = "cloudposse/s3-bucket/aws"
  version                = "4.0.0"
  #source                 = "git::https://github.com/cloudposse/terraform-aws-s3-bucket.git?ref=tags/4.0.0"
  force_destroy          = true
  user_enabled           = true
  versioning_enabled     = true
  allowed_bucket_actions = ["s3:DeleteObject", "s3:GetObject", "s3:ListBucket", "s3:PutObject"]
  name                   = "app"
  stage                  = var.stage
  namespace              = var.lambda_function_name
}

data "aws_s3_objects" "dist" {
  bucket = module.s3_bucket_app.bucket_id
  prefix = "dist"
}

data "aws_s3_object" "manifest" {
  count = var.create_lambda_function ? 1 : 0
  bucket = module.s3_bucket_app.bucket_id
  key = "manifest.json"
}

locals {
  # jsondecode orders manifest
  dist_manifest = var.create_lambda_function ? jsondecode(data.aws_s3_object.manifest[0].body) : {}
}

