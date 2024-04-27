output "cluster" {
    value = aws_elasticache_cluster.this
}

output "address" {
    value = aws_elasticache_cluster.this.cache_nodes[0].address 
}