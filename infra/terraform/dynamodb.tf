resource "aws_dynamodb_table" "default" {
  attribute {
    name = "LockID"
    type = "S"
  }

  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  name         = "wbotelhos-com-terraform-locks"
}
