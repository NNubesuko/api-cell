output "dynamodb_users_table_arn" {
  description = "users テーブルのARN"
  value       = aws_dynamodb_table.users.arn
}
