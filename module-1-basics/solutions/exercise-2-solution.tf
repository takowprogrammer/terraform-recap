# Solution: Exercise 2 - Use Variables and Count

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

variable "filenames" {
  description = "List of filenames to create"
  type        = list(string)
  default     = ["alpha.txt", "beta.txt", "gamma.txt", "delta.txt"]
}

resource "local_file" "dynamic_files" {
  count    = length(var.filenames)
  filename = "${path.module}/output/${var.filenames[count.index]}"
  content  = "This is ${var.filenames[count.index]}\nCreated at index: ${count.index}"
}

output "created_files" {
  description = "List of all created files"
  value       = local_file.dynamic_files[*].filename
}
