// from https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
resource "aws_iam_role" "iam_challenge1_lambda" {
  name = "iam_challenge1_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "challenge1_lambda" {
  filename      = "challenge1.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.iam_challenge1_lambda.arn
  handler       = "index.test"

//  # The filebase64sha256() function is available in Terraform 0.11.12 and later
//  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
//  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "nodejs12.x"

  environment {
    variables = {
//      foo = "bar"
    }
  }
}
