# Exercise 1: Create Multiple Files
# Create 5 different text files with unique content


terraform {
   required_providers {
     local = {
       source  = "hashicorp/local"
       version = "~> 2.0"
     }
   }
}  


# TODO: Create 5 files with different names and content
# Example structure:
 resource "local_file" "file1" {
   filename = "${path.module}/output/file1.txt"
   content  = "Content for file 1, and this is the begining of the file"
 }

# Your code here:
resource "local_file" "file2" {
   filename = "${path.module}/output/file2.txt"
   content  = "Content for file 2, and this is the begining of the file"
 }

resource "local_file" "file3" {
   filename = "${path.module}/output/file3.txt"
   content  = "Content for file 3, and this is the begining of the file"
 }

resource "local_file" "file4" {
   filename = "${path.module}/output/file4.txt"
   content  = "Content for file 4, and this is the begining of the file"
 }

resource "local_file" "file5" {
   filename = "${path.module}/output/file5.txt"
   content  = "Content for file 5, and this is the begining of the file"
 }
  