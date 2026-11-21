
output "iam_users" {
  description = "Created IAM users"

  value = [
    for user in aws_iam_user.users : user.name
  ]
}

output "developer_group" {
  value = aws_iam_group.developer_group.name
}

output "admin_group" {
  value = aws_iam_group.admin_group.name
}

output "developer_policy_arn" {
  value = aws_iam_policy.developer_policy.arn
}
