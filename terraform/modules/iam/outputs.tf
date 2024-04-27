output "ecs-host-role-arn" {
  value         = aws_iam_role.ecs-host.arn 
}

output "ecs-service-role-policy" {
  value = aws_iam_role_policy.ecs-service-role-policy
}