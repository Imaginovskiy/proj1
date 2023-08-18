resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3BucketPolicy"
  description = "IAM policy for read and write access to an S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        Resource = [
          "${aws_s3_bucket.main_bucket.arn}",
          "${aws_s3_bucket.main_bucket.arn}/*"
        ],
      },
    ],
  })
}