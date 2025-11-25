variable "image_name" {
  description = "Docker image to use"
  type        = string
}

variable "container_name" {
  description = "Name for the container"
  type        = string
}

variable "internal_port" {
  description = "Internal container port"
  type        = number
}

variable "external_port" {
  description = "External host port"
  type        = number
}

variable "network_name" {
  description = "Docker network to attach to (optional)"
  type        = string
  default     = ""
}

variable "environment_vars" {
  description = "Environment variables for the container"
  type        = list(string)
  default     = []
}

variable "command" {
  description = "Command to run in the container"
  type        = list(string)
  default     = []
}
