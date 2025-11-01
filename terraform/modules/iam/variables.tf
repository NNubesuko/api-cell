variable "resource_prefix_iam_role" {
  description = "IAM Roleリソースの接頭辞"
  type        = string
}

variable "resource_prefix_iam_policy" {
  description = "IAM Policyリソースの接頭辞"
  type        = string
}

variable "dynamodb_users_table_arn" {
  description = "DynamoDB users テーブルのARN"
  type        = string
}

variable "iam_role_AWSLambdaBasicExecutionRole" {
  description = "AWSLambdaBasicExecutionRoleのARN"
  type = object({
    arn = string
  })
}

variable "iam_role_GitHubActionsRole" {
  description = "GitHub ActionsのOIDCと条件情報"
  type = object({
    federated     = string
    string_equals = map(string)
    string_like   = map(string)
  })
}

variable "iam_role_policy_GitHubActionsPolicy" {
  description = "GitHub Actionsのポリシー情報"
  type = object({
    resource = string
  })
}

variable "iam_openid_GitHubActions" {
  description = "GitHubのOIDCプロバイダー情報"
  type = object({
    url             = string
    thumbprint_list = list(string)
  })
}
