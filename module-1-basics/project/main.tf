# Configure the AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

# Generate random suffix for unique bucket names
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Create main S3 bucket
resource "aws_s3_bucket" "terraform_basics" {
  bucket = "${var.project_name}-${var.environment}-${random_id.bucket_suffix.hex}"

  tags = merge(var.common_tags, {
    Name        = "${var.project_name} Main Bucket"
    Environment = var.environment
    Purpose     = "Learning Terraform"
  })
}

# Enable versioning on the bucket
resource "aws_s3_bucket_versioning" "terraform_basics" {
  bucket = aws_s3_bucket.terraform_basics.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "terraform_basics" {
  bucket = aws_s3_bucket.terraform_basics.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create IAM user for application
resource "aws_iam_user" "app_user" {
  name = "${var.project_name}-app-user"

  tags = merge(var.common_tags, {
    Name    = "Application User"
    Purpose = "S3 Access"
  })
}

# Create IAM policy for S3 read access
resource "aws_iam_policy" "s3_read_policy" {
  name        = "${var.project_name}-s3-read-policy"
  description = "Allow read access to ${var.project_name} S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.terraform_basics.arn,
          "${aws_s3_bucket.terraform_basics.arn}/*"
        ]
      }
    ]
  })

  tags = var.common_tags
}

# Attach policy to user
resource "aws_iam_user_policy_attachment" "app_user_s3" {
  user       = aws_iam_user.app_user.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

# Store configuration in SSM Parameter Store
resource "aws_ssm_parameter" "app_config" {
  name  = "/${var.project_name}/${var.environment}/config"
  type  = "String"
  value = jsonencode({
    bucket_name = aws_s3_bucket.terraform_basics.id
    bucket_arn  = aws_s3_bucket.terraform_basics.arn
    environment = var.environment
    version     = "1.0.0"
    created_at  = timestamp()
  })

  tags = merge(var.common_tags, {
    Name = "Application Configuration"
  })
}

# Data source: Get current AWS account information
data "aws_caller_identity" "current" {}

# Data source: Get current AWS region
data "aws_region" "current" {}
