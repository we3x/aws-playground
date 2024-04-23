resource "aws_cloudwatch_log_group" "client-log-group" {
  name              = "/ecs/client-app"
  retention_in_days = var.log_retention_in_days
}

resource "aws_cloudwatch_log_stream" "client-log-stream" {
  name           = "client-app-log-stream"
  log_group_name = aws_cloudwatch_log_group.client-log-group.name
}

resource "aws_cloudwatch_log_group" "api-log-group" {
  name              = "/ecs/api-app"
  retention_in_days = var.log_retention_in_days
}

resource "aws_cloudwatch_log_stream" "api-log-stream" {
  name           = "api-app-log-stream"
  log_group_name = aws_cloudwatch_log_group.api-log-group.name
}