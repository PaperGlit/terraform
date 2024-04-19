module "label" {
    source = "cloudposse/label/null"
    version = "0.25.0"
    environment = var.environment
    namespace = var.namespace
    stage = var.stage
    delimiter = "_"
    label_order = var.label_order
}

resource "aws_api_gateway_method" "this_options" {
  rest_api_id   = var.rest_id
  resource_id   = var.resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "this_options" {
  rest_api_id = var.rest_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.this_options.http_method
  type = "MOCK"
  request_templates       = {
    "application/json" = <<EOF
    {"statusCode": 200}
  EOF
  }
  depends_on = [aws_api_gateway_method.this_options]
}

resource "aws_api_gateway_integration_response" "this_options" {
  rest_api_id     = var.rest_id
  resource_id     = var.resource_id
  http_method     = aws_api_gateway_method.this_options.http_method
  status_code     = aws_api_gateway_method_response.this_options.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.this_options]
}

resource "aws_api_gateway_method_response" "this_options" {
  rest_api_id = var.rest_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.this_options.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.this_options]
}