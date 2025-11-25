output "environment" {
  description = "Current workspace/environment"
  value       = local.environment
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.hello_world.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.hello_world.arn
}

output "lambda_function_url" {
  description = "URL to invoke the Lambda function"
  value       = aws_lambda_function_url.hello_world.function_url
}

output "lambda_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda.arn
}

output "cloudwatch_log_group" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda.name
}

output "aws_console_urls" {
  description = "URLs to view resources in AWS Console"
  value = {
    lambda_function = "https://console.aws.amazon.com/lambda/home?region=${var.aws_region}#/functions/${aws_lambda_function.hello_world.function_name}"
    cloudwatch_logs = "https://console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#logsV2:log-groups/log-group/${replace(aws_cloudwatch_log_group.lambda.name, "/", "$252F")}"
    iam_role        = "https://console.aws.amazon.com/iam/home#/roles/${aws_iam_role.lambda.name}"
  }
}

output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    project      = var.project_name
    environment  = local.environment
    workspace    = terraform.workspace
    region       = var.aws_region
    lambda = {
      name    = aws_lambda_function.hello_world.function_name
      memory  = local.current_config.lambda_memory
      timeout = local.current_config.lambda_timeout
      url     = aws_lambda_function_url.hello_world.function_url
    }
  }
}

output "test_command" {
  description = "Command to test the Lambda function"
  value       = "curl ${aws_lambda_function_url.hello_world.function_url}"
}
