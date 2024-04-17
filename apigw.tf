#Courses
resource "aws_api_gateway_resource" "courses" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "courses"
}

#Courses-OPTIONS
resource "aws_api_gateway_method" "courses_options" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "courses_options" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.courses_options.http_method
  type = "MOCK"
  request_templates       = {
    "application/json" = <<EOF
    {"statusCode": 200}
  EOF
  }
  depends_on = [aws_api_gateway_method.courses_options]
}

resource "aws_api_gateway_integration_response" "courses_options" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.courses.id
  http_method     = aws_api_gateway_method.courses_options.http_method
  status_code     = aws_api_gateway_method_response.courses_options_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.courses_options_200]
}

resource "aws_api_gateway_method_response" "courses_options_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.courses_options.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.courses_options]
}

#Courses-POST
resource "aws_api_gateway_model" "courses_post" {
  rest_api_id  = aws_api_gateway_rest_api.this.id
  name         = replace("API-PostCourse", "-", "")
  description  = "a JSON schema"
  content_type = "application/json"
  schema = <<EOF
{
  "$schema": "http://json-schema.org/schema#",
  "title": "CourseInputModel",
  "type": "object",
  "properties": {
    "title": {"type": "string"},
    "authorId": {"type": "string"},
    "length": {"type": "string"},
    "category": {"type": "string"}
  },
  "required": ["title", "authorId", "length", "category"]
}
EOF
}

resource "aws_api_gateway_method" "courses_post" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = "POST"
  authorization = "NONE"
  request_validator_id = aws_api_gateway_request_validator.this.id
  request_models = { "application/json" = aws_api_gateway_model.courses_post.name }
}

resource "aws_api_gateway_integration" "courses_post" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = aws_api_gateway_method.courses_post.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.courses_put_lambda.lambda_invoke_arn
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration_response" "courses_post" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.courses_post.http_method
  status_code = aws_api_gateway_method_response.courses_post.status_code
  response_parameters ={
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  response_templates = { "application/json" = "" }
}

resource "aws_api_gateway_method_response" "courses_post" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.courses.id
  http_method     = aws_api_gateway_method.courses_post.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

#Courses-GET
resource "aws_api_gateway_method" "courses_get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.courses.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_integration" "courses_get" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = aws_api_gateway_method.courses_get.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.courses_read_lambda.lambda_invoke_arn
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration_response" "courses_get" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.courses_get.http_method
  status_code = aws_api_gateway_method_response.courses_get.status_code
  response_parameters ={
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  response_templates = { "application/json" = "" }
}

resource "aws_api_gateway_method_response" "courses_get" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.courses.id
  http_method     = aws_api_gateway_method.courses_get.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

#Courses/{id}
resource "aws_api_gateway_resource" "courses_id" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.courses.id
  path_part   = "{id}"
}

#Courses/{id}-OPTIONS
resource "aws_api_gateway_method" "courses_id_options" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses_id.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "courses_id_options" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses_id.id
  http_method = aws_api_gateway_method.courses_id_options.http_method
  type = "MOCK"
  request_templates       = {
    "application/json" = <<EOF
    {"statusCode": 200}
  EOF
  }
  depends_on = [aws_api_gateway_method.courses_id_options]
}

resource "aws_api_gateway_integration_response" "courses_id_options" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.courses_id.id
  http_method     = aws_api_gateway_method.courses_id_options.http_method
  status_code     = aws_api_gateway_method_response.courses_id_options_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.courses_id_options_200]
}

resource "aws_api_gateway_method_response" "courses_id_options_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses_id.id
  http_method = aws_api_gateway_method.courses_id_options.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  depends_on = [aws_api_gateway_method.courses_id_options]
}

#Courses/{id}-GET
resource "aws_api_gateway_model" "courses_id_get" {
  rest_api_id  = aws_api_gateway_rest_api.this.id
  name         = replace("API-GetDeleteCourse", "-", "")
  description  = "a JSON schema"
  content_type = "application/json"
  schema = <<EOF
{
  "$schema": "http://json-schema.org/schema#",
  "title": "CourseInputModel",
  "type": "object",
  "properties": {
    "id": {"type": "string"}
  },
  "required": ["id"]
}
EOF
}

resource "aws_api_gateway_method" "courses_id_get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.courses_id.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  request_models = { "application/json" = aws_api_gateway_model.courses_id_get.name }
  request_parameters = {"method.request.path.id" = true}
}

resource "aws_api_gateway_integration" "courses_id_get" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses_id.id
  http_method             = aws_api_gateway_method.courses_id_get.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.courses_read_one_lambda.lambda_invoke_arn
  passthrough_behavior = "WHEN_NO_TEMPLATES"
  request_templates       = {
    "application/json" = <<EOF
  {
    "id": "$input.params('id')"
  }
  EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration_response" "courses_id_get" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses_id.id
  http_method = aws_api_gateway_method.courses_id_get.http_method
  status_code = aws_api_gateway_method_response.courses_id_get.status_code
  response_parameters ={
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  response_templates = { "application/json" = "" }
}

resource "aws_api_gateway_method_response" "courses_id_get" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.courses_id.id
  http_method     = aws_api_gateway_method.courses_id_get.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

#Courses/{id}-DELETE
resource "aws_api_gateway_method" "courses_id_delete" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses_id.id
  http_method   = "DELETE"
  authorization = "NONE"
  request_models = { "application/json" = aws_api_gateway_model.courses_id_get.name }
  request_parameters = {"method.request.path.id" = true}
}

resource "aws_api_gateway_integration" "courses_id_delete" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses_id.id
  http_method             = aws_api_gateway_method.courses_id_delete.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.courses_delete_lambda.lambda_invoke_arn
  passthrough_behavior = "WHEN_NO_TEMPLATES"
  request_templates = {
  "application/json" = <<EOF
  {
    "id": "$input.params('id')"
  }
  EOF
}
}

resource "aws_api_gateway_integration_response" "courses_id_delete" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses_id.id
  http_method = aws_api_gateway_method.courses_id_delete.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  response_templates = { "application/json" = "" }
}

resource "aws_api_gateway_method_response" "courses_id_delete" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.courses_id.id
  http_method     = aws_api_gateway_method.courses_id_delete.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

#Courses/{id}-PUT
resource "aws_api_gateway_model" "courses_id_put" {
  rest_api_id  = aws_api_gateway_rest_api.this.id
  name         = replace("API-PutCourse", "-", "")
  description  = "a JSON schema"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "http://json-schema.org/schema#",
  "title": "CourseInputModel",
  "type": "object",
  "properties": {
    "id": {"type": "string"},
    "title": {"type": "string"},
    "authorId": {"type": "string"},
    "length": {"type": "string"},
    "category": {"type": "string"},
    "watchHref": {"type": "string"}
  },
  "required": ["id", "title", "authorId", "length", "category", "watchHref"]
}
EOF
}

resource "aws_api_gateway_method" "courses_id_put" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses_id.id
  http_method   = "PUT"
  authorization = "NONE"
  request_parameters = {"method.request.path.id" = true}
  request_models = { "application/json" = aws_api_gateway_model.courses_id_put.name }
}

resource "aws_api_gateway_integration" "courses_id_put" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses_id.id
  http_method             = aws_api_gateway_method.courses_id_put.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.courses_update_lambda.lambda_invoke_arn
  passthrough_behavior = "WHEN_NO_TEMPLATES"
  request_templates = {
  "application/json" = <<EOF
{
  "id": "$input.params('id')",
  "title" : $input.json('$.title'),
  "authorId" : $input.json('$.authorId'),
  "length" : $input.json('$.length'),
  "category" : $input.json('$.category'),
  "watchHref" : $input.json('$.watchHref')
}
  EOF
}
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration_response" "courses_id_put" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses_id.id
  http_method = aws_api_gateway_method.courses_id_put.http_method
  status_code = "200"
  response_parameters ={
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  response_templates = { "application/json" = "" }
}


resource "aws_api_gateway_method_response" "courses_id_put" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.courses_id.id
  http_method     = aws_api_gateway_method.courses_id_put.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

#Authors
resource "aws_api_gateway_resource" "authors" {
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "authors"
  rest_api_id = aws_api_gateway_rest_api.this.id
}

#Authors-OPTIONS
resource "aws_api_gateway_method" "authors_options" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.authors.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "authors_options" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = aws_api_gateway_method.authors_options.http_method
  type = "MOCK"
  request_templates       = {
    "application/json" = <<EOF
    {"statusCode": 200}
  EOF
  }
  depends_on = [aws_api_gateway_method.authors_options]
}

resource "aws_api_gateway_integration_response" "authors_options" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.authors.id
  http_method     = aws_api_gateway_method.authors_options.http_method
  status_code     = aws_api_gateway_method_response.authors_options_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.authors_options_200]
}

resource "aws_api_gateway_method_response" "authors_options_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = aws_api_gateway_method.authors_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [aws_api_gateway_method.authors_options]
}

#Authors-GET
resource "aws_api_gateway_method" "authors_get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.authors.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_integration" "authors_get" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.authors.id
  http_method             = aws_api_gateway_method.authors_get.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.authors_read_lambda.lambda_invoke_arn
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_integration_response" "authors_get" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = aws_api_gateway_method.authors_get.http_method
  status_code = aws_api_gateway_method_response.authors_get.status_code
  response_parameters ={
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  response_templates = { "application/json" = "" }
}

resource "aws_api_gateway_method_response" "authors_get" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.authors.id
  http_method     = aws_api_gateway_method.authors_get.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

#OTHERS
resource "aws_api_gateway_rest_api" "this" {
  name = "${module.label.id}${module.label.delimiter}api"
  description = "API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_request_validator" "this" {
  name                        = "validate_request_body"
  rest_api_id                 = aws_api_gateway_rest_api.this.id
  validate_request_body       = true
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "dev"
}