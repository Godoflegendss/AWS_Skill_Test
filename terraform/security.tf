
# Security group for EKS
resource "aws_security_group" "eks_nodes" {
    name = "${var.cluster_name}-nodes-sg"
    description = "SG for EKS worker nodes"
    vpc_id = aws_vpc.main.id



egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]

}
ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true

}
tags = {Name="${var.cluster_name}-nodes-sg"}

}

# Database Security Group

resource "aws_security_group" "rds" {
    name = "${var.cluster_name}-rds-sg"
    vpc_id = aws_vpc.main.id
    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        security_groups = [aws_security_group.eks_nodes.id]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol="-1"
        cidr_blocks= ["0.0.0.0/0"]
    }
   tags = {Name="${var.cluster_name}-rds-sg"} 
}

#ElastiCache SG
resource "aws_security_group" "redis" {
    name = "${var.cluster_name}-redis-sg"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 6379
        to_port = 6379
        protocol = "tcp"
        security_groups = [aws_security_group.eks_nodes.id]

    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
  tags = {Name="${var.cluster_name}-redis-sg"}
}
