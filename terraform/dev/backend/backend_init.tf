# S3 bucket for backend
resource "aws_s3_bucket" "tfstate" {
  bucket = "9368b2f3d0-tfstate"
  # lifecycle {
  #   prevent_destroy = true
  # }
}
resource "aws_s3_bucket_acl" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
  # lifecycle {
  #   prevent_destroy = true
  # }
}
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.tfstate.id
  rule {
    object_ownership = "ObjectWriter"
  }
  # lifecycle {
  #   prevent_destroy = true
  # }
}
resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
  # lifecycle {
  #   prevent_destroy = true
  # }
}

# DynamoDB for terraform state lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-lock"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
  # lifecycle {
  #   prevent_destroy = true
  # }
}