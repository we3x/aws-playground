resource "aws_ecr_repository" "api-repository" {
  name = var.api_registry_name
}

resource "aws_ecr_repository" "client-repository" {
  name = var.client_registry_name
}