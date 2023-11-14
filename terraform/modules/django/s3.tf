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

module "react_app_site" {
  source                   = "../s3staticfiles"
  origin_force_destroy     = true
  namespace                = var.react_app_site
  stage                    = var.react_app_site_stage
  name                     = "react_app_site"
  cors_allowed_headers     = ["*"]
  cors_allowed_methods     = ["GET", "HEAD", "PUT"]
  cors_allowed_origins     = ["*"]
  cors_expose_headers      = ["ETag","Content-Range","Content-Length"]
  allow_ssl_requests_only  = false
  block_origin_public_access_enabled = false
}

module "s3_user_reactappsite" {
  source       = "cloudposse/iam-s3-user/aws"
  version      = "1.2.0"
  namespace    = var.react_app_site
  stage        = var.react_app_site_stage
  name         = "s3_user_reactappsite"
  s3_actions   = [
    "s3:PutObject",
    "s3:GetObjectAcl",
    "s3:GetObject",
    "s3:ListBucket",
    "s3:DeleteObject",
    "s3:PutObjectAcl"
  ]
  s3_resources = [
    "arn:aws:s3:::${module.react_app_site.s3_bucket}/*",
    "arn:aws:s3:::${module.react_app_site.s3_bucket}"
  ]
}