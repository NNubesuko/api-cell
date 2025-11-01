variable "resource_prefix_api_gateway" {
  description = "API Gatewayのリソース接頭辞"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda関数の名前"
  type        = string
}

variable "lambda_function_arn" {
  description = "Lambda関数の ARN"
  type        = string
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
