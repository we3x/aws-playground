resource "aws_elasticache_cluster" "production-cache" {
  cluster_id           = var.redis_cluster
  engine               = "redis"
  node_type            = var.redis_node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.1"
  port                 = 6379
}