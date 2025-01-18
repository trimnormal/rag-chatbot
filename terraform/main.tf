provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "zc-portfolio-app-tf-state"
    key    = "portfolio-app.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.59"
    }
  }

  required_version = "~> 1.9.2"
}

# resource "aws_s3_bucket" "tf-state" {
#   bucket = "zc-portfolio-app-tf-state"
# }

# resource "aws_s3_bucket_public_access_block" "this" {
#   bucket                  = aws_s3_bucket.tf-state.id
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
#   bucket = aws_s3_bucket.tf-state.id
#   rule {
#     bucket_key_enabled = false
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }


# resource "aws_s3_bucket_ownership_controls" "this" {
#   bucket = aws_s3_bucket.tf-state.id
#   rule {
#     object_ownership = "BucketOwnerEnforced"
#   }
# }

# resource "aws_dynamodb_table" "this" {
#   name           = "zc-portfolio-app-tf-lock"
#   read_capacity  = 1
#   write_capacity = 1
#   hash_key       = "LockID"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }