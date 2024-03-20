# module "table_authors" {
#     source = "./modules/dynamodb"
#     table_name = "authors"
# }

# module "table_courses" {
#     source = "./modules/dynamodb"
#     table_name = "courses"
# }

module "lambda" {
  source = "./modules/lambda"
}

module "archive" {
  source = "./modules/archive"
}
