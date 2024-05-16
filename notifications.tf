resource "aws_sns_topic_subscription" "this" {
    topic_arn = aws_sns_topic.this.arn
    protocol = "email"
    endpoint = "vladyslav.lazar.ri.2022@lpnu.ua"
}

resource "aws_sns_topic" "this" {
  name = "${module.label.id}${module.label.delimiter}sns"
}

resource "aws_iam_role" "this" {
  name = "${module.label.id}${module.label.delimiter}sns${module.label.delimiter}role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })

  inline_policy {
    name = "${module.label.id}${module.label.delimiter}sns${module.label.delimiter}policy"
    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sns:Publish",
            "Resource": "${aws_sns_topic.this.arn}"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        }
    ]
    })
  }
}

resource "aws_iam_role" "this_test" {
  name = "${module.label.id}${module.label.delimiter}sns${module.label.delimiter}role${module.label.delimiter}test"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })

  inline_policy {
    name = "${module.label.id}${module.label.delimiter}sns${module.label.delimiter}policy${module.label.delimiter}test"
    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "lambda:InvokeFunction",
            "Resource": "arn:aws:lambda:eu-central-1:992382748106:function:*"
        }
    ]
    })
  }
}

data "archive_file" "this" {
  type        = "zip"
  source_dir  = "./sns_lambda"
  output_path = "../sns_lambda.zip"
}

data "archive_file" "this_test" {
  type        = "zip"
  source_dir  = "./sns_lambda_test"
  output_path = "../sns_lambda_test.zip"
}

resource "aws_lambda_function" "this" {
  filename         = data.archive_file.this.output_path
  function_name    = "${module.label.id}${module.label.delimiter}lambda"
  role             = aws_iam_role.this.arn
  handler          = "lambda_function.lambda_handler"
  depends_on    =  [aws_cloudwatch_log_group.this]
  source_code_hash = data.archive_file.this.output_base64sha256
  runtime          = "python3.9"
}


resource "aws_lambda_function" "this_test" {
  filename         = data.archive_file.this_test.output_path
  function_name    = "${module.label.id}${module.label.delimiter}lambda${module.label.delimiter}test"
  role             = aws_iam_role.this.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.this_test.output_base64sha256
  runtime          = "python3.9"
}


resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromAPIGatewaySNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_lambda_permission" "this_test" {
  statement_id  = "AllowExecutionFromAPIGatewaySNSTest"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this_test.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${aws_lambda_function.this_test.function_name}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_subscription_filter" "this" {
  depends_on      = [aws_lambda_permission.this_filter]
  name            = "Filter"
  log_group_name  = aws_cloudwatch_log_group.this.name
  filter_pattern  = "?ERROR ?WARN ?5xx"
  destination_arn = aws_lambda_function.this.arn
}

resource "aws_lambda_permission" "this_filter" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "logs.eu-central-1.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.this.arn}:*"
  source_account = "992382748106"
}

module "notify_slack" {
  source  = "terraform-aws-modules/notify-slack/aws"
  version = "~> 5.0"
  create_sns_topic = false
  sns_topic_name = aws_sns_topic.this.name

  slack_webhook_url = "https://hooks.slack.com/services/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"
  slack_channel     = "aws-chatbot"
  slack_username    = "reporter"
}

module "billing_alert" {
  source = "billtrust/billing-alarm/aws"
  aws_env = "dev"
  monthly_billing_threshold = 5
  currency = "USD"
}

resource "aws_sns_topic_subscription" "this_billing" {
    topic_arn = "arn:aws:sns:eu-central-1:992382748106:billing-alarm-notification-usd-dev"
    protocol = "email"
    endpoint = "vladyslav.lazar.ri.2022@lpnu.ua"
}