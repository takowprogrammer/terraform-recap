output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.terraform_basics.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.terraform_basics.arn
}

output "bucket_region" {
  description = "Region where the S3 bucket is located"
  value       = aws_s3_bucket.terraform_basics.region
}

output "iam_user_name" {
  description = "Name of the IAM user"
  value       = aws_iam_user.app_user.name
}

output "iam_user_arn" {
  description = "ARN of the IAM user"
  value       = aws_iam_user.app_user.arn
}

output "iam_policy_arn" {
  description = "ARN of the IAM policy"
  value       = aws_iam_policy.s3_read_policy.arn
}

output "ssm_parameter_name" {
  description = "Name of the SSM parameter"
  value       = aws_ssm_parameter.app_config.name
}

output "aws_account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS Region"
  value       = data.aws_region.current.name
}

output "aws_console_urls" {
  description = "URLs to view resources in AWS Console"
  value = {
    s3_bucket  = "https://s3.console.aws.amazon.com/s3/buckets/${aws_s3_bucket.terraform_basics.id}"
    iam_user   = "https://console.aws.amazon.com/iam/home#/users/${aws_iam_user.app_user.name}"
    ssm_param  = "https://console.aws.amazon.com/systems-manager/parameters${aws_ssm_parameter.app_config.name}/description"
  }
}

output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    project     = var.project_name
    environment = var.environment
    region      = var.aws_region
    resources = {
      s3_bucket     = aws_s3_bucket.terraform_basics.id
      iam_user      = aws_iam_user.app_user.name
      ssm_parameter = aws_ssm_parameter.app_config.name
    }
  }
}
