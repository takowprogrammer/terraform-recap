variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  #default     = "us-east-1"

  validation {
    condition     = can(regex("^us-", var.aws_region))
    error_message = "For this tutorial, please use a US region (us-east-1, us-east-2, us-west-1, us-west-2)."
  }
}

variable "environment" {
  description = "Environment name (development, staging, production)"
  type        = string
  default     = "development"

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be development, staging, or production."
  }
}

variable "project_name" {
  description = "Name of the project (used for resource naming)"
  type        = string
  default     = "terraform-basics"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Tutorial  = "AWS-Basics"
    Owner     = "Learning"
  }
}
