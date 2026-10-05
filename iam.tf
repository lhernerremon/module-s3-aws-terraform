resource "aws_iam_policy" "api_bucket_full_access" {
  name   = "${local.project}-S3-POLICY"
  policy = data.aws_iam_policy_document.api_resources_bucket_full_access.json

  tags = {
    Name        = "${local.project}-S3-POLICY"
    project     = var.project_name
    environment = var.project_environment
  }
}

resource "aws_iam_group" "api_group" {
  name = "${local.project}-S3-GROUP"
}

resource "aws_iam_group_policy_attachment" "api_group_api_bucket_full_access" {
  group      = aws_iam_group.api_group.name
  policy_arn = aws_iam_policy.api_bucket_full_access.arn
}

resource "aws_iam_user" "api_user" {
  name = "${local.project}-S3-USER"

  tags = {
    Name        = "${local.project}-S3-USER"
    project     = var.project_name
    environment = var.project_environment
  }
}

resource "aws_iam_access_key" "api_user_access_key" {
  user = aws_iam_user.api_user.name
}

resource "aws_iam_user_group_membership" "api_user_groups" {
  groups = [aws_iam_group.api_group.name]
  user   = aws_iam_user.api_user.name
}
