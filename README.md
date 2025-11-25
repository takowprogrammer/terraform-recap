# Terraform Practical Learning Session (2-3 Hours)

## 🎯 Overview

This hands-on tutorial takes you from Terraform basics to advanced features through a progressive project-based approach using **real AWS infrastructure**. All examples use **AWS Free Tier** services to avoid costs.

## 📋 Prerequisites

### Required

- **AWS Account** (Free Tier)
  - Create at: https://aws.amazon.com/free/
  - **See [AWS_SETUP.md](file:///C:/Users/Takow%20Carvin/Documents/terraform-recap/AWS_SETUP.md) for complete setup guide**
- **AWS CLI** installed and configured
  - Download from: https://aws.amazon.com/cli/
  - Verify: `aws --version`
  - Configure: `aws configure`
- **Terraform** installed (version 1.0+)
  - Download from: https://www.terraform.io/downloads
  - Verify: `terraform version`
- **Text Editor** (VS Code recommended with Terraform extension)
- **Basic command-line knowledge**

### Important Setup Steps

> [!WARNING]
> **Before starting the tutorial:**
> 1. ✅ Complete [AWS_SETUP.md](file:///C:/Users/Takow%20Carvin/Documents/terraform-recap/AWS_SETUP.md) - Set up AWS account and credentials
> 2. ✅ Set up billing alerts ($1, $5, $10 thresholds)
> 3. ✅ Verify `aws sts get-caller-identity` works
> 4. ✅ Read [CLEANUP.md](file:///C:/Users/Takow%20Carvin/Documents/terraform-recap/CLEANUP.md) - Understand resource cleanup

## 🗂️ Tutorial Structure

### Module 1: Terraform Basics (45 minutes)
**Project: AWS Storage and Identity Management**
- Introduction to Terraform and IaC concepts
- AWS provider configuration
- S3 buckets and IAM resources
- Variables and outputs
- Terraform workflow: init, plan, apply, destroy

**AWS Services:** S3, IAM, SSM Parameter Store
📁 Location: `module-1-basics/`

### Module 2: Intermediate Concepts (60 minutes)
**Project: VPC and EC2 Web Server**
- VPC networking (subnets, route tables, IGW)
- EC2 instance deployment (t2.micro free tier)
- Security groups and network ACLs
- Creating reusable VPC modules
- Count and for_each meta-arguments

**AWS Services:** VPC, EC2, Security Groups
📁 Location: `module-2-intermediate/`

### Module 3: Advanced Features (45 minutes)
**Project: Multi-Environment Serverless Application**
- Workspaces for environment management
- Remote state with S3 backend
- DynamoDB state locking
- Lambda function deployment
- Best practices and production patterns

**AWS Services:** Lambda, S3 (state), DynamoDB, CloudWatch
📁 Location: `module-3-advanced/`

## 🚀 Quick Start

1. **Complete AWS Setup**
   ```bash
   # Follow AWS_SETUP.md first!
   # Verify AWS credentials
   aws sts get-caller-identity
   ```

2. **Navigate to tutorial directory**
   ```bash
   cd terraform-recap
   ```

3. **Start with Module 1**
   ```bash
   cd module-1-basics
   cat README.md
   ```

## 📚 Learning Path

Each module contains:
- `README.md` - Theory and instructions
- `exercises/` - Hands-on challenges
- `solutions/` - Reference implementations
- `project/` - Main project files

## 🎓 Learning Objectives

By the end of this tutorial, you will:
- ✅ Understand Infrastructure as Code principles
- ✅ Write Terraform configurations for AWS
- ✅ Manage state with S3 and DynamoDB
- ✅ Create reusable, modular infrastructure code
- ✅ Implement multi-environment deployments
- ✅ Deploy serverless applications with Lambda
- ✅ Apply Terraform best practices
- ✅ Debug and troubleshoot Terraform issues

## 💰 Cost Management

### Free Tier Services Used

All examples stay within AWS Free Tier limits:

- **S3**: <5GB storage, minimal requests
- **EC2**: t2.micro instances, <750 hours/month
- **Lambda**: <1M requests/month
- **DynamoDB**: <25GB storage
- **VPC, IAM, CloudWatch**: Always free

### Cost Safety Measures

> [!CAUTION]
> **To avoid charges:**
> - ✅ Set up billing alerts BEFORE starting
> - ✅ Run `terraform destroy` after EACH module
> - ✅ Verify resource deletion in AWS Console
> - ✅ Don't leave instances running overnight
> - ✅ Check billing dashboard daily

**See [CLEANUP.md](file:///C:/Users/Takow%20Carvin/Documents/terraform-recap/CLEANUP.md) for detailed cleanup instructions.**

## 🆘 Troubleshooting

### AWS Credentials Issues
```bash
# Verify credentials
aws sts get-caller-identity

# Reconfigure if needed
aws configure
```

### Terraform Provider Errors
```bash
# Reinitialize
rm -rf .terraform
terraform init
```

### Region Issues
```bash
# Verify region
aws configure get region

# Should be: us-east-1 (or your chosen region)
```

### Unexpected Costs
1. Run `terraform destroy` immediately
2. Check AWS Billing Dashboard
3. Review [CLEANUP.md](file:///C:/Users/Takow%20Carvin/Documents/terraform-recap/CLEANUP.md)
4. Contact AWS Support (free for billing issues)

## 📖 Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Free Tier](https://aws.amazon.com/free/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [HashiCorp Learn](https://learn.hashicorp.com/terraform)

## 🎯 Next Steps After Tutorial

1. **Explore More AWS Services**: RDS, ECS, EKS
2. **Learn Terraform Cloud**: Team collaboration features
3. **Study CI/CD Integration**: Automate deployments
4. **Practice Advanced Patterns**: Multi-region, disaster recovery
5. **Join the Community**: HashiCorp forums, AWS communities

## ⚠️ Important Reminders

- 🔒 **Never commit AWS credentials to Git**
- 💰 **Always destroy resources after learning**
- 📊 **Monitor billing dashboard regularly**
- 🧹 **Follow cleanup procedures carefully**
- 🔐 **Use IAM users, not root account**

---

**Ready to start?** 

1. Complete [AWS_SETUP.md](file:///C:/Users/Takow%20Carvin/Documents/terraform-recap/AWS_SETUP.md)
2. Head to `module-1-basics/` and begin your Terraform journey! 🚀
