module "table_authors" {
    source = "./modules/dynamodb"
    table_name = "authors"
    context = module.label.context
}

module "table_courses" {
    source = "./modules/dynamodb"
    table_name = "courses"
    context = module.label.context
}

module "authors_read_role" {
  source = "./modules/iam"
  rule_name = "authors_read_role"
  policy_name =  "authors_read"
  policy_action = "dynamodb:Scan"
  arn = "arn:aws:dynamodb:eu-central-1:992382748106:table/authors"
}

module "courses_put_role" {
  source = "./modules/iam"
  rule_name = "courses_put_role"
  policy_name = "courses_put"
  policy_action = "dynamodb:PutItem"
  arn = "arn:aws:dynamodb:eu-central-1:992382748106:table/courses"
}

module "courses_read_role" {
    source = "./modules/iam"
    rule_name = "courses_read_role"
    policy_name = "courses_read"
    policy_action = "dynamodb:Scan"
    arn = "arn:aws:dynamodb:eu-central-1:992382748106:table/courses"
  }

module "courses_read_one_role" {
  source = "./modules/iam"
  rule_name = "courses_read_one_role"
  policy_name = "courses_read_one"
  policy_action = "dynamodb:GetItem"
  arn = "arn:aws:dynamodb:eu-central-1:992382748106:table/courses"
}

module "courses_delete_role" {
  source = "./modules/iam"
  rule_name = "courses_delete_rule"
  policy_name = "courses_delete"
  policy_action = "dynamodb:DeleteItem"
  arn = "arn:aws:dynamodb:eu-central-1:992382748106:table/courses"
}

data "archive_file" "authors_read_zip" {
  type        = "zip"
  source_dir  = "./authors_read"
  output_path = "../authors_read.zip"
}

module "authors_read_lambda" {
  source = "./modules/lambda"
  function = "authors_read_lambda"
  zip_name = data.archive_file.authors_read_zip.output_path
  zip_hash = data.archive_file.authors_read_zip.output_base64sha256
  role = module.authors_read_role.role_arn
  statement = "AllowExecutionFromAPIGatewayReadAuthors"
}

data "archive_file" "courses_put_zip" {
  type        = "zip"
  source_dir  = "./courses_put"
  output_path = "../courses_put.zip"
}

module "courses_put_lambda" {
  source = "./modules/lambda"
  function = "courses_put_lambda"
  zip_name = data.archive_file.courses_put_zip.output_path
  zip_hash = data.archive_file.courses_put_zip.output_base64sha256
  role = module.courses_put_role.role_arn
  statement = "AllowExecutionFromAPIGatewayPutCourses"
}

data "archive_file" "courses_update_zip" {
  type        = "zip"
  source_dir  = "./courses_update"
  output_path = "../courses_update.zip"
}

module "courses_update_lambda" {
  source = "./modules/lambda"
  function = "courses_update_lambda"
  zip_name = data.archive_file.courses_update_zip.output_path
  zip_hash = data.archive_file.courses_update_zip.output_base64sha256
  role = module.courses_put_role.role_arn
  statement = "AllowExecutionFromAPIGatewayUpdateCourses"
}

data "archive_file" "courses_read_zip" {
  type        = "zip"
  source_dir  = "./courses_read"
  output_path = "../courses_read.zip"
}

module "courses_read_lambda" {
  source = "./modules/lambda"
  function = "courses_read_lambda"
  zip_name = data.archive_file.courses_read_zip.output_path
  zip_hash = data.archive_file.courses_read_zip.output_base64sha256
  role = module.courses_read_role.role_arn
  statement = "AllowExecutionFromAPIGatewayReadCourses"
}

data "archive_file" "courses_read_one_zip" {
  type        = "zip"
  source_dir  = "./courses_read_one"
  output_path = "../courses_read_one.zip"
}

module "courses_read_one_lambda" {
  source = "./modules/lambda"
  function = "courses_read_one_lambda"
  zip_name = data.archive_file.courses_read_one_zip.output_path
  zip_hash = data.archive_file.courses_read_one_zip.output_base64sha256
  role = module.courses_read_one_role.role_arn
  statement = "AllowExecutionFromAPIGatewayReadOneCourses"
}

data "archive_file" "courses_delete_zip" {
  type        = "zip"
  source_dir  = "./courses_delete"
  output_path = "../courses_delete.zip"
}

module "courses_delete_lambda" {
  source = "./modules/lambda"
  function = "courses_delete_lambda"
  zip_name = data.archive_file.courses_delete_zip.output_path
  zip_hash = data.archive_file.courses_delete_zip.output_base64sha256
  role = module.courses_delete_role.role_arn
  statement = "AllowExecutionFromAPIGatewayDeleteCourses"
}
