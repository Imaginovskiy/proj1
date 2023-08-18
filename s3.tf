resource "random_string" "bucket_name" {
  length  = 12
  special = false
  upper   = false
}
resource "random_string" "log_bucket_name" {
  length  = 12
  special = false
  upper   = false
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.log_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "log-delivery-write"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket" "log_bucket" {
    bucket = "${random_string.log_bucket_name.result}"
    acl = "log-delivery-write"
}

resource "aws_s3_bucket" "main_bucket" {
    bucket = "${random_string.bucket_name.result}"
}

resource "aws_s3_bucket_metric" "bucket_metric" {
  bucket = aws_s3_bucket.main_bucket.id
  name   = "EntireBucket"
}

resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.main_bucket.id

  target_bucket = "${aws_s3_bucket.log_bucket.id}"
  target_prefix = "${aws_s3_bucket.main_bucket.id}/"
}