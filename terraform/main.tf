data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

locals {
  suffixes = {
    api_gateway = "api-gateway"
    dynamodb    = "dynamodb"
    ecr         = "ecr"
    iam_policy  = "iam-policy"
    iam_role    = "iam-role"
    lambda      = "lambda"
  }

  resource_prefixes = {
    for key, suffix in local.suffixes :
    key => "${var.project_name}-${var.environment}-${suffix}"
  }

  iam_openid_github_actions = {
    url             = "https://token.actions.githubusercontent.com"
    thumbprint_list = var.github_oidc_thumbprint_list
  }

  iam_github_actions_role = {
    federated = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
    string_equals = {
      variable = "token.actions.githubusercontent.com:aud"
      value    = "sts.amazonaws.com"
    }
    string_like = {
      variable = "token.actions.githubusercontent.com:sub"
      value    = "repo:${var.github_owner}/${var.github_repository}:environment:${var.environment}"
    }
  }

  iam_role_policy_github_actions = {
    resource = "arn:${data.aws_partition.current.partition}:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${local.resource_prefixes.lambda}"
  }

  iam_role_basic_execution = {
    arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  }
}

module "dynamodb" {
  source = "./modules/dynamodb"

  resource_prefix_dynamodb = local.resource_prefixes.dynamodb
}

module "iam" {
  source = "./modules/iam"

  resource_prefix_iam_role   = local.resource_prefixes.iam_role
  resource_prefix_iam_policy = local.resource_prefixes.iam_policy

  dynamodb_users_table_arn             = module.dynamodb.dynamodb_users_table_arn
  iam_role_AWSLambdaBasicExecutionRole = local.iam_role_basic_execution
  iam_role_GitHubActionsRole           = local.iam_github_actions_role
  iam_role_policy_GitHubActionsPolicy  = local.iam_role_policy_github_actions
  iam_openid_GitHubActions             = local.iam_openid_github_actions
}

module "ecr" {
  source = "./modules/ecr"

  resource_ecr_prefix = local.resource_prefixes.ecr
}

module "lambda" {
  source = "./modules/lambda"

  resource_prefix_lambda    = local.resource_prefixes.lambda
  repository_url            = module.ecr.repository_url
  lambda_execution_role_arn = module.iam.lambda_execution_role_arn
  environment_variables     = var.environment_variables
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  resource_prefix_lambda = local.resource_prefixes.lambda
}

module "api_gateway" {
  source = "./modules/api-gateway"

  resource_prefix_api_gateway = local.resource_prefixes.api_gateway
  lambda_function_name        = module.lambda.lambda_function_name
  lambda_function_arn         = module.lambda.lambda_function_arn
  cors_configuration          = var.cors_configuration
  jwt_configuration           = var.jwt_configuration
}

