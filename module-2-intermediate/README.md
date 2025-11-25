# Module 2: Intermediate Concepts with AWS (60 minutes)

## 🎯 Learning Objectives

- Understand AWS VPC networking concepts
- Deploy EC2 instances in custom VPCs
- Configure security groups and network ACLs
- Create reusable Terraform modules
- Use count and for_each effectively
- Manage resource dependencies

## 📖 Theory (10 minutes)

### AWS VPC (Virtual Private Cloud)

A VPC is your own isolated network in AWS where you can launch resources.

**Key Components:**
- **VPC**: The network container (e.g., 10.0.0.0/16)
- **Subnets**: Subdivisions of your VPC (public and private)
- **Internet Gateway**: Allows internet access
- **Route Tables**: Direct network traffic
- **Security Groups**: Virtual firewalls for instances
- **NACLs**: Network Access Control Lists (subnet-level firewalls)

### EC2 (Elastic Compute Cloud)

Virtual servers in the cloud.

**Free Tier:**
- 750 hours/month of t2.micro or t3.micro instances
- Enough for 1 instance running 24/7 or multiple instances part-time

### Terraform State

The **state file** (`terraform.tfstate`) is Terraform's database:
- Tracks resource mappings
- Stores resource metadata
- Enables change detection

**Important:**
- ⚠️ Never edit state files manually
- 🔒 State can contain sensitive data
- 🔄 Use remote state for teams (Module 3)

### Meta-Arguments

- `count`: Create multiple similar resources
- `for_each`: Create resources from a map or set
- `depends_on`: Explicit dependencies
- `lifecycle`: Control resource behavior

## 🛠️ Hands-On Project: VPC and EC2 Web Server

We'll deploy a complete web application infrastructure:
- Custom VPC with public and private subnets
- Internet Gateway and route tables
- Security groups
- EC2 instance running a web server

### Prerequisites

> [!IMPORTANT]
> - AWS credentials configured
> - Completed Module 1
> - Destroyed Module 1 resources

Verify:
```bash
aws sts get-caller-identity
aws ec2 describe-vpcs --region us-east-1
```

### Step 1: VPC and Networking

Create `main.tf`:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-vpc"
  })
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-igw"
  })
}

# Create public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-public-subnet"
    Type = "Public"
  })
}

# Create route table for public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-public-rt"
  })
}

# Associate route table with public subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Data source: Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}
```

### Step 2: Security Groups

Add to `main.tf`:

```hcl
# Security group for web server
resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP from anywhere
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH from your IP (optional, for debugging)
  ingress {
    description = "SSH from anywhere (for learning only)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # In production, restrict this!
  }

  # Allow all outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-web-sg"
  })
}
```

### Step 3: EC2 Instance

Add to `main.tf`:

```hcl
# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create EC2 instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = file("${path.module}/user-data.sh")

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-web-server"
  })
}
```

### Step 4: User Data Script

Create `user-data.sh`:

```bash
#!/bin/bash
# Update system
yum update -y

# Install Apache web server
yum install -y httpd

# Create a simple web page
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Terraform EC2 Demo</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container {
            background: rgba(255, 255, 255, 0.1);
            padding: 30px;
            border-radius: 10px;
            backdrop-filter: blur(10px);
        }
        h1 { margin-top: 0; }
        .info { background: rgba(0,0,0,0.2); padding: 15px; border-radius: 5px; margin: 10px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Terraform EC2 Web Server</h1>
        <p>This web server was deployed using Terraform!</p>
        <div class="info">
            <strong>Instance ID:</strong> $(ec2-metadata --instance-id | cut -d " " -f 2)<br>
            <strong>Instance Type:</strong> $(ec2-metadata --instance-type | cut -d " " -f 2)<br>
            <strong>Availability Zone:</strong> $(ec2-metadata --availability-zone | cut -d " " -f 2)<br>
            <strong>Public IP:</strong> $(ec2-metadata --public-ipv4 | cut -d " " -f 2)
        </div>
        <p>✅ Infrastructure as Code works!</p>
    </div>
</body>
</html>
EOF

# Start Apache and enable on boot
systemctl start httpd
systemctl enable httpd
```

### Step 5: Using Count for Multiple Instances

Add to `main.tf`:

```hcl
# Create multiple web servers using count
resource "aws_instance" "web_cluster" {
  count = var.instance_count

  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = templatefile("${path.module}/user-data-template.sh", {
    server_number = count.index + 1
  })

  tags = merge(var.common_tags, {
    Name   = "${var.project_name}-web-${count.index + 1}"
    Number = count.index + 1
  })
}
```

## 💪 Exercises

### Exercise 1: Add Private Subnet (Medium)
Create a private subnet with:
- CIDR: 10.0.2.0/24
- No internet access
- Separate route table

### Exercise 2: Multi-AZ Deployment (Medium)
Deploy subnets in multiple availability zones for high availability.

**Hint:** Use `count` with `data.aws_availability_zones`

### Exercise 3: Application Load Balancer (Advanced)
Add an ALB to distribute traffic across multiple EC2 instances.

**Note:** ALB costs money - review pricing first!

### Exercise 4: Create VPC Module (Advanced)
Extract VPC configuration into a reusable module in `modules/vpc/`.

## 📝 Key Takeaways

- VPCs provide network isolation in AWS
- Security groups are stateful firewalls
- User data scripts run on instance launch
- `count` creates multiple similar resources
- Always use data sources for AMIs (they change)
- **Free tier: 750 hours/month of t2.micro**

## 🧹 Cleanup

**Critical:** Destroy resources to avoid charges:

```bash
terraform destroy
```

Verify in AWS Console:
- EC2 instances terminated
- VPC deleted (or only default VPC remains)
- Security groups deleted
- No Elastic IPs allocated

See [CLEANUP.md](file:///C:/Users/Takow%20Carvin/Documents/terraform-recap/CLEANUP.md) for details.

## 🎓 Quiz Yourself

1. What's the difference between a security group and a NACL?
2. Why do we need an Internet Gateway?
3. What's the purpose of user data scripts?
4. When would you use `count` vs `for_each`?
5. Why should we use data sources for AMIs?

## ⏭️ Next Steps

Once you've completed exercises and cleaned up:

1. ✅ Run `terraform destroy`
2. ✅ Verify all resources deleted
3. ✅ Check AWS Billing Dashboard
4. ✅ Move to **Module 3** for Lambda and remote state

---

**Time Check:** Module 2 should take about 60 minutes. Ready for advanced topics? 🚀
