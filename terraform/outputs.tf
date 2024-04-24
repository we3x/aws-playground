output "alb_hostname" {
  value = aws_lb.production.dns_name
}

output "s3_domain" {
  value = aws_s3_bucket.sysblink-bucket.bucket_regional_domain_name
}

output "clinet_repository" {
  value = aws_ecr_repository.client-repository.repository_url
}

output "api_repository" {
  value = aws_ecr_repository.api-repository.repository_url
}