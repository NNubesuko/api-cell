project_name      = "<PROJECT_NAME>"
environment       = "staging"
aws_region        = "ap-northeast-1"
github_owner      = "<GITHUB_OWNER>"
github_repository = "<REPOSITORY_NAME>"

cors_configuration = {
  allow_origins     = ["<ORIGIN_URL>"]
  allow_methods     = ["<METHOD>"]
  allow_headers     = ["<HEADER>"]
  max_age           = 600
  allow_credentials = false
}

jwt_configuration = {
  issuer   = "<ISSUER_URL>"
  audience = ["<AUDIENCE_VALUE>"]
}

default_tags = {
  Project     = "<PROJECT_NAME>"
  Environment = "staging"
  IaC         = "terraform"
}

environment_variables = {
}
