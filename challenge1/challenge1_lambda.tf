resource "aws_lambda_function" "challenge1" {
// ^^ That's the only part I'm confident about ^^
//  s3_bucket = // output bucket "my_bucket" // This is causing an error in terraform init
//  s3_key    = // should this be a variable? "challenge1.zip"
  function_name    = "challenge1"
//  handler          = // i dont really understand what a handler is "module.handler" // this is causing an error in terraform init
  runtime          = "python3.6"
  timeout          = 180
}
