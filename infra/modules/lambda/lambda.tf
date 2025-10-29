resource "aws_lambda_function" "web" {
  function_name = var.resource_prefix_lambda

  package_type = "Image"
  image_uri    = "${var.repository_url}:dummy"
  role         = var.lambda_execution_role_arn

  architectures = ["x86_64"]
  memory_size   = 256
  timeout       = 30

  environment {
    variables = var.environment_variables
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}
