
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Create IAM Users
resource "aws_iam_user" "users" {
  for_each = toset(var.iam_users)

  name = each.value
  path = "/users/"
}

# Create Developer Group
resource "aws_iam_group" "developer_group" {
  name = "Developers"
}

# Create Admin Group
resource "aws_iam_group" "admin_group" {
  name = "Administrators"
}

# Developer S3 Policy
resource "aws_iam_policy" "developer_policy" {
  name        = "DeveloperS3AccessPolicy"
  description = "Allow developers to access a specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::${var.s3_bucket_name}"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::${var.s3_bucket_name}/*"
      }
    ]
  })
}

# Attach Developer Policy to Developer Group
resource "aws_iam_group_policy_attachment" "developer_attachment" {
  group      = aws_iam_group.developer_group.name
  policy_arn = aws_iam_policy.developer_policy.arn
}

# Attach AWS Managed Administrator Policy
resource "aws_iam_group_policy_attachment" "admin_attachment" {
  group      = aws_iam_group.admin_group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Add Developer Users to Developer Group
resource "aws_iam_user_group_membership" "developer_membership" {
  for_each = toset(var.developer_users)

  user = aws_iam_user.users[each.value].name

  groups = [
    aws_iam_group.developer_group.name
  ]
}

# Add Admin Users to Admin Group
resource "aws_iam_user_group_membership" "admin_membership" {
  for_each = toset(var.admin_users)

  user = aws_iam_user.users[each.value].name

  groups = [
    aws_iam_group.admin_group.name
  ]
}
