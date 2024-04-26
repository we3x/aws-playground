output "REACT_APP_API_SERVICE_URL" {
  value = "http://${aws_lb.production.dns_name}"
}

output "ECS_CLUSTER" {
  value = aws_ecs_cluster.production.name
}

output "ECS_CLIENT_SERVICE" {
  value = aws_ecs_service.client-prod-service.name
}

output "ECS_API_SERVICE" {
  value = aws_ecs_service.api-prod-service.name
}