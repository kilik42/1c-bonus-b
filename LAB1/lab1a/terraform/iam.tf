# Trust policy that allows EC2 to assume this role.
# EC2 needs an IAM role so the app can read the DB secret without hardcoding creds.
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    sid     = "AllowEC2ToAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Main IAM role attached to the EC2 app instance.
# This is the identity the app will use when calling AWS APIs.
resource "aws_iam_role" "app_role" {
  name               = "${local.project_name}-app-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-app-role"
  })
}

# App-specific read policy for Secrets Manager.
# Keeping this narrow makes the lab more realistic and avoids overbroad permissions.
data "aws_iam_policy_document" "app_secrets_policy" {
  statement {
    sid    = "ReadDatabaseSecret"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    # The secret resource itself is created in secrets.tf.
    # Using the ARN here keeps access scoped to only this lab's DB secret.
    resources = [aws_secretsmanager_secret.db_secret.arn]
  }
}

# Inline policy attached directly to the EC2 app role.
# This is enough for Lab 1A since the app only needs to read its DB secret.
resource "aws_iam_role_policy" "app_secrets_inline" {
  name   = "${local.project_name}-app-secrets-policy"
  role   = aws_iam_role.app_role.id
  policy = data.aws_iam_policy_document.app_secrets_policy.json
}

# Instance profile so the IAM role can actually be attached to the EC2 instance.
# EC2 does not attach the role directly; it uses the instance profile wrapper.
resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "${local.project_name}-app-instance-profile"
  role = aws_iam_role.app_role.name
}