output "container_id" {
  description = "ID of the created container"
  value       = docker_container.app.id
}

output "container_name" {
  description = "Name of the created container"
  value       = docker_container.app.name
}

output "container_ip" {
  description = "IP address of the container"
  value       = docker_container.app.network_data[0].ip_address
}

output "external_port" {
  description = "External port mapping"
  value       = var.external_port
}

output "url" {
  description = "URL to access the application"
  value       = "http://localhost:${var.external_port}"
}
