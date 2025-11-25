# Module 3 Project - Quick Start

## 🚀 How to Run This Project

This module has TWO parts: Backend setup, then Lambda deployment with workspaces.

---

## Part A: Create Backend Infrastructure

### Step 1: Navigate to Backend Setup

```bash
cd module-3-advanced/project/backend-setup
```

### Step 2: Initialize and Deploy

```bash
# Initialize
terraform init

# Preview
terraform plan

# Create S3 bucket and DynamoDB table
terraform apply
# Type 'yes'
```

### Step 3: Note Your Bucket Name

```bash
# Get the bucket name
terraform output state_bucket_name

# Example: terraform-state-123456789012
# SAVE THIS - you'll need it!
```

---

## Part B: Package Lambda Function

### Step 4: Package the Lambda Code

```bash
# Navigate to project directory
cd ..

# Windows:
.\package-lambda.bat

# Linux/Mac:
chmod +x package-lambda.sh
./package-lambda.sh
```

This creates `lambda/function.zip`

---

## Part C: Configure Backend (Optional)

### Step 5: Update backend.tf

If you want to use remote state:

1. Open `backend.tf`
2. Replace `YOUR-ACCOUNT-ID` with your actual account ID
3. Uncomment the terraform block
4. Run: `terraform init -migrate-state`

**For learning, you can skip this and use local state!**

---

## Part D: Deploy Lambda with Workspaces

### Step 6: Initialize Project

```bash
# Make sure you're in: module-3-advanced/project
terraform init
```

### Step 7: Deploy to Dev Environment

```bash
# Create dev workspace
terraform workspace new dev

# Deploy
terraform apply
# Type 'yes'
```

### Step 8: Test Your Lambda Function

```bash
# Get the test command
terraform output test_command

# Copy and run it, example:
curl https://abc123.lambda-url.us-east-1.on.aws/

# You should see JSON response with environment info!
```

### Step 9: Deploy to Other Environments

```bash
# Create and deploy to staging
terraform workspace new staging
terraform apply

# Test staging
terraform output test_command

# Create and deploy to prod
terraform workspace new prod
terraform apply

# Test prod
terraform output test_command
```

### Step 10: Compare Environments

```bash
# List all workspaces
terraform workspace list

# Switch between them
terraform workspace select dev
terraform output deployment_summary

terraform workspace select staging
terraform output deployment_summary

terraform workspace select prod
terraform output deployment_summary

# Notice different memory/timeout configs!
```

---

## 🧹 Clean Up (IMPORTANT!)

### Step 11: Destroy Each Workspace

```bash
# Destroy dev
terraform workspace select dev
terraform destroy
# Type 'yes'

# Destroy staging
terraform workspace select staging
terraform destroy

# Destroy prod
terraform workspace select prod
terraform destroy

# Switch to default and delete workspaces
terraform workspace select default
terraform workspace delete dev
terraform workspace delete staging
terraform workspace delete prod
```

### Step 12: Destroy Backend Infrastructure

```bash
# Navigate to backend setup
cd backend-setup

# Destroy S3 and DynamoDB
terraform destroy
# Type 'yes'
```

### Step 13: Verify Cleanup

Check AWS Console:
- Lambda functions deleted
- IAM roles deleted
- CloudWatch log groups deleted
- S3 state bucket deleted
- DynamoDB table deleted

---

## 📝 What Gets Created

### Backend Infrastructure
- **S3 Bucket**: For Terraform state
  - Versioning enabled
  - Encryption enabled
  - Public access blocked
- **DynamoDB Table**: For state locking
  - PAY_PER_REQUEST billing (free tier friendly)

### Per Workspace
- **Lambda Function**: Python 3.11
  - Dev: 128MB memory, 10s timeout
  - Staging: 256MB memory, 30s timeout
  - Prod: 512MB memory, 60s timeout
- **IAM Role**: For Lambda execution
- **CloudWatch Log Group**: For Lambda logs
- **Function URL**: For easy testing

---

## 💡 Useful Commands

```bash
# List workspaces
terraform workspace list

# Show current workspace
terraform workspace show

# Get Lambda function name
terraform output lambda_function_name

# Get function URL
terraform output lambda_function_url

# View deployment summary
terraform output deployment_summary

# Invoke Lambda via AWS CLI
aws lambda invoke \
  --function-name $(terraform output -raw lambda_function_name) \
  --region us-east-1 \
  output.json
cat output.json
```

---

## 🧪 Testing Lambda Functions

### Method 1: Function URL (Easiest)
```bash
curl $(terraform output -raw lambda_function_url)
```

### Method 2: AWS CLI
```bash
aws lambda invoke \
  --function-name $(terraform output -raw lambda_function_name) \
  output.json

cat output.json
```

### Method 3: AWS Console
```bash
# Get Console URL
terraform output aws_console_urls

# Click the lambda_function URL
# Use the "Test" tab in Console
```

---

## 🔍 View Logs

```bash
# Get log group name
terraform output cloudwatch_log_group

# View logs via AWS CLI
aws logs tail $(terraform output -raw cloudwatch_log_group) --follow

# Or click the cloudwatch_logs URL from outputs
```

---

## ⚠️ Important Notes

- ✅ Lambda free tier: 1M requests/month
- ✅ Each workspace has separate resources
- ✅ State is stored per workspace
- ✅ Always destroy ALL workspaces
- ✅ Backend infrastructure costs ~$0.01/month if left running

---

## 🎯 Understanding Workspaces

```bash
# Workspaces create separate state files
# Location: terraform.tfstate.d/<workspace-name>/

# List state files
ls terraform.tfstate.d/

# Each workspace is independent
# Resources in 'dev' don't affect 'prod'
```

---

## 🆘 Troubleshooting

**Error: "function.zip not found"**
```bash
# Run the package script
package-lambda.bat  # Windows
./package-lambda.sh # Linux/Mac
```

**Error: "workspace already exists"**
```bash
# Switch to it instead
terraform workspace select dev
```

**Lambda function not responding?**
```bash
# Check logs
aws logs tail /aws/lambda/$(terraform output -raw lambda_function_name) --follow
```

**Want to update Lambda code?**
```bash
# 1. Edit lambda/index.py
# 2. Repackage
package-lambda.bat
# 3. Apply
terraform apply
```

---

## 📊 Compare Workspace Configs

| Workspace | Memory | Timeout | Log Retention |
|-----------|--------|---------|---------------|
| dev       | 128 MB | 10s     | 7 days        |
| staging   | 256 MB | 30s     | 14 days       |
| prod      | 512 MB | 60s     | 30 days       |

---

## 🎓 Learning Objectives

After completing this module, you understand:
- ✅ How to use Terraform workspaces
- ✅ Remote state with S3 backend
- ✅ State locking with DynamoDB
- ✅ Lambda function deployment
- ✅ Environment-specific configurations
- ✅ Production-ready patterns
