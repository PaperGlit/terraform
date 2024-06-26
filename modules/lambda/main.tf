module "label" {
    source = "cloudposse/label/null"
    version = "0.25.0"
    environment = var.environment
    namespace = var.namespace
    stage = var.stage
    delimiter = "_"
    label_order = var.label_order
}

resource "aws_lambda_function" "this_function" {
  filename         = var.zip_name
  function_name    = var.function
  role             = var.role
  handler          = "index.handler"
  source_code_hash = var.zip_hash
  runtime          = "nodejs16.x"
}

resource "aws_lambda_permission" "this_api" {
  statement_id  = var.statement
  action        = "lambda:InvokeFunction"
  function_name = var.function
  principal     = "apigateway.amazonaws.com"
}
