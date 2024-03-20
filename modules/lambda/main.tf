module "iam" {
  source = "../iam"
}

data "archive_file" "authors_read_zip" {
  type        = "zip"
  source_dir  = "./authors_read" # Directory containing your lambda function code
  output_path = "../authors_read.zip"
}

resource "aws_lambda_function" "authors_read_lambda" {
  filename         = data.archive_file.authors_read_zip.output_path
  function_name    = "authors_read_lambda"
  role             = module.iam.authors_read_arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.authors_read_zip.output_base64sha256
  runtime          = "nodejs16.x"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_authors_read" {
  statement_id  = "AllowExecutionFromAPIGatewayReadAuthors"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.authors_read_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

data "archive_file" "courses_put_zip" {
  type        = "zip"
  source_dir  = "./courses_put" # Directory containing your lambda function code for putting item in DynamoDB
  output_path = "../courses_put.zip"
}

resource "aws_lambda_function" "courese_put_lambda" {
  filename         = data.archive_file.courses_put_zip.output_path
  function_name    = "courses_put_lambda"
  role             = module.iam.courses_put_arn  # Use the same IAM role as before or define a new one as per your requirements
  handler          = "index.handler"
  source_code_hash = data.archive_file.courses_put_zip.output_base64sha256
  runtime          = "nodejs16.x"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_courses_put" {
  statement_id  = "AllowExecutionFromAPIGatewayPutCourses"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.courese_put_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

data "archive_file" "courses_update_zip" {
  type        = "zip"
  source_dir  = "./courses_update" # Directory containing your lambda function code for putting item in DynamoDB
  output_path = "../courses_update.zip"
}

resource "aws_lambda_function" "courses_update_lambda" {
  filename         = data.archive_file.courses_update_zip.output_path
  function_name    = "courses_update_lambda"
  role             = module.iam.courses_put_arn  # Use the same IAM role as before or define a new one as per your requirements
  handler          = "index.handler"
  source_code_hash = data.archive_file.courses_update_zip.output_base64sha256
  runtime          = "nodejs16.x"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_courses_update" {
  statement_id  = "AllowExecutionFromAPIGatewayUpdateCourses"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.courses_update_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

data "archive_file" "courses_read_zip" {
  type        = "zip"
  source_dir  = "./courses_read" # Directory containing your lambda function code for putting item in DynamoDB
  output_path = "../courses_read.zip"
}

resource "aws_lambda_function" "courses_read" {
  filename         = data.archive_file.courses_read_zip.output_path
  function_name    = "courses_read_lambda"
  role             = module.iam.courses_read_arn  # Use the same IAM role as before or define a new one as per your requirements
  handler          = "index.handler"
  source_code_hash = data.archive_file.courses_read_zip.output_base64sha256
  runtime          = "nodejs16.x"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_courses_read" {
  statement_id  = "AllowExecutionFromAPIGatewayReadCourses"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.courses_read.function_name
  principal     = "apigateway.amazonaws.com"
}

data "archive_file" "courses_read_one_zip" {
  type        = "zip"
  source_dir  = "./courses_read_one" # Directory containing your lambda function code for putting item in DynamoDB
  output_path = "../courses_read_one.zip"
}

resource "aws_lambda_function" "courses_read_one" {
  filename         = data.archive_file.courses_read_one_zip.output_path
  function_name    = "courses_read_one_lambda"
  role             = module.iam.courses_read_one_arn  # Use the same IAM role as before or define a new one as per your requirements
  handler          = "index.handler"
  source_code_hash = data.archive_file.courses_read_one_zip.output_base64sha256
  runtime          = "nodejs16.x"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_courses_read_one" {
  statement_id  = "AllowExecutionFromAPIGatewayReadOneCourses"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.courses_read_one.function_name
  principal     = "apigateway.amazonaws.com"
}

data "archive_file" "courses_delete_zip" {
  type        = "zip"
  source_dir  = "./courses_delete" # Directory containing your lambda function code for putting item in DynamoDB
  output_path = "../courses_delete.zip"
}

resource "aws_lambda_function" "courses_delete" {
  filename         = data.archive_file.courses_delete_zip.output_path
  function_name    = "courses_delete_lambda"
  role             = module.iam.courses_delete_arn  # Use the same IAM role as before or define a new one as per your requirements
  handler          = "index.handler"
  source_code_hash = data.archive_file.courses_delete_zip.output_base64sha256
  runtime          = "nodejs16.x"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_courses_delete" {
  statement_id  = "AllowExecutionFromAPIGatewayDeleteCourses"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.courses_delete.function_name
  principal     = "apigateway.amazonaws.com"
}
