# Module 2 Project - Quick Start

## 🚀 How to Run This Project

### Step 1: Verify Prerequisites

```bash
# Check AWS credentials
aws sts get-caller-identity

# Ensure Module 1 resources are destroyed
cd ../module-1-basics/project
terraform destroy
cd ../../module-2-intermediate/project
```

### Step 2: Initialize Terraform

```bash
# Initialize (downloads AWS provider)
terraform init
```

### Step 3: Preview Infrastructure

```bash
# See what will be created
terraform plan

# You'll see:
# - VPC and subnet
# - Internet Gateway
# - Route table
# - Security group
# - EC2 instance
```

### Step 4: Deploy Infrastructure

```bash
# Create all resources
terraform apply

# Type 'yes' when prompted
# This takes 2-3 minutes
```

### Step 5: Get Web Server URL

```bash
# Get the public IP
terraform output web_server_url

# Example output: http://54.123.45.67
```

### Step 6: Visit Your Web Server! 🌐

```bash
# Copy the URL from output and paste in browser
# You should see a beautiful web page with:
# - Instance information
# - Public IP
# - Availability zone
```

### Step 7: Optional - Deploy Cluster

```bash
# Enable multiple instances
terraform apply -var="enable_cluster=true" -var="instance_count=2"

# Get all URLs
terraform output cluster_urls
```

### Step 8: Clean Up (IMPORTANT!)

```bash
# Destroy all resources
terraform destroy

# Type 'yes' when prompted
```

### Step 9: Verify Cleanup

Check AWS Console:
- EC2 instances terminated
- VPC deleted (or only default VPC remains)
- Security groups deleted
- No Elastic IPs allocated

---

## 📝 What Gets Created

### Networking
- **VPC**: 10.0.0.0/16
- **Public Subnet**: 10.0.1.0/24
- **Internet Gateway**: For internet access
- **Route Table**: Routes traffic to IGW

### Security
- **Security Group**: Allows HTTP (80) and SSH (22)

### Compute
- **EC2 Instance**: t2.micro with Apache web server
- **User Data**: Installs and configures Apache
- **Public IP**: Automatically assigned

---

## 💡 Useful Commands

```bash
# Get specific outputs
terraform output vpc_id
terraform output web_server_public_ip
terraform output security_group_id

# Check EC2 instance status
aws ec2 describe-instances --region us-east-1 --query 'Reservations[].Instances[].[InstanceId,State.Name,PublicIpAddress]' --output table

# SSH into instance (if needed)
# First, you'd need to add a key pair - not covered in basic tutorial
```

---

## 🌐 Testing Your Web Server

### Method 1: Browser
```
Visit: http://<public-ip>
```

### Method 2: curl
```bash
curl http://$(terraform output -raw web_server_public_ip)
```

### Method 3: Health Check
```bash
curl http://$(terraform output -raw web_server_public_ip)/health.html
```

---

## ⚠️ Important Notes

- ✅ EC2 instance takes 2-3 minutes to fully boot
- ✅ Web server starts automatically via user data
- ✅ Free tier: 750 hours/month of t2.micro
- ✅ Don't leave instances running overnight!
- ✅ Always destroy when done learning

---

## 🎨 Customization

### Change Instance Type
```bash
terraform apply -var="instance_type=t3.micro"
```

### Change VPC CIDR
Edit `variables.tf`:
```hcl
variable "vpc_cidr" {
  default = "10.1.0.0/16"  # Change this
}
```

### Deploy to Different Region
```bash
terraform apply -var="aws_region=us-west-2"
```

---

## 🆘 Troubleshooting

**Web server not responding?**
```bash
# Wait 2-3 minutes for user data to complete
# Check instance state
aws ec2 describe-instance-status --instance-ids $(terraform output -raw web_server_id)
```

**Can't access on port 80?**
```bash
# Check security group
terraform output security_group_id
# Verify in AWS Console that port 80 is open
```

**Want to see user data logs?**
```bash
# SSH into instance and check:
# sudo cat /var/log/cloud-init-output.log
```

---

## 📊 Cost Monitoring

```bash
# Check current month costs
aws ce get-cost-and-usage \
  --time-period Start=2025-11-01,End=2025-11-30 \
  --granularity MONTHLY \
  --metrics BlendedCost
```
