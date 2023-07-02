resource "aws_s3_bucket" "default" {
  bucket = "wbotelhos.com"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.default.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.default.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "default" {
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = aws_s3_bucket.default.id
  ignore_public_acls      = true
  restrict_public_buckets = true
}
