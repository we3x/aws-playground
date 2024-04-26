resource "aws_ecr_repository" "api" {
  name = var.api_name
}

resource "aws_ecr_repository" "client" {
  name = var.client_name
}