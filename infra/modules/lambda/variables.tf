variable "resource_prefix_lambda" {
  description = "Lambdaリソースの接頭辞"
  type        = string
}

variable "repository_url" {
  description = "ECRのリポジトリURL"
  type        = string
}

variable "lambda_execution_role_arn" {
  description = "Lambda実行ロールのARN"
  type        = string
}

variable "environment_variables" {
  description = "Lambda関数の環境変数"
  type        = map(string)
  default     = {}
}
