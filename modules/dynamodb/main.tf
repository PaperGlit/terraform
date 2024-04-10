module "label" {
    source = "cloudposse/label/null"
    version = "0.25.0"
    environment = var.environment
    namespace = var.namespace
    stage = var.stage
    delimiter = "_"
    label_order = var.label_order
}

resource "aws_dynamodb_table" "this" {
    name = "${module.label.id}${module.label.delimiter}${var.table_name}"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "id"

    attribute {
      name = "id"
      type = "S"
    }
}