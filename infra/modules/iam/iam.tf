# Lambda AssumeRole
data "aws_iam_policy_document" "lambda_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# GitHub Actions AssumeRole (OIDC)
data "aws_iam_policy_document" "github_actions_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.iam_role_GitHubActionsRole.federated]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = var.iam_role_GitHubActionsRole.string_equals.variable
      values   = [var.iam_role_GitHubActionsRole.string_equals.value]
    }

    condition {
      test     = "StringLike"
      variable = var.iam_role_GitHubActionsRole.string_like.variable
      values   = [var.iam_role_GitHubActionsRole.string_like.value]
    }
  }
}

# Lambda の DynamoDB アクセスポリシー
data "aws_iam_policy_document" "lambda_dynamodb" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Scan",
      "dynamodb:Query"
    ]

    resources = [
      var.dynamodb_users_table_arn
    ]
  }
}

# GitHub Actions 実行ポリシー (ECR push + Lambda 更新)
data "aws_iam_policy_document" "github_actions_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "lambda:UpdateFunctionCode",
      "lambda:GetFunction"
    ]
    resources = [var.iam_role_policy_GitHubActionsPolicy.resource]
  }
}

# Lambda 実行ロール
resource "aws_iam_role" "lambda_execution" {
  name               = "${var.resource_prefix_iam_role}-execution"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

# Lambda ポリシーアタッチメント
resource "aws_iam_role_policy_attachment" "basic_logs" {
  role       = aws_iam_role.lambda_execution.name
  policy_arn = var.iam_role_AWSLambdaBasicExecutionRole.arn
}

# DynamoDB アクセスポリシー
resource "aws_iam_role_policy" "lambda_dynamodb" {
  name = "${var.resource_prefix_iam_policy}-dynamodb-access"
  role = aws_iam_role.lambda_execution.id

  policy = data.aws_iam_policy_document.lambda_dynamodb.json
}

# GitHub Actions ロール
resource "aws_iam_role" "github_actions" {
  name               = "${var.resource_prefix_iam_role}-github-actions"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume.json
}

# GitHub Actions 権限ポリシー
resource "aws_iam_policy" "github_actions" {
  name   = "${var.resource_prefix_iam_role}-github-actions-policy"
  policy = data.aws_iam_policy_document.github_actions_policy.json
}

# GitHub Actions ポリシーアタッチメント
resource "aws_iam_role_policy_attachment" "github_actions" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions.arn
}
