# Backend configuration for remote state
# IMPORTANT: Uncomment and configure AFTER creating backend infrastructure

 terraform {
   backend "s3" {
     bucket         = "terraform-state-093218045933"  # Replace with your bucket name
     key            = "module-3/terraform.tfstate"
    region         = "us-east-1"
     dynamodb_table = "terraform-state-locks"
     encrypt        = true
   }
 }

# To use this backend:
# 1. Create backend infrastructure first (see backend-setup/)
# 2. Replace YOUR-ACCOUNT-ID with your AWS account ID
# 3. Uncomment the above block
# 4. Run: terraform init -migrate-state
