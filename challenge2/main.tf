terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
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
  
resource "aws_lambda_function" "challenge1" {
  filename      = "challenge-01.zip"
  function_name = "Bens-Function"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "challenge-01"

  source_code_hash = filebase64sha256("challenge-01.zip")

  runtime = "go1.x"

  environment {
    variables = {
      Author = "Ben"
    }
  }
}
  
resource "aws_dynamodb_table" "default" {
  count            = local.enabled ? 1 : 0
  name             = module.this.id
  read_capacity    = var.billing_mode == "PAY_PER_REQUEST" ? null : var.autoscale_min_read_capacity
  write_capacity   = var.billing_mode == "PAY_PER_REQUEST" ? null : var.autoscale_min_write_capacity
  hash_key         = var.hash_key
  range_key        = var.range_key
  stream_enabled   = length(var.replicas) > 0 ? true : var.enable_streams
  stream_view_type = length(var.replicas) > 0 || var.enable_streams ? var.stream_view_type : ""
