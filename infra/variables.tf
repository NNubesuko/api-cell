variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "environment" {
  description = "環境名 (例: develop, staging, production)"
  type        = string
}

variable "aws_region" {
  description = "AWS リージョン"
  type        = string
}

variable "assume_role_arn" {
  description = "Terraform 実行時に引き受ける IAM ロール ARN"
  type        = string
  default     = null
}

variable "github_owner" {
  description = "GitHub の組織またはユーザー名"
  type        = string
}

variable "github_repository" {
  description = "GitHub リポジトリ名"
  type        = string
}

variable "default_tags" {
  description = "AWS リソースへ付与する共通タグ"
  type        = map(string)
}

variable "github_oidc_thumbprint_list" {
  description = "GitHub OIDC プロバイダーで信頼するサムプリント"
  type        = list(string)
  default = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

variable "cors_configuration" {
  description = "API Gateway の CORS 設定"
  type = object({
    allow_origins     = list(string)
    allow_methods     = list(string)
    allow_headers     = list(string)
    max_age           = number
    allow_credentials = bool
  })
  default = {
    allow_origins     = []
    allow_methods     = []
    allow_headers     = []
    max_age           = 600
    allow_credentials = false
  }
}

variable "jwt_configuration" {
  description = "API Gateway の JWT 認証設定"
  type = object({
    issuer   = string
    audience = list(string)
  })
}

variable "environment_variables" {
  description = "Lambda関数の環境変数"
  type        = map(string)
  default     = {}
}
