# Module 1 Project - Quick Start

## 🚀 How to Run This Project

### Step 1: Verify Prerequisites

```bash
# Check AWS credentials
aws sts get-caller-identity

# Check Terraform is installed
terraform version
```

### Step 2: Initialize Terraform

```bash
# Navigate to this directory
cd module-1-basics/project

# Initialize (downloads AWS provider)
terraform init
```

### Step 3: Preview Changes

```bash
# See what will be created
terraform plan
```

### Step 4: Create Resources

```bash
# Create S3 bucket, IAM user, SSM parameter
terraform apply

# Type 'yes' when prompted
```

### Step 5: View Outputs

```bash
# See all outputs
terraform output

# Get specific output
terraform output bucket_name

# Get AWS Console URLs
terraform output aws_console_urls
```

### Step 6: Verify in AWS Console

Click the URLs from the output to see your resources in AWS Console:
- S3 bucket
- IAM user
- SSM parameter

### Step 7: Clean Up (IMPORTANT!)

```bash
# Destroy all resources to avoid charges
terraform destroy

# Type 'yes' when prompted
```

### Step 8: Verify Cleanup

```bash
# Check AWS Console to ensure:
# - S3 bucket is deleted
# - IAM user is deleted
# - SSM parameter is deleted
```

---

## 📝 What Gets Created

- **S3 Bucket**: `terraform-basics-development-XXXXXXXX`
  - With versioning enabled
  - Public access blocked
  
- **IAM User**: `terraform-basics-app-user`
  - With S3 read policy attached
  
- **SSM Parameter**: `/terraform-basics/development/config`
  - Contains JSON configuration

---

## 💡 Useful Commands

```bash
# Format code
terraform fmt

# Validate configuration
terraform validate

# Show current state
terraform show

# List all resources
terraform state list

# Get outputs as JSON
terraform output -json
```

---

## ⚠️ Important Notes

- ✅ Always run `terraform destroy` when done
- ✅ Check AWS billing dashboard after cleanup
- ✅ All resources are free tier eligible
- ✅ S3 bucket names must be globally unique (handled by random suffix)

---

## 🆘 Troubleshooting

**Error: "No valid credential sources"**
```bash
aws configure
# Enter your AWS access key and secret key
```

**Error: "BucketAlreadyExists"**
```bash
# The random suffix should prevent this
# If it happens, run: terraform destroy
# Then: terraform apply
```

**Want to use different variables?**
```bash
terraform apply -var="project_name=my-project" -var="environment=staging"
```
