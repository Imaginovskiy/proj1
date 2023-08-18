data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  region = "${data.aws_region.current.name}"
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_sns_topic" "topic" {
  name = "test-sns-topic"

  policy = <<POLICY
  {
      "Version":"2012-10-17",
      "Statement":[{
          "Effect": "Allow",
          "Principal": {"Service":"s3.amazonaws.com"},
          "Action": "SNS:Publish",
          "Resource":  "arn:aws:sns:${local.region}:${local.account_id}:test-sns-topic",
          "Condition":{
              "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.main_bucket.arn}"}
          }
      }]
  }
  POLICY
}

resource "aws_s3_bucket_notification" "s3_notif" {
  bucket = "${aws_s3_bucket.main_bucket.id}"

  topic {
    topic_arn = "${aws_sns_topic.topic.arn}"

    events = [
      "s3:ObjectCreated:*",
    ]

  }
}