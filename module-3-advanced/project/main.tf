terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

locals {
  environment = terraform.workspace

  # Environment-specific configuration
  config = {
    dev = {
      lambda_memory  = 128
      lambda_timeout = 10
      log_retention  = 7
    }
    staging = {
      lambda_memory  = 256
      lambda_timeout = 30
      log_retention  = 14
    }
    prod = {
      lambda_memory  = 512
      lambda_timeout = 60
      log_retention  = 30
    }
  }

  current_config = lookup(local.config, local.environment, local.config["dev"])

  common_tags = merge(var.common_tags, {
    Environment = local.environment
    Workspace   = terraform.workspace
  })
}

# IAM role for Lambda execution
resource "aws_iam_role" "lambda" {
  name = "${var.project_name}-${local.environment}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = local.common_tags
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda function
resource "aws_lambda_function" "hello_world" {
  filename      = "${path.module}/lambda/function.zip"
  function_name = "${var.project_name}-${local.environment}-hello"
  role          = aws_iam_role.lambda.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  source_code_hash = filebase64sha256("${path.module}/lambda/function.zip")

  memory_size = local.current_config.lambda_memory
  timeout     = local.current_config.lambda_timeout

  environment {
    variables = {
      ENVIRONMENT = local.environment
      PROJECT     = var.project_name
      WORKSPACE   = terraform.workspace
    }
  }

  tags = local.common_tags
}

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"
  retention_in_days = local.current_config.log_retention

  tags = local.common_tags
}

# Lambda function URL (for easy testing)
resource "aws_lambda_function_url" "hello_world" {
  function_name      = aws_lambda_function.hello_world.function_name
  authorization_type = "NONE"  # For learning only! Use AWS_IAM in production

  cors {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST"]
    max_age       = 300
  }
}
