resource "aws_ssm_parameter" "foo" {
  name  = "foo"
  type  = "String"
  value = "bar"
}

resource "aws_ssm_parameter" "secret" {
  name        = "/production/database/password/master"
  description = "The parameter description"
  type        = "SecureString"
  value       = var.database_master_password
}

resource "aws_iam_role" "lambda_exec" {
  name = "challenge3_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_lambda_function" "challenge3" {
  filename      = "challenge-03.zip"
  function_name = "Bens-Function"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "challenge-03"

  source_code_hash = filebase64sha256("challenge-03.zip")

  runtime = "go1.x"
}
