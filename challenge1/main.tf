terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lambda_exec" {
  name = "challenge1_lambda"

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

data "archive_file" "lambda_challenge1" {
  type = "zip"

  source_dir  = "${path.module}/challenge1"
  output_path = "${path.module}/challenge1.zip"
}

resource "aws_s3_object" "lambda_challenge1" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "challenge1.zip"
  source = data.archive_file.lambda_challenge1.output_path

  etag = filemd5(data.archive_file.lambda_challenge1.output_path)
}

resource "aws_lambda_function" "challenge1" {
  function_name = "challenge1"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_challenge1.key

  runtime = "nodejs12.x"
  handler = "challenge1.handler"

  source_code_hash = data.archive_file.lambda_challenge1.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}


resource "aws_cloudwatch_log_group" "challenge1" {
  name = "/aws/lambda/${aws_lambda_function.challenge1.function_name}"

  retention_in_days = 30
}
