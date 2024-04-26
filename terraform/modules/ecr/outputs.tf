output "client_url" {
    value = aws_ecr_repository.client.repository_url
}

output "api_url" {
    value = aws_ecr_repository.api.repository_url
}