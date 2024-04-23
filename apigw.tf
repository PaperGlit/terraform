#Courses
resource "aws_api_gateway_resource" "courses" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "courses"
}

#Courses-OPTIONS
module "courses_options" {
  source = "./modules/api/options"
  rest_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
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

module "courses_post" {
  source = "./modules/api"
  rest_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = "POST"
  lambda = module.courses_put_lambda.lambda_invoke_arn
  models = { "application/json" = aws_api_gateway_model.courses_post.name }
  validator_id = aws_api_gateway_request_validator.this.id
  request_templates = { "application/json" = "" }
  parameters = null
}

#Courses-GET
module "courses_get" {
  source = "./modules/api"
  rest_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = "GET"
  lambda = module.courses_read_lambda.lambda_invoke_arn
  models = null
  validator_id = null
  request_templates = { "application/json" = "" }
  parameters = null
}

#Courses/{id}
resource "aws_api_gateway_resource" "courses_id" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.courses.id
  path_part   = "{id}"
}

#Courses/{id}-OPTIONS
module "courses_id_options" {
  source = "./modules/api/options"
  rest_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses_id.id
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

module "courses_id_get" {
  source = "./modules/api"
  rest_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses_id.id
  http_method = "GET"
  lambda = module.courses_read_one_lambda.lambda_invoke_arn
  models = { "application/json" = aws_api_gateway_model.courses_id_get.name }
  validator_id = null
  request_templates = {
    "application/json" = <<EOF
  {
    "id": "$input.params('id')"
  }
  EOF
  }
  parameters = { "method.request.path.id" = true }
}

#Courses/{id}-DELETE
module "courses_id_delete" {
  source = "./modules/api"
  rest_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses_id.id
  http_method = "DELETE"
  lambda = module.courses_delete_lambda.lambda_invoke_arn
  models = { "application/json" = aws_api_gateway_model.courses_id_get.name }
  validator_id = null
  request_templates = {
    "application/json" = <<EOF
  {
    "id": "$input.params('id')"
  }
  EOF
  }
  parameters = { "method.request.path.id" = true }
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

module "courses_id_put" {
  source = "./modules/api"
  rest_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses_id.id
  http_method = "PUT"
  lambda = module.courses_update_lambda.lambda_invoke_arn
  models = { "application/json" = aws_api_gateway_model.courses_id_put.name }
  validator_id = null
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
  parameters = { "method.request.path.id" = true }
}

#Authors
resource "aws_api_gateway_resource" "authors" {
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "authors"
  rest_api_id = aws_api_gateway_rest_api.this.id
}

#Authors-OPTIONS
module "authors_options" {
  source = "./modules/api/options"
  rest_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.authors.id
}
#Authors-GET
module "authors_get" {
  source = "./modules/api"
  rest_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = "GET"
  lambda = module.authors_read_lambda.lambda_invoke_arn
  models = null
  validator_id = null
  request_templates = { "application/json" = "" }
  parameters = null
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
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "dev"
}