# Module 1 Solutions

## 📚 How to Use Solutions

These are reference implementations for the exercises. Use them to:
- ✅ Check your work
- ✅ Learn different approaches
- ✅ Understand best practices

---

## 🚀 Running Solutions

### Run Any Solution

```bash
# Navigate to solutions directory
cd module-1-basics/solutions

# Choose a solution file
# Example: exercise-1-solution.tf

# Initialize
terraform init

# Preview
terraform plan

# Apply
terraform apply

# Clean up
terraform destroy
```

---

## 📝 Solution Files

### Exercise 1 Solution
**File:** `exercise-1-solution.tf`

**What it does:**
- Creates 5 S3 buckets with different purposes
- Demonstrates multiple resource blocks
- Shows proper tagging

**Run it:**
```bash
terraform init
terraform apply -auto-approve
terraform output
terraform destroy -auto-approve
```

---

### Exercise 2 Solution
**File:** `exercise-2-solution.tf`

**What it does:**
- Creates multiple IAM users using count
- Uses list variable
- Demonstrates count.index

**Run it:**
```bash
terraform init
terraform apply
# Check IAM Console
terraform destroy
```

---

## 💡 Learning from Solutions

### Compare Your Code

```bash
# See differences
diff ../exercises/exercise-1.tf exercise-1-solution.tf
```

### Understand the Patterns

Each solution demonstrates:
- ✅ Proper variable usage
- ✅ Resource naming conventions
- ✅ Tagging strategies
- ✅ Output definitions

---

## 🎯 Key Takeaways

From these solutions, you learn:
- How to structure Terraform code
- Best practices for AWS resources
- Effective use of meta-arguments
- Proper cleanup procedures
