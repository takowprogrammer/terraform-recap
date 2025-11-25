# Resource Cleanup Guide

## 🎯 Critical: Avoiding AWS Charges

This guide ensures you properly destroy all AWS resources created during the tutorial to avoid unexpected charges.

## ⚠️ Why Cleanup Matters

- Running EC2 instances cost money after free tier hours
- S3 storage accumulates charges
- Elastic IPs cost money when not attached
- Forgotten resources = unexpected bills

## 🧹 Quick Cleanup (After Each Module)

### Step 1: Terraform Destroy

```bash
# Navigate to the module directory
cd module-X-name/project

# Destroy all resources
terraform destroy

# Review the plan carefully
# Type 'yes' to confirm
```

### Step 2: Verify Destruction

**Check the output:**
```
Destroy complete! Resources: X destroyed.
```

If you see errors, note them and check AWS Console.

## 🔍 Manual Verification in AWS Console

### EC2 Instances

1. Go to: https://console.aws.amazon.com/ec2/
2. Check **all regions** (top right dropdown)
3. Click "Instances" in left sidebar
4. Verify: No instances in "running" or "stopped" state
5. If found: Select → Actions → Instance State → Terminate

### S3 Buckets

1. Go to: https://console.aws.amazon.com/s3/
2. Check for any buckets created during tutorial
3. **Important:** Empty bucket before deleting
   - Click bucket name
   - Select all objects → Delete
   - Confirm deletion
4. Go back → Select bucket → Delete
5. Type bucket name to confirm

### VPC Resources

1. Go to: https://console.aws.amazon.com/vpc/
2. Check each region
3. Look for non-default VPCs
4. Delete in this order:
   - NAT Gateways (if any)
   - Elastic IPs (if any)
   - EC2 instances (if any)
   - Load Balancers (if any)
   - Subnets
   - Route tables (except main)
   - Internet Gateways
   - VPC

### Elastic IPs

1. Go to: https://console.aws.amazon.com/ec2/
2. Click "Elastic IPs" in left sidebar
3. Select any unattached IPs → Actions → Release

### Lambda Functions

1. Go to: https://console.aws.amazon.com/lambda/
2. Check each region
3. Delete any functions created during tutorial

### DynamoDB Tables

1. Go to: https://console.aws.amazon.com/dynamodb/
2. Check "Tables"
3. Delete any tables created for state locking

### IAM Resources (Optional Cleanup)

1. Go to: https://console.aws.amazon.com/iam/
2. Users → Delete `terraform-user` (if done with tutorial)
3. Policies → Delete any custom policies
4. Roles → Delete any custom roles

## 📋 Complete Cleanup Checklist

After finishing the entire tutorial:

- [ ] Run `terraform destroy` in module-1-basics/project
- [ ] Run `terraform destroy` in module-2-intermediate/project
- [ ] Run `terraform destroy` in module-3-advanced/project
- [ ] Check EC2 Dashboard (all regions)
- [ ] Check S3 buckets (empty and delete)
- [ ] Check VPC Dashboard (all regions)
- [ ] Check Elastic IPs (release all)
- [ ] Check Lambda functions (all regions)
- [ ] Check DynamoDB tables
- [ ] Check CloudWatch Logs (optional)
- [ ] Review AWS Billing Dashboard

## 🔄 Region-by-Region Cleanup

AWS resources can exist in different regions. Check these common regions:

```bash
# List all regions
aws ec2 describe-regions --query 'Regions[].RegionName' --output table

# Common regions to check:
# - us-east-1 (N. Virginia)
# - us-east-2 (Ohio)
# - us-west-1 (N. California)
# - us-west-2 (Oregon)
# - eu-west-1 (Ireland)
```

## 🛠️ Cleanup Scripts

### PowerShell (Windows)

```powershell
# List all EC2 instances across regions
$regions = aws ec2 describe-regions --query 'Regions[].RegionName' --output text
foreach ($region in $regions.Split()) {
    Write-Host "Checking region: $region"
    aws ec2 describe-instances --region $region --query 'Reservations[].Instances[].InstanceId' --output text
}
```

### Bash (Mac/Linux)

```bash
#!/bin/bash
# List all EC2 instances across regions
for region in $(aws ec2 describe-regions --query 'Regions[].RegionName' --output text); do
    echo "Checking region: $region"
    aws ec2 describe-instances --region $region --query 'Reservations[].Instances[].InstanceId' --output text
done
```

## 💰 Verify Zero Charges

### Check Billing Dashboard

1. Go to: https://console.aws.amazon.com/billing/
2. Click "Bills" in left sidebar
3. Check current month charges
4. Should show $0.00 (or minimal charges)

### Use Cost Explorer

1. Go to: https://console.aws.amazon.com/cost-management/
2. Click "Cost Explorer"
3. Enable if not already enabled
4. View costs by service
5. Identify any unexpected charges

## 🚨 What If I See Charges?

### Small Charges (<$1)

- Likely verification charge (refunded)
- Data transfer (minimal)
- CloudWatch logs (minimal)
- Not a concern

### Moderate Charges ($1-$10)

- Check for running EC2 instances
- Check for unattached Elastic IPs
- Check S3 storage
- Destroy resources immediately

### Large Charges (>$10)

- **Stop all resources immediately**
- Contact AWS Support (billing support is free)
- Review Cost Explorer for culprit service
- Check for compromised credentials

## 🔐 Security: Delete Access Keys

If you're completely done with the tutorial:

```bash
# List access keys
aws iam list-access-keys --user-name terraform-user

# Delete access key
aws iam delete-access-key --user-name terraform-user --access-key-id AKIAXXXXXXXXXXXXXXXX

# Delete IAM user
aws iam delete-user --user-name terraform-user
```

Or via AWS Console:
1. IAM → Users → terraform-user
2. Security credentials → Access keys → Delete
3. Delete user

## 📊 Terraform State Cleanup

### Local State Files

```bash
# Remove state files (after destroying resources)
rm terraform.tfstate
rm terraform.tfstate.backup
rm -rf .terraform/
```

### Remote State (S3)

```bash
# Empty and delete state bucket
aws s3 rm s3://your-terraform-state-bucket --recursive
aws s3 rb s3://your-terraform-state-bucket

# Delete DynamoDB lock table
aws dynamodb delete-table --table-name terraform-state-lock
```

## ✅ Final Verification

Run this command to check for common resources:

```bash
# Check EC2 instances
aws ec2 describe-instances --query 'Reservations[].Instances[?State.Name!=`terminated`].[InstanceId,State.Name]' --output table

# Check S3 buckets
aws s3 ls

# Check running costs
aws ce get-cost-and-usage --time-period Start=2025-11-01,End=2025-11-30 --granularity MONTHLY --metrics BlendedCost
```

## 🆘 Troubleshooting Cleanup

### "Resource has dependent objects"

Delete dependencies first:
1. Security group → Delete instances first
2. VPC → Delete subnets, route tables, IGW first
3. S3 bucket → Empty bucket first

### "Access Denied" during deletion

- Verify IAM permissions
- Some resources require specific permissions to delete
- Use root account as last resort

### Terraform destroy fails

```bash
# Force remove from state (use carefully!)
terraform state rm <resource_name>

# Then manually delete in AWS Console
```

### Can't find resources

- Check all regions
- Check different AWS accounts (if you have multiple)
- Use AWS Resource Groups & Tag Editor

## 📞 Need Help?

- **AWS Billing Support**: Available on free tier
  - Phone: Check AWS Console for number
  - Chat: Available in AWS Console
- **AWS Forums**: https://forums.aws.amazon.com/
- **AWS Documentation**: https://docs.aws.amazon.com/

## 🎓 Best Practices for Future

1. **Always tag resources** with project name
2. **Set up billing alerts** before creating resources
3. **Use `terraform plan`** before `apply`
4. **Run `terraform destroy`** immediately after learning
5. **Check AWS Console** after destroy
6. **Review billing** weekly during learning

---

**Remember:** The best way to avoid charges is to destroy resources immediately after each learning session! 🧹
