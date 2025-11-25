# AWS Account Setup Guide

## 🎯 Overview

This guide will help you set up your AWS account and credentials to complete the Terraform tutorial. All examples use **AWS Free Tier** services to avoid costs.

## 📋 Prerequisites

- Email address
- Credit/debit card (required by AWS, but won't be charged for free tier usage)
- Phone number for verification

## 🚀 Step 1: Create AWS Free Tier Account

1. **Visit AWS Signup Page**
   - Go to: https://aws.amazon.com/free/
   - Click "Create a Free Account"

2. **Enter Account Information**
   - Email address
   - Account name (e.g., "terraform-learning")
   - Choose "Personal" account type

3. **Provide Contact Information**
   - Full name, phone number, address
   - Agree to AWS Customer Agreement

4. **Add Payment Method**
   - Enter credit/debit card details
   - You won't be charged if you stay within free tier limits
   - AWS may charge $1 for verification (refunded)

5. **Verify Identity**
   - Choose phone verification
   - Enter code received via SMS or call

6. **Select Support Plan**
   - Choose "Basic support - Free"

7. **Complete Signup**
   - Wait for account activation (can take a few minutes)
   - Check email for confirmation

## 💳 Step 2: Set Up Billing Alerts

**Critical:** Set up billing alerts to avoid unexpected charges!

1. **Enable Billing Alerts**
   - Sign in to AWS Console: https://console.aws.amazon.com/
   - Click your account name (top right) → "Account"
   - Scroll to "Billing preferences"
   - Check "Receive Billing Alerts"
   - Click "Save preferences"

2. **Create CloudWatch Billing Alarm**
   - Go to CloudWatch: https://console.aws.amazon.com/cloudwatch/
   - **Important:** Switch region to **US East (N. Virginia)** - billing metrics only available here
   - Click "Alarms" → "Billing" → "Create alarm"
   - Click "Select metric" → "Billing" → "Total Estimated Charge"
   - Check "USD" → "Select metric"
   - Set threshold: $1 (or your preferred amount)
   - Click "Next"
   - Create new SNS topic for email notifications
   - Enter your email address
   - Click "Create topic"
   - Click "Next" → "Create alarm"
   - **Check your email** and confirm the SNS subscription

3. **Create Additional Alarms** (Recommended)
   - Repeat for $5, $10 thresholds
   - This gives you multiple warning levels

## 🔑 Step 3: Create IAM User for Terraform

**Never use root account credentials for Terraform!**

1. **Go to IAM Console**
   - Navigate to: https://console.aws.amazon.com/iam/

2. **Create New User**
   - Click "Users" → "Create user"
   - Username: `terraform-user`
   - Click "Next"

3. **Set Permissions**
   - Select "Attach policies directly"
   - For learning, attach: `AdministratorAccess`
   - **Note:** In production, use least privilege policies
   - Click "Next"

4. **Review and Create**
   - Review settings
   - Click "Create user"

5. **Create Access Keys**
   - Click on the newly created user
   - Go to "Security credentials" tab
   - Click "Create access key"
   - Choose "Command Line Interface (CLI)"
   - Check "I understand" → "Next"
   - Add description: "Terraform tutorial"
   - Click "Create access key"
   - **IMPORTANT:** Download the CSV file or copy the keys
   - You won't be able to see the secret key again!

## 🖥️ Step 4: Install AWS CLI

### Windows (PowerShell)

```powershell
# Download and run the installer
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

# Verify installation
aws --version
```

### macOS

```bash
# Using Homebrew
brew install awscli

# Or download installer
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

# Verify installation
aws --version
```

### Linux

```bash
# Download and install
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify installation
aws --version
```

## 🔧 Step 5: Configure AWS Credentials

### Method 1: AWS CLI Configure (Recommended)

```bash
aws configure

# You'll be prompted for:
# AWS Access Key ID: [paste your access key]
# AWS Secret Access Key: [paste your secret key]
# Default region name: us-east-1
# Default output format: json
```

This creates files at:
- Windows: `C:\Users\YourName\.aws\credentials` and `C:\Users\YourName\.aws\config`
- Mac/Linux: `~/.aws/credentials` and `~/.aws/config`

### Method 2: Environment Variables

```bash
# Windows (PowerShell)
$env:AWS_ACCESS_KEY_ID="your-access-key"
$env:AWS_SECRET_ACCESS_KEY="your-secret-key"
$env:AWS_DEFAULT_REGION="us-east-1"

# Mac/Linux (Bash)
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

## ✅ Step 6: Verify Setup

```bash
# Test AWS CLI connection
aws sts get-caller-identity

# Expected output:
# {
#     "UserId": "AIDAXXXXXXXXXXXXXXXXX",
#     "Account": "123456789012",
#     "Arn": "arn:aws:iam::123456789012:user/terraform-user"
# }

# List S3 buckets (should be empty initially)
aws s3 ls
```

## 🛡️ Security Best Practices

### 1. Protect Your Credentials

- ✅ Never commit credentials to Git
- ✅ Never share access keys
- ✅ Use `.gitignore` for credential files
- ✅ Rotate keys regularly (every 90 days)

### 2. Use MFA (Optional but Recommended)

1. Go to IAM → Users → your user
2. Security credentials → Assign MFA device
3. Follow the wizard to set up virtual MFA

### 3. Monitor Your Account

- Check AWS Billing Dashboard daily during tutorial
- Review CloudWatch alarms
- Use AWS Cost Explorer

## 📊 Understanding AWS Free Tier

### Free Tier Types

1. **Always Free**
   - Lambda: 1M requests/month
   - DynamoDB: 25GB storage
   - CloudWatch: 10 custom metrics

2. **12 Months Free** (from account creation)
   - EC2: 750 hours/month of t2.micro
   - S3: 5GB storage
   - RDS: 750 hours/month of db.t2.micro

3. **Trials**
   - Various services with time-limited trials

### What This Tutorial Uses

- ✅ **S3**: Well within 5GB limit
- ✅ **EC2**: t2.micro instances, <750 hours/month
- ✅ **Lambda**: Minimal invocations
- ✅ **DynamoDB**: <25GB storage
- ✅ **IAM, VPC, CloudWatch**: Always free

### What to Avoid (Costs Money)

- ❌ NAT Gateways ($0.045/hour)
- ❌ Elastic Load Balancers ($0.025/hour)
- ❌ RDS instances larger than db.t2.micro
- ❌ Data transfer >100GB/month
- ❌ Elastic IPs not attached to running instances

## 🧹 Important: Resource Cleanup

**After each module, run:**

```bash
terraform destroy
```

**Verify in AWS Console:**
- EC2 Dashboard: No running instances
- S3: No buckets (or empty buckets)
- VPC: Only default VPC remains
- CloudWatch: No custom alarms (except billing)

## 🆘 Troubleshooting

### "Unable to locate credentials"

```bash
# Check credentials file exists
# Windows
type %USERPROFILE%\.aws\credentials

# Mac/Linux
cat ~/.aws/credentials

# Reconfigure if needed
aws configure
```

### "Access Denied" errors

- Verify IAM user has correct permissions
- Check you're using IAM user credentials, not root
- Ensure credentials are correctly configured

### "Region not specified"

```bash
# Set default region
aws configure set region us-east-1

# Or specify in Terraform
provider "aws" {
  region = "us-east-1"
}
```

### Unexpected charges

1. Check AWS Billing Dashboard
2. Use AWS Cost Explorer to identify resources
3. Run `terraform destroy` on all modules
4. Manually check for orphaned resources

## 📞 AWS Support

- **Free Tier Support**: https://aws.amazon.com/free/
- **Billing Support**: Available even on free tier
- **Documentation**: https://docs.aws.amazon.com/

## ⏭️ Next Steps

Once your AWS account is set up:

1. ✅ Verify `aws sts get-caller-identity` works
2. ✅ Confirm billing alerts are active
3. ✅ Return to main tutorial README
4. ✅ Start with Module 1

---

**Ready to start?** Head back to the main [README.md](file:///C:/Users/Takow%20Carvin/Documents/terraform-recap/README.md) to begin the tutorial! 🚀
