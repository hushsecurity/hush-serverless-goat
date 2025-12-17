provider "aws" {
  region = "us-east-1"
}

# AWS Secret Manager Resource
resource "aws_secretsmanager_secret" "secret" {
  name        = "hush/goat/secret"
  description = "Securely stored secret for hush goat demo"
}

resource "aws_secretsmanager_secret_version" "secret_val" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = "pat-na1-ffbb9f50-d96b-4abc-84f1-b986617be1b6"
}

# IAM Role for Lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "hush_goat_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Permission to read the Secret
resource "aws_iam_role_policy" "lambda_secret_policy" {
  role = aws_iam_role.iam_for_lambda.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = "secretsmanager:GetSecretValue"
      Effect   = "Allow"
      Resource = aws_secretsmanager_secret.secret.arn
    }]
  })
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/hush_goat_lambda"
  retention_in_days = 3
}

resource "aws_iam_role_policy" "lambda_logs_policy" {
  role = aws_iam_role.iam_for_lambda.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Effect   = "Allow"
      Resource = "${aws_cloudwatch_log_group.lambda_log_group.arn}:*"
    }]
  })
}

# The Lambda Function
resource "aws_lambda_function" "lambda" {
  filename         = "build/lambda.zip"
  function_name    = "hush_goat_lambda"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("build/lambda.zip")

  depends_on = [aws_cloudwatch_log_group.lambda_log_group]

  lifecycle {
    ignore_changes = [environment, layers]
  }
}
