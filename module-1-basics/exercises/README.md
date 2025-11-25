# Module 1 Exercises - How to Run

## 📚 Overview

This directory contains practice exercises to reinforce Module 1 concepts.

---

## 🚀 How to Run Exercises

### General Steps for All Exercises

1. **Navigate to exercises directory**
   ```bash
   cd module-1-basics/exercises
   ```

2. **Choose an exercise file**
   ```bash
   # Example: exercise-1.tf
   ```

3. **Initialize Terraform**
   ```bash
   terraform init
   ```

4. **Complete the TODO sections**
   - Open the exercise file in your editor
   - Read the instructions
   - Write the required Terraform code

5. **Test your solution**
   ```bash
   terraform plan
   terraform apply
   ```

6. **Clean up**
   ```bash
   terraform destroy
   ```

7. **Compare with solution**
   ```bash
   # Check ../solutions/ directory
   ```

---

## 📝 Exercise 1: Create Multiple Files

**File:** `exercise-1.tf`

**Goal:** Create 5 different S3 buckets with different purposes

**Steps:**
```bash
# 1. Open exercise-1.tf
# 2. Add code to create 5 S3 buckets
# 3. Test
terraform init
terraform plan
terraform apply

# 4. Verify in AWS Console
# 5. Clean up
terraform destroy
```

**Hint:** Use multiple `aws_s3_bucket` resources with different names

---

## 📝 Exercise 2: Use Variables and Count

**File:** `exercise-2.tf`

**Goal:** Create multiple IAM users using count

**Steps:**
```bash
# 1. Open exercise-2.tf
# 2. Create a variable with list of usernames
# 3. Use count to create multiple users
# 4. Test
terraform init
terraform plan
terraform apply

# 5. Check IAM Console
# 6. Clean up
terraform destroy
```

**Hint:** 
```hcl
variable "usernames" {
  default = ["user1", "user2", "user3"]
}

resource "aws_iam_user" "users" {
  count = length(var.usernames)
  name  = var.usernames[count.index]
}
```

---

## 📝 Exercise 3: Template Files

**Goal:** Create a JSON configuration file using variables

**Steps:**
```bash
# 1. Create a new file: exercise-3.tf
# 2. Define variables for project info
# 3. Create S3 object with JSON content
# 4. Test
terraform init
terraform apply
terraform destroy
```

**Hint:** Use `jsonencode()` function

---

## 📝 Exercise 4: Data Sources

**Goal:** Use data sources to fetch AWS account information

**Steps:**
```bash
# 1. Create exercise-4.tf
# 2. Add data sources:
#    - aws_caller_identity
#    - aws_region
# 3. Output the information
# 4. Test
terraform init
terraform apply
```

**Hint:**
```hcl
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

---

## ✅ Checking Your Work

### Method 1: Compare with Solutions
```bash
# View solution
cat ../solutions/exercise-1-solution.tf

# Compare with your code
diff exercise-1.tf ../solutions/exercise-1-solution.tf
```

### Method 2: Verify in AWS Console
- Check S3 buckets created
- Check IAM users created
- Verify tags and configurations

### Method 3: Check Outputs
```bash
terraform output
# Should show all expected values
```

---

## 💡 Tips

- ✅ Start with `terraform plan` to preview
- ✅ Read error messages carefully
- ✅ Use `terraform fmt` to format code
- ✅ Always `terraform destroy` when done
- ✅ Check solutions if stuck

---

## 🆘 Common Issues

**Error: "Resource already exists"**
```bash
terraform destroy
terraform apply
```

**Error: "Invalid syntax"**
```bash
terraform validate
# Read the error message
```

**Stuck on an exercise?**
```bash
# Check the solution
cat ../solutions/exercise-X-solution.tf
```

---

## 🎯 Learning Objectives

After completing these exercises, you should be able to:
- ✅ Create multiple AWS resources
- ✅ Use variables effectively
- ✅ Work with count meta-argument
- ✅ Use data sources
- ✅ Generate dynamic content
- ✅ Apply proper tagging
