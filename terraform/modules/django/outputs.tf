output "this_invoke_url" {
  description = "The URL to invoke the API pointing to the stage"
  value       = aws_api_gateway_deployment.lambda.*.invoke_url
}

output "this_createdb" {
  description = "Result of createdb Lambda execution"
  value       = "${data.aws_lambda_invocation.createdb.*.result}"
}

output "dist_access_key_id" {
  description = "The access key ID with access to dist s3 bucket."
  value       = module.s3_bucket_app.access_key_id
}

output "dist_secret_access_key" {
  description = "The secret access key with access to dist s3 bucket. Note that this will be written to the state file."
  value       = module.s3_bucket_app.secret_access_key
}

output "dist_bucket" {
  description = "Name of dist S3 bucket."
  value       = module.s3_bucket_app.bucket_id
}
