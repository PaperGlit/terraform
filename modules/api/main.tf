resource "aws_api_gateway_method" "this" {
  rest_api_id = var.rest_id
  resource_id = var.resource_id
  http_method = var.http_method
  authorization = "NONE"
  request_validator_id = var.validator_id
  request_models = var.models
  request_parameters = var.parameters
}

resource "aws_api_gateway_integration" "this" {
  rest_api_id = var.rest_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.this.http_method
  integration_http_method = "POST"
  type = "AWS"
  passthrough_behavior = "WHEN_NO_TEMPLATES"
  uri = var.lambda
  request_templates = var.request_templates
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration_response" "this" {
  rest_api_id = var.rest_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.this.http_method
  status_code = aws_api_gateway_method_response.this.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  response_templates = { "application/json" = "" }
}

resource "aws_api_gateway_method_response" "this" {
  rest_api_id = var.rest_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.this.http_method
  status_code = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}