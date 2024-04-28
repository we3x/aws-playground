resource "aws_cloudwatch_log_group" "client-group" {
  name              = var.client-group-name
  retention_in_days = var.log_retention_in_days
}

resource "aws_cloudwatch_log_stream" "client-stream" {
  name           = var.client-stream-name
  log_group_name = aws_cloudwatch_log_group.client-group.name
}

resource "aws_cloudwatch_log_group" "api-group" {
  name              = var.api-group-name
  retention_in_days = var.log_retention_in_days
}

resource "aws_cloudwatch_log_stream" "api-stream" {
  name           = var.api-stream-name
  log_group_name = aws_cloudwatch_log_group.api-group.name
}