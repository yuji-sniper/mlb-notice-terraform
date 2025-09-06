# 接続
resource "aws_cloudwatch_event_connection" "this" {
  name               = var.name
  authorization_type = "API_KEY"

  auth_parameters {
    api_key {
      key   = "x-api-key"
      value = "PleaseChange!!"
    }
  }

  lifecycle {
    ignore_changes = [
      auth_parameters
    ]
  }
}

# APIの送信先
resource "aws_cloudwatch_event_api_destination" "this" {
  name                             = var.name
  invocation_endpoint              = var.api_endpoint
  http_method                      = var.api_method
  invocation_rate_limit_per_second = var.api_invocation_rate_limit_per_second
  connection_arn                   = aws_cloudwatch_event_connection.this.arn
}

# ルール
resource "aws_cloudwatch_event_rule" "this" {
  name                = var.name
  schedule_expression = var.schedule_expression
}

# ターゲット
data "aws_iam_policy_document" "event_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "event_invoke" {
  name               = "${var.name}-event"
  assume_role_policy = data.aws_iam_policy_document.event_assume_role.json
}

data "aws_iam_policy_document" "event_invoke_policy" {
  statement {
    effect    = "Allow"
    actions   = ["events:InvokeApiDestination"]
    resources = [aws_cloudwatch_event_api_destination.this.arn]
  }
}

resource "aws_iam_policy" "event_invoke" {
  name   = "${var.name}-event"
  policy = data.aws_iam_policy_document.event_invoke_policy.json
}

resource "aws_iam_role_policy_attachment" "event_invoke" {
  role       = aws_iam_role.event_invoke.name
  policy_arn = aws_iam_policy.event_invoke.arn
}

resource "aws_cloudwatch_event_target" "this" {
  rule     = aws_cloudwatch_event_rule.this.name
  arn      = aws_cloudwatch_event_api_destination.this.arn
  role_arn = aws_iam_role.event_invoke.arn
}
