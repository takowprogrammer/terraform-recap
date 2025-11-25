# Solution: Exercise 1 - Create Multiple Files

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

resource "local_file" "file1" {
  filename = "${path.module}/output/users.txt"
  content  = "John Doe\nJane Smith\nBob Johnson"
}

resource "local_file" "file2" {
  filename = "${path.module}/output/config.ini"
  content  = <<-EOT
    [database]
    host=localhost
    port=5432
  EOT
}

resource "local_file" "file3" {
  filename = "${path.module}/output/notes.md"
  content  = "# My Notes\n\nThis is a markdown file created by Terraform."
}

resource "local_file" "file4" {
  filename = "${path.module}/output/data.json"
  content = jsonencode({
    name    = "Example"
    version = "1.0"
    active  = true
  })
}

resource "local_file" "file5" {
  filename = "${path.module}/output/script.sh"
  content  = "#!/bin/bash\necho 'Hello from Terraform!'"
}
