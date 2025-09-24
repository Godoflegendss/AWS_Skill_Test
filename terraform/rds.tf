resource "aws_db_subnet_group" "rds" {
    name = "${var.cluster_name}-rds-subnet-group"
    subnet_ids = aws_subnet.private[*].id
    tags = {Name="${var.cluster_name}-rds-subnet-group"}
  
}

resource "aws_db_instance" "postgres" {
    identifier = "${var.cluster_name}-postgres"
    instance_class = "db.t3.medium"
    engine = "postgres"
    engine_version = "15.3"
    allocated_storage = 20
    storage_type = "gp3"
    username = var.db_username
    password = var.db_password
    multi_az = true
    publicly_accessible = false
    vpc_security_group_ids = [aws_security_group.rds.id]
    db_subnet_group_name = aws_db_subnet_group.rds.name
    storage_encrypted = true
    kms_key_id = aws_kms_key.main.arn
    skip_final_snapshot = true
    tags = {Name="$var.cluster_name-postgres"}
  
}