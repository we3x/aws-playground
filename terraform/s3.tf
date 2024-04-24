resource "aws_s3_bucket" "sysblink-bucket" {
  bucket = var.s3_bucket
} 

resource "aws_s3_bucket_ownership_controls" "public-bucket" {
  bucket = aws_s3_bucket.sysblink-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public-bucket" {
  bucket = aws_s3_bucket.sysblink-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket-public-acl" {
  depends_on = [
    aws_s3_bucket_public_access_block.public-bucket,
    aws_s3_bucket_ownership_controls.public-bucket
  ]

  bucket = aws_s3_bucket.sysblink-bucket.id
  acl    = "public-read"
}