resource "aws_elasticache_subnet_group" "redis" {
    name = "${var.cluster_name}-redis-subnet-group"
    subnet_ids = aws_subnet.private[*].id
    tags = {Name="${var.cluster_name}-redis-subnet-group"}
  
}

resource "aws_elasticache_replication_group" "redis" {
    replication_group_id = "${var.cluster_name}-redis"
    description = "Redis replication group for ${var.cluster_name}"
    node_type = "cache.t3.micro"
    num_cache_clusters = 2
    automatic_failover_enabled = true
    subnet_group_name = aws_elasticache_subnet_group.redis.name
    security_group_ids = [aws_security_group.redis.id]
    at_rest_encryption_enabled = true
    transit_encryption_enabled = true
    kms_key_id = aws_kms_key.main.arn
    tags = {Name="${var.cluster_name}-redis"}
}