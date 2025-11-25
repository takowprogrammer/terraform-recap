# Module 1: Terraform Basics with AWS (45 minutes)

## 🎯 Learning Objectives

- Understand Infrastructure as Code (IaC) concepts
- Learn Terraform configuration syntax (HCL)
- Configure AWS provider
- Work with S3, IAM, and SSM Parameter Store
- Use variables and outputs
- Master the Terraform workflow

## 📖 Theory (10 minutes)

### What is Infrastructure as Code?

Infrastructure as Code (IaC) is the practice of managing and provisioning infrastructure through machine-readable definition files, rather than manual processes.

**Benefits:**
- ✅ Version control for infrastructure
- ✅ Reproducible environments
- ✅ Automated deployments
- ✅ Documentation through code
- ✅ Reduced human error

### What is Terraform?

Terraform is an open-source IaC tool by HashiCorp that allows you to define infrastructure using declarative configuration files.

**Key Concepts:**
- **Providers**: Plugins that interact with APIs (AWS, Azure, Docker, etc.)
- **Resources**: Infrastructure components (S3 buckets, EC2 instances, etc.)
- **State**: Terraform's record of your infrastructure
- **Modules**: Reusable Terraform configurations

### Terraform Workflow

```
terraform init    → Initialize working directory, download providers
terraform plan    → Preview changes before applying
terraform apply   → Create/update infrastructure
terraform destroy → Remove all managed infrastructure
```

## 🛠️ Hands-On Project: AWS Storage and Identity Management

We'll build a simple AWS infrastructure using S3, IAM, and SSM Parameter Store.

### Prerequisites

> [!IMPORTANT]
> Before starting, ensure you've completed [AWS_SETUP.md](file:///C:/Users/Takow%20Carvin/Documents/terraform-recap/AWS_SETUP.md)

Verify AWS credentials:
```bash
aws sts get-caller-identity
```

### Step 1: Your First Terraform Configuration

Create `main.tf`:

```hcl
# Configure the AWS provider
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
  region = "us-east-1"
}

# Create an S3 bucket
resource "aws_s3_bucket" "terraform_basics" {
  bucket = "terraform-basics-${random_id.bucket_suffix.hex}"
  
  tags = {
    Name        = "Terraform Basics Bucket"
    Environment = "Learning"
    ManagedBy   = "Terraform"
  }
}

# Generate random suffix for unique bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}
```

**Run it:**
```bash
cd module-1-basics/project
terraform init
terraform plan
terraform apply
```

**Explanation:**
- `terraform {}` block: Specifies required providers and Terraform version
- `provider "aws"` block: Configures AWS provider with region
- `resource` block: Defines infrastructure to create
- `random_id`: Ensures unique bucket names (S3 buckets must be globally unique)

### Step 2: Using Variables

Create `variables.tf`:

```hcl
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
  
  validation {
    condition     = can(regex("^us-", var.aws_region))
    error_message = "For this tutorial, please use a US region."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
  
  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be development, staging, or production."
  }
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "terraform-basics"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Tutorial  = "AWS-Basics"
  }
}
```

Update `main.tf` to use variables:

```hcl
provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "terraform_basics" {
  bucket = "${var.project_name}-${var.environment}-${random_id.bucket_suffix.hex}"
  
  tags = merge(var.common_tags, {
    Name        = "${var.project_name} Bucket"
    Environment = var.environment
  })
}
```

**Run with variables:**
```bash
terraform apply -var="project_name=my-project"
```

### Step 3: Outputs

Create `outputs.tf`:

```hcl
output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.terraform_basics.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.terraform_basics.arn
}

output "bucket_region" {
  description = "Region of the S3 bucket"
  value       = aws_s3_bucket.terraform_basics.region
}

output "aws_console_url" {
  description = "URL to view bucket in AWS Console"
  value       = "https://s3.console.aws.amazon.com/s3/buckets/${aws_s3_bucket.terraform_basics.id}"
}
```

After `terraform apply`, you'll see the outputs displayed.

### Step 4: IAM Resources

Add to `main.tf`:

```hcl
# Create IAM user
resource "aws_iam_user" "app_user" {
  name = "${var.project_name}-app-user"
  
  tags = merge(var.common_tags, {
    Name = "Application User"
  })
}

# Create IAM policy for S3 read access
resource "aws_iam_policy" "s3_read_policy" {
  name        = "${var.project_name}-s3-read"
  description = "Allow read access to S3 bucket"
  
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
}

# Attach policy to user
resource "aws_iam_user_policy_attachment" "app_user_s3" {
  user       = aws_iam_user.app_user.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}
```

### Step 5: SSM Parameter Store

Add to `main.tf`:

```hcl
# Store configuration in SSM Parameter Store
resource "aws_ssm_parameter" "app_config" {
  name  = "/${var.project_name}/${var.environment}/config"
  type  = "String"
  value = jsonencode({
    bucket_name = aws_s3_bucket.terraform_basics.id
    environment = var.environment
    version     = "1.0.0"
  })
  
  tags = merge(var.common_tags, {
    Name = "Application Configuration"
  })
}
```

## 💪 Exercises

### Exercise 1: Create Additional S3 Buckets (Easy)
Create 2 more S3 buckets with different purposes:
- One for logs
- One for backups

**Hint:** Use multiple `aws_s3_bucket` resources.

### Exercise 2: S3 Bucket Versioning (Medium)
Enable versioning on your S3 bucket using `aws_s3_bucket_versioning` resource.

**Hint:** Look up the AWS provider documentation.

### Exercise 3: Multiple IAM Users (Medium)
Create 3 IAM users using the `count` meta-argument:
- app-user-1
- app-user-2
- app-user-3

**Hint:** Use `count` and `count.index`.

### Exercise 4: Data Sources (Advanced)
Use a data source to fetch the current AWS account ID and region, then output them.

**Hint:** Look up `aws_caller_identity` and `aws_region` data sources.

## 📝 Key Takeaways

- Terraform uses **declarative** syntax (describe what you want, not how)
- Always run `terraform init` first in a new directory
- Use `terraform plan` to preview changes before applying
- Variables make configurations reusable and flexible
- Outputs expose information about your infrastructure
- State file (`terraform.tfstate`) tracks your infrastructure
- **Always destroy resources after learning** to avoid charges

## 🧹 Cleanup

**Critical:** After completing this module, destroy all resources:

```bash
terraform destroy
```

Verify in AWS Console:
- S3 buckets deleted
- IAM users and policies deleted
- SSM parameters deleted

See [CLEANUP.md](file:///C:/Users/Takow%20Carvin/Documents/terraform-recap/CLEANUP.md) for detailed cleanup instructions.

## 🎓 Quiz Yourself

1. What's the difference between a resource and a data source?
2. Why should you use variables instead of hardcoding values?
3. What happens if you delete a resource from your `.tf` file and run `terraform apply`?
4. Where does Terraform store the state of your infrastructure?
5. Why must S3 bucket names be globally unique?

## ⏭️ Next Steps

Once you've completed the exercises and cleaned up:

1. ✅ Run `terraform destroy`
2. ✅ Verify resources deleted in AWS Console
3. ✅ Check AWS Billing Dashboard (should show $0.00)
4. ✅ Move to **Module 2** to learn about VPC and EC2

---

**Time Check:** You should have spent about 45 minutes on this module. Take a 5-minute break before Module 2! ☕

## 🎯 Learning Objectives

- Understand Infrastructure as Code (IaC) concepts
- Learn Terraform configuration syntax (HCL)
- Work with providers, resources, and data sources
- Use variables and outputs
- Master the Terraform workflow

## 📖 Theory (10 minutes)

### What is Infrastructure as Code?

Infrastructure as Code (IaC) is the practice of managing and provisioning infrastructure through machine-readable definition files, rather than manual processes.

**Benefits:**
- ✅ Version control for infrastructure
- ✅ Reproducible environments
- ✅ Automated deployments
- ✅ Documentation through code
- ✅ Reduced human error

### What is Terraform?

Terraform is an open-source IaC tool by HashiCorp that allows you to define infrastructure using declarative configuration files.

**Key Concepts:**
- **Providers**: Plugins that interact with APIs (AWS, Azure, Docker, etc.)
- **Resources**: Infrastructure components (servers, networks, files, etc.)
- **State**: Terraform's record of your infrastructure
- **Modules**: Reusable Terraform configurations

### Terraform Workflow

```
terraform init    → Initialize working directory, download providers
terraform plan    → Preview changes before applying
terraform apply   → Create/update infrastructure
terraform destroy → Remove all managed infrastructure
```

## 🛠️ Hands-On Project: Local File Management System

We'll build a simple file management system using Terraform's `local` provider.

### Step 1: Your First Terraform Configuration

Create a file called `main.tf`:

```hcl
# Configure the local provider
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Create a simple text file
resource "local_file" "welcome" {
  filename = "${path.module}/output/welcome.txt"
  content  = "Welcome to Terraform!"
}
```

**Run it:**
```bash
cd module-1-basics/project
terraform init
terraform plan
terraform apply
```

**Explanation:**
- `terraform {}` block: Specifies required providers
- `resource` block: Defines infrastructure to create
- `local_file`: Resource type from local provider
- `welcome`: Resource name (unique identifier)

### Step 2: Using Variables

Create `variables.tf`:

```hcl
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "file_count" {
  description = "Number of files to create"
  type        = number
  default     = 3
}
```

Update `main.tf` to use variables:

```hcl
resource "local_file" "config" {
  filename = "${path.module}/output/${var.environment}-config.txt"
  content  = "Project: ${var.project_name}\nEnvironment: ${var.environment}"
}
```

**Run with variables:**
```bash
terraform apply -var="project_name=MyApp"
```

### Step 3: Outputs

Create `outputs.tf`:

```hcl
output "config_file_path" {
  description = "Path to the configuration file"
  value       = local_file.config.filename
}

output "config_content" {
  description = "Content of the configuration file"
  value       = local_file.config.content
}
```

After `terraform apply`, you'll see the outputs displayed.

### Step 4: Using Data Sources

Data sources allow you to fetch information. Add to `main.tf`:

```hcl
# Read an existing file
data "local_file" "readme" {
  filename = "${path.module}/../README.md"
}

# Create a new file with content from data source
resource "local_file" "readme_copy" {
  filename = "${path.module}/output/readme-backup.txt"
  content  = data.local_file.readme.content
}
```

## 💪 Exercises

### Exercise 1: Create Multiple Files (Easy)
Create 5 different text files with different content using Terraform.

**Hint:** Use multiple `local_file` resources.

### Exercise 2: Use Variables (Medium)
Create a configuration that:
- Accepts a list of filenames as a variable
- Creates a file for each name in the list
- Uses `count` to iterate

**Hint:** Look up `count` meta-argument.

### Exercise 3: Template Files (Medium)
Create a JSON configuration file using variables:
- Project name
- Version number
- List of features

**Hint:** Use `jsonencode()` function.

### Exercise 4: Directory Structure (Advanced)
Create a complete project structure:
```
project/
  ├── src/
  │   └── main.txt
  ├── config/
  │   └── settings.json
  └── docs/
      └── README.md
```

**Hint:** Use `local_file` for files. Directories are created automatically.

## 📝 Key Takeaways

- Terraform uses **declarative** syntax (describe what you want, not how)
- Always run `terraform init` first in a new directory
- Use `terraform plan` to preview changes before applying
- Variables make configurations reusable
- Outputs expose information about your infrastructure
- State file (`terraform.tfstate`) tracks your infrastructure

## 🎓 Quiz Yourself

1. What's the difference between a resource and a data source?
2. Why should you use variables instead of hardcoding values?
3. What happens if you delete a resource from your `.tf` file and run `terraform apply`?
4. Where does Terraform store the state of your infrastructure?

## ⏭️ Next Steps

Once you've completed the exercises, move to **Module 2** to learn about:
- Docker provider
- State management
- Creating modules
- Advanced resource relationships

---

**Time Check:** You should have spent about 45 minutes on this module. Take a 5-minute break before Module 2! ☕
