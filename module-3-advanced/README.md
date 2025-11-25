# Module 3: Advanced Features with AWS (45 minutes)

## 🎯 Learning Objectives

- Use workspaces for multi-environment management
- Configure S3 backend for remote state
- Implement DynamoDB state locking
- Deploy AWS Lambda functions
- Apply Terraform best practices
- Understand production-ready patterns

## 📖 Theory (10 minutes)

### Workspaces

Workspaces allow you to manage multiple instances of infrastructure with the same configuration:
- `default` workspace is created automatically
- Each workspace has its own state file
- Perfect for dev/staging/prod environments

**Commands:**
```bash
terraform workspace list
terraform workspace new dev
terraform workspace select dev
terraform workspace show
```

### Remote State

In production, state should be stored remotely:
- ✅ Team collaboration
- ✅ State locking (prevents concurrent modifications)
- ✅ Backup and versioning
- ✅ Encryption at rest

**S3 Backend Benefits:**
- Versioning for state history
- Encryption
- Access control via IAM
- Works with DynamoDB for locking

### State Locking

DynamoDB provides state locking to prevent conflicts:
- Prevents multiple users from modifying state simultaneously
- Automatic with S3 backend
- Uses a DynamoDB table with specific schema

### AWS Lambda

Serverless compute service:
- **Free Tier**: 1M requests/month, 400,000 GB-seconds
- No server management
- Pay only for compute time
- Scales automatically

## 🛠️ Hands-On Project: Multi-Environment Serverless Application

We'll create:
- S3 bucket for remote state
- DynamoDB table for state locking
- Lambda function with different configs per environment
- Workspace-aware infrastructure

### Prerequisites

> [!IMPORTANT]
> - Completed Modules 1 and 2
> - Destroyed all previous resources
> - AWS credentials configured

### Step 1: Create State Backend Infrastructure

**Important:** This must be created FIRST, before configuring backend.

Create `backend-setup/main.tf`:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# S3 bucket for Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name      = "Terraform State Bucket"
    ManagedBy = "Terraform"
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"  # Free tier friendly
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name      = "Terraform State Locks"
    ManagedBy = "Terraform"
  }
}

data "aws_caller_identity" "current" {}

output "state_bucket_name" {
  value = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}
```

**Deploy backend infrastructure:**
```bash
cd backend-setup
terraform init
terraform apply
# Note the bucket name from outputs!
```

### Step 2: Configure Remote Backend

Create `backend.tf` in main project:

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state-YOUR-ACCOUNT-ID"  # Replace with your bucket
    key            = "module-3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
```

### Step 3: Workspace-Aware Configuration

Create `main.tf`:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  environment = terraform.workspace

  # Environment-specific configuration
  config = {
    dev = {
      lambda_memory = 128
      lambda_timeout = 10
    }
    staging = {
      lambda_memory = 256
      lambda_timeout = 30
    }
    prod = {
      lambda_memory = 512
      lambda_timeout = 60
    }
  }

  current_config = local.config[local.environment]
}

# Lambda execution role
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

  tags = merge(var.common_tags, {
    Environment = local.environment
  })
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

  memory_size = local.current_config.lambda_memory
  timeout     = local.current_config.lambda_timeout

  environment {
    variables = {
      ENVIRONMENT = local.environment
      PROJECT     = var.project_name
    }
  }

  tags = merge(var.common_tags, {
    Environment = local.environment
  })
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"
  retention_in_days = 7

  tags = merge(var.common_tags, {
    Environment = local.environment
  })
}
```

### Step 4: Lambda Function Code

Create `lambda/index.py`:

```python
import json
import os

def handler(event, context):
    """
    Simple Lambda function that returns environment information
    """
    environment = os.environ.get('ENVIRONMENT', 'unknown')
    project = os.environ.get('PROJECT', 'unknown')
    
    response = {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps({
            'message': f'Hello from {environment} environment!',
            'project': project,
            'environment': environment,
            'function_name': context.function_name,
            'memory_limit': context.memory_limit_in_mb,
            'request_id': context.request_id
        })
    }
    
    return response
```

**Package the Lambda function:**
```bash
cd lambda
zip function.zip index.py
cd ..
```

### Step 5: Working with Workspaces

```bash
# Initialize with backend
terraform init

# Create and deploy to dev
terraform workspace new dev
terraform apply

# Create and deploy to staging
terraform workspace new staging
terraform apply

# Create and deploy to prod
terraform workspace new prod
terraform apply

# List workspaces
terraform workspace list

# Switch between workspaces
terraform workspace select dev
terraform plan
```

## 💪 Exercises

### Exercise 1: Test Lambda Functions (Easy)
Use AWS CLI to invoke Lambda functions in different environments:
```bash
aws lambda invoke --function-name PROJECT-dev-hello output.json
cat output.json
```

### Exercise 2: Add API Gateway (Advanced)
Create an API Gateway to expose Lambda function via HTTP.

**Hint:** Use `aws_api_gateway_rest_api` resource.

### Exercise 3: Multi-Region Deployment (Advanced)
Deploy the same infrastructure to multiple AWS regions.

**Hint:** Use provider aliases.

### Exercise 4: State Migration (Advanced)
Practice migrating from local state to remote state.

## 📝 Best Practices

### 1. Backend Configuration

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "path/to/state"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

### 2. Workspace Naming

```hcl
locals {
  environment = terraform.workspace
  name_prefix = "${var.project}-${local.environment}"
}
```

### 3. Environment-Specific Variables

```hcl
locals {
  config = {
    dev     = { instance_type = "t2.micro" }
    staging = { instance_type = "t2.small" }
    prod    = { instance_type = "t2.medium" }
  }
}
```

### 4. Tagging Strategy

```hcl
locals {
  common_tags = {
    Project     = var.project_name
    Environment = local.environment
    ManagedBy   = "Terraform"
    Workspace   = terraform.workspace
  }
}
```

## 🚀 Production Readiness Checklist

- ✅ Use remote state backend (S3)
- ✅ Enable state locking (DynamoDB)
- ✅ Enable state encryption
- ✅ Use workspaces for environments
- ✅ Implement proper tagging
- ✅ Use variables for all configurable values
- ✅ Document your modules
- ✅ Use version constraints
- ✅ Store secrets in AWS Secrets Manager (not in code)
- ✅ Enable CloudWatch logging

## 🧹 Cleanup

**Critical:** Clean up ALL workspaces:

```bash
# Destroy each workspace
terraform workspace select dev
terraform destroy

terraform workspace select staging
terraform destroy

terraform workspace select prod
terraform destroy

# Switch to default and delete workspaces
terraform workspace select default
terraform workspace delete dev
terraform workspace delete staging
terraform workspace delete prod

# Destroy backend infrastructure
cd backend-setup
terraform destroy
```

Verify in AWS Console:
- Lambda functions deleted
- IAM roles deleted
- CloudWatch log groups deleted
- S3 state bucket deleted
- DynamoDB table deleted

## 🎓 Quiz Yourself

1. Why is remote state important for teams?
2. How does DynamoDB provide state locking?
3. When should you use workspaces vs separate directories?
4. What are the benefits of Lambda over EC2?
5. How do you migrate from local to remote state?

## 🎉 Congratulations!

You've completed the Terraform AWS tutorial! You now know:
- ✅ AWS infrastructure basics (S3, IAM, VPC, EC2)
- ✅ Remote state management
- ✅ Serverless deployment with Lambda
- ✅ Multi-environment strategies
- ✅ Production best practices

### Next Steps:
1. **Practice**: Build your own projects
2. **Explore**: Try other AWS services (RDS, ECS, EKS)
3. **Learn**: Terraform Cloud for team collaboration
4. **Automate**: Integrate with CI/CD pipelines
5. **Certify**: Consider HashiCorp Terraform Associate certification

---

**Total Time:** ~2.5 hours ⏱️

Thank you for completing this tutorial! Keep building! 🚀
