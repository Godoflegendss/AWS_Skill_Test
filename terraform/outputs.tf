output "vpc_id" {value=aws_vpc.main.id}
output "public_subnets" { value = aws_subnet.public[*].id }
output "private_subnets" { value = aws_subnet.private[*].id }
output "eks_cluster_name" { value = aws_eks_cluster.this.name }
output "rds_endpoint" { value = aws_db_instance.postgres.address }
output "redis_primary_endpoint" { value = aws_elasticache_replication_group.redis.primary_endpoint_address }
output "static_bucket" { value = aws_s3_bucket.static.bucket }
output "tfstate_bucket" { value = aws_s3_bucket.tfstate.bucket }