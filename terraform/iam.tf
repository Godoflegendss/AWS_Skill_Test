resource "aws_iam_role" "app_role" {
    name = "${var.cluster_name}-app-role"
    assume_role_policy = jsonencode({
        version="2012-10-17"
        statement=[{
            Effect="Allow"
            principals={
                Service="ecs-tasks.amazonaws.com"
                action="sts:AssumeRole"
            }
        }]
    })
  
}

resource "aws_iam_policy" "app_policy" {
    name="${var.cluster_name}-app-policy"
    policy = jsonencode({
        version="2012-10-17"
        statement=[{
            Effect="Allow"
            action=[
                "s3:GetObject",
                "s3:PutObject",
                "s3:ListObject"
            ]
        }]
        resource=[
            aws_s3_bucket.static.arn,
            "${aws_s3_bucket.static.arn}/*"        ]
    })
  
}

resource "aws_iam_role_policy_attachment" "app_policy_attach" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.app_policy.arn
}