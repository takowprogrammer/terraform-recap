output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "security_group_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web.id
}

output "web_server_id" {
  description = "ID of the web server instance"
  value       = aws_instance.web.id
}

output "web_server_public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web.public_ip
}

output "web_server_public_dns" {
  description = "Public DNS of the web server"
  value       = aws_instance.web.public_dns
}

output "web_server_url" {
  description = "URL to access the web server"
  value       = "http://${aws_instance.web.public_ip}"
}

output "cluster_instance_ids" {
  description = "IDs of cluster instances"
  value       = aws_instance.web_cluster[*].id
}

output "cluster_public_ips" {
  description = "Public IPs of cluster instances"
  value       = aws_instance.web_cluster[*].public_ip
}

output "cluster_urls" {
  description = "URLs to access cluster instances"
  value       = [for instance in aws_instance.web_cluster : "http://${instance.public_ip}"]
}

output "aws_console_urls" {
  description = "URLs to view resources in AWS Console"
  value = {
    vpc              = "https://console.aws.amazon.com/vpc/home?region=${var.aws_region}#vpcs:VpcId=${aws_vpc.main.id}"
    ec2_instances    = "https://console.aws.amazon.com/ec2/home?region=${var.aws_region}#Instances:"
    security_groups  = "https://console.aws.amazon.com/ec2/home?region=${var.aws_region}#SecurityGroups:group-id=${aws_security_group.web.id}"
  }
}

output "deployment_summary" {
  description = "Summary of deployed infrastructure"
  value = {
    project      = var.project_name
    region       = var.aws_region
    vpc_cidr     = var.vpc_cidr
    instance_type = var.instance_type
    resources = {
      vpc            = aws_vpc.main.id
      subnet         = aws_subnet.public.id
      web_server     = aws_instance.web.id
      web_server_ip  = aws_instance.web.public_ip
      cluster_count  = length(aws_instance.web_cluster)
    }
  }
}
