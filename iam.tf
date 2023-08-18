resource "aws_iam_policy" "cloudwatch_dashboard_policy" {
  name        = "CloudWatchDashboardPolicy"
  description = "IAM policy to allow viewing CloudWatch Dashboards"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "cloudwatch:ListDashboards",
          "cloudwatch:GetDashboard",
          "cloudwatch:GetDashboardEmbedUrl"
        ],
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_user" "test_user" {
    name = "dashboardViewer"
}

resource "aws_iam_user_policy_attachment" "cloudwatch_dashboard_attachment" {
  user       = aws_iam_user.test_user.name
  policy_arn = aws_iam_policy.cloudwatch_dashboard_policy.arn
}