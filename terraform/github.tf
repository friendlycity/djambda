data "github_actions_public_key" "djambda" {
  repository = var.github_repository
}

#########################
# deploy
#########################
resource "github_actions_secret" "aws_access_key_id_deploy" {
  count           = var.github_repository != "" ? 1 : 0
  repository      = var.github_repository
  secret_name     = "AWS_S3_ACCESS_KEY_ID_DEPLOY"
  plaintext_value = module.django.dist_access_key_id
}

resource "github_actions_secret" "aws_secret_access_key_deploy" {
  count           = var.github_repository != "" ? 1 : 0
  repository      = var.github_repository
  secret_name     = "AWS_S3_SECRET_ACCESS_KEY_DEPLOY"
  plaintext_value = module.django.dist_secret_access_key
}

resource "github_actions_secret" "aws_s3_bucket_name_deploy" {
  count           = var.github_repository != "" ? 1 : 0
  repository      = var.github_repository
  secret_name     = "AWS_S3_BUCKET_NAME_DEPLOY"
  plaintext_value = module.django.dist_bucket
}
