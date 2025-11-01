output "repository_url" {
  description = "ECRイメージのURI"
  value       = aws_ecr_repository.app.repository_url
}
