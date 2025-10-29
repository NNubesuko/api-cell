resource "aws_apigatewayv2_api" "api" {
  name          = var.resource_prefix_api_gateway
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins     = var.cors_configuration.allow_origins
    allow_headers     = var.cors_configuration.allow_headers
    allow_methods     = var.cors_configuration.allow_methods
    max_age           = var.cors_configuration.max_age
    allow_credentials = var.cors_configuration.allow_credentials
  }
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.lambda_function_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_authorizer" "jwt" {
  api_id           = aws_apigatewayv2_api.api.id
  name             = "auth"
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    issuer   = var.jwt_configuration.issuer
    audience = var.jwt_configuration.audience
  }
}

resource "aws_apigatewayv2_route" "get_proxy" {
  api_id             = aws_apigatewayv2_api.api.id
  route_key          = "GET /{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.lambda.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt.id
}

resource "aws_apigatewayv2_route" "post_proxy" {
  api_id             = aws_apigatewayv2_api.api.id
  route_key          = "POST /{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.lambda.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt.id
}

resource "aws_apigatewayv2_route" "put_proxy" {
  api_id             = aws_apigatewayv2_api.api.id
  route_key          = "PUT /{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.lambda.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt.id
}

resource "aws_apigatewayv2_route" "delete_proxy" {
  api_id             = aws_apigatewayv2_api.api.id
  route_key          = "DELETE /{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.lambda.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt.id
}

# ===== 認証なし：OPTIONS（CORS用） =====
resource "aws_apigatewayv2_route" "options_proxy" {
  api_id             = aws_apigatewayv2_api.api.id
  route_key          = "OPTIONS /{proxy+}"
  authorization_type = "NONE" # 統合(target)は付けない
}

# ===== ルート "/" 用（必要） =====
resource "aws_apigatewayv2_route" "get_root" {
  api_id             = aws_apigatewayv2_api.api.id
  route_key          = "GET /"
  target             = "integrations/${aws_apigatewayv2_integration.lambda.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt.id
}

resource "aws_apigatewayv2_route" "options_root" {
  api_id             = aws_apigatewayv2_api.api.id
  route_key          = "OPTIONS /"
  authorization_type = "NONE"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}
