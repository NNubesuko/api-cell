output "lambda_execution_role_arn" {
  description = "Lambda実行ロールのARN"
  value       = aws_iam_role.lambda_execution.arn
}

output "github_actions_role_arn" {
  description = "GitHub ActionsロールのARN"
  value       = aws_iam_role.github_actions.arn
}
