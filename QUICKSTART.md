# Terraform Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### 1. Prerequisites Check
```bash
# Verify Terraform is installed
terraform version

# Verify Docker is running
docker --version
docker ps
```

### 2. Start with Module 1 (Basics)
```bash
cd module-1-basics/project

# Initialize Terraform
terraform init

# Preview what will be created
terraform plan

# Create the resources
terraform apply

# Check the created files
ls output/

# Clean up
terraform destroy
```

### 3. Try Module 2 (Docker)
```bash
cd ../../module-2-intermediate/project

# Make sure Docker Desktop is running!
terraform init
terraform apply

# Visit http://localhost:8080 in your browser
# You should see the Nginx welcome page

# View running containers
docker ps

# Clean up
terraform destroy
```

### 4. Explore Module 3 (Advanced)
```bash
cd ../../module-3-advanced/project

terraform init

# Create dev workspace
terraform workspace new dev
terraform apply

# Create staging workspace
terraform workspace new staging
terraform apply

# List all workspaces
terraform workspace list

# Switch between workspaces
terraform workspace select dev

# Clean up all workspaces
terraform workspace select dev
terraform destroy
terraform workspace select staging
terraform destroy
terraform workspace select default
terraform workspace delete dev
terraform workspace delete staging
```

## 📚 Learning Path

1. **Module 1 (45 min)** - Start here if you're new to Terraform
   - Basic syntax and concepts
   - Variables and outputs
   - Local file provider

2. **Module 2 (60 min)** - Learn Docker integration
   - Docker provider
   - State management
   - Modules and meta-arguments

3. **Module 3 (45 min)** - Master advanced features
   - Workspaces
   - Provisioners
   - Best practices

## 🔧 Common Commands

```bash
# Initialize working directory
terraform init

# Format code
terraform fmt

# Validate configuration
terraform validate

# Preview changes
terraform plan

# Apply changes
terraform apply

# Apply without confirmation
terraform apply -auto-approve

# Destroy everything
terraform destroy

# Show current state
terraform show

# List resources in state
terraform state list

# Get specific output
terraform output <output_name>

# Get all outputs as JSON
terraform output -json
```

## 🐛 Troubleshooting

### "Error: Failed to install provider"
```bash
# Clear provider cache and reinitialize
rm -rf .terraform
terraform init
```

### "Error: Cannot connect to Docker daemon"
- Start Docker Desktop
- Wait for "Docker Desktop is running" status
- Try again

### "Error: Resource already exists"
```bash
# Import existing resource
terraform import <resource_type>.<name> <id>

# Or remove from state
terraform state rm <resource_type>.<name>
```

### Port already in use
```bash
# Find what's using the port (Windows PowerShell)
netstat -ano | findstr :8080

# Kill the process
taskkill /PID <process_id> /F
```

## 💡 Tips

- Always run `terraform plan` before `apply`
- Use `terraform fmt` to format your code
- Read error messages carefully - they're usually helpful
- Check `terraform.tfstate` to see what Terraform knows about
- Use `-var` flag to override variables: `terraform apply -var="environment=prod"`
- Use `.tfvars` files for environment-specific values

## 🎯 Next Steps After Tutorial

1. **Practice**: Repeat modules with different configurations
2. **Experiment**: Modify the code and see what happens
3. **Cloud Providers**: Try AWS, Azure, or GCP free tiers
4. **Real Projects**: Build something useful
5. **Community**: Join HashiCorp forums and Discord

## 📖 Additional Resources

- [Official Terraform Docs](https://www.terraform.io/docs)
- [Terraform Registry](https://registry.terraform.io/)
- [HashiCorp Learn](https://learn.hashicorp.com/terraform)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

---

**Need help?** Check each module's README for detailed explanations and exercises!
