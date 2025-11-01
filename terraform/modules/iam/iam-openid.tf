# GitHub Actions OIDC プロバイダー
resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = var.iam_openid_GitHubActions.url
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = var.iam_openid_GitHubActions.thumbprint_list
}
