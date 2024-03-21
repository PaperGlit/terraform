module "label" {
    source = "cloudposse/label/null"
    version = "0.25.0"
    environment = var.environment
    namespace = var.namespace
    stage = var.stage
    delimiter = "-"
    label_order = var.label_order
}

resource "aws_dynamodb_table" "this" {
    name = var.table_name
    read_capacity = 20
    write_capacity = 20
    hash_key = "id"

    attribute {
      name = "id"
      type = "S"
    }
}