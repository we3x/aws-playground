output "react_app_api_service_url" {
  value = aws_lb.production.dns_name
}

output "ecs_cluster" {
  value = aws_ecs_cluster.production.name
}

output "ecr_clinet_repository" {
  value = aws_ecr_repository.client-repository.repository_url
}

output "ecs_client_service" {
  value = aws_ecs_service.client-prod-service.name
}

output "client_container_name" {
  value = "client-app"
}

output "ecr_api_repository" {
  value = aws_ecr_repository.api-repository.repository_url
}

output "ecs_api_service" {
  value = aws_ecs_service.api-prod-service.name
}

output "api_continer_name" {
  value = "api-app"
}