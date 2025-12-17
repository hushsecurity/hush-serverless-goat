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
  secret_string = "actual-secure-value-12345"
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

# The Lambda Function
resource "aws_lambda_function" "lambda" {
  filename      = "build/lambda.zip"
  function_name = "hush_goat_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  environment {
    variables = {
      SECRET_NAME = aws_secretsmanager_secret.secret.name
    }
  }
}
