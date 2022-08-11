resource "aws_iam_policy" "allow-secret-manager-read-access" {
  name        = "Roboshop-${var.COMPONENT}-Secretmanager-readaccess-${var.ENV}"
  path        = "/"
  description = "Roboshop-${var.COMPONENT}-Secretmanager-readaccess-${var.ENV}"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ],
        "Resource": "arn:aws:secretsmanager:us-east-1:041583668323:secret:roboshop/all-mAn3kY"
      },
      {
        "Sid": "VisualEditor1",
        "Effect": "Allow",
        "Action": [
          "secretsmanager:GetRandomPassword",
          "secretsmanager:ListSecrets"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role" "allow-secret-manager-read-access" {
  name = "Roboshop-${var.COMPONENT}-Secretmanager-readaccess-${var.ENV}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "Roboshop-${var.COMPONENT}-Secretmanager-readaccess-${var.ENV}"
  }
}

resource "aws_iam_role_policy_attachment" "attach-policy" {
  role       = aws_iam_role.allow-secret-manager-read-access.name
  policy_arn = aws_iam_policy.allow-secret-manager-read-access.arn
}

resource "aws_iam_instance_profile" "allow-secretmanager-readaccess" {
  name = "Roboshop-${var.COMPONENT}-Secretmanager-readaccess-${var.ENV}"
  role = aws_iam_role.allow-secret-manager-read-access.name
}