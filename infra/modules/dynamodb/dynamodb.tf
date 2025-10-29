resource "aws_dynamodb_table" "users" {
  name         = "${var.resource_prefix_dynamodb}-users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
