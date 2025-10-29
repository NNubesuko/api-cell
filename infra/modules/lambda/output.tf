output "lambda_function_name" {
  description = "Lambda関数の名前"
  value       = aws_lambda_function.web.function_name
}

output "lambda_function_arn" {
  description = "Lambda関数のARN"
  value       = aws_lambda_function.web.arn
}
