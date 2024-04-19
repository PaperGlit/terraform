variable "rest_id" {
  type = string
}

variable "resource_id" {
    type = string
}

variable "http_method" {
    type = string
}

variable "validator_id" {
    type = string
}

variable "models" {
    type = map(string)
}

variable "lambda" {
    type = string
}

variable "request_templates" {
    type = map(string)
}

variable "parameters" {
    type = map(string)
}