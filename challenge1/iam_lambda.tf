resource "aws_iam_role" "challenge1_lambda" {
  name = "challenge1_lambda"
  
  # I got the stuff below from the website and im not sure what it means. 
  
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = // change service "ec2.amazonaws.com"
        }
      },
    ]
  })
