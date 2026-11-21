
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "iam_users" {
  description = "List of IAM users"
  type        = list(string)
}

variable "developer_users" {
  description = "Developer IAM users"
  type        = list(string)
}

variable "admin_users" {
  description = "Administrator IAM users"
  type        = list(string)
}

variable "s3_bucket_name" {
  description = "S3 bucket name for developer access"
  type        = string
}
