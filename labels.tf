module "label" {
    source = "cloudposse/label/null"
    version = "0.25.0"
    environment = var.environment
    namespace = var.namespace
    stage = var.stage
    delimiter = "_"
    label_order = var.label_order
}