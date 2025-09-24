data "aws_iam_policy_document" "eks_assume_role"{
    statement {
      actions = [ "sts:AssumeRole" ]
      principals {
        type = "Service"
        identifiers = [ "eks.amazonaws.com" ]
      }
    }
    
}

resource "aws_iam_role" "eks_cluster_role" {
    name = "${var.cluster_name}-cluster-role"
    assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
  
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSclusterPolicy" {
    role = aws_iam_role.eks_cluster_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  
}
resource "aws_iam_role" "eks_node_role" {
    name = "${var.cluster_name}-node-role"
    assume_role_policy = jsonencode({
        Version="2012-10-17"
        Statement=[{
            Action="sts:AssumeRole"
            Effect="Allow"
            Principal={Service="ec2.amazonaws.com"}
        }]
    })
  
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
    role=aws_iam_role.eks_node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_AmazoneEC2ContainerRegistryReadonly" {
    role = aws_iam_role.eks_node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
    role = aws_iam_role.eks_node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  
}


resource "aws_eks_cluster" "this" {
    name=var.cluster_name
    role_arn = aws_iam_role.eks_cluster_role.arn
    version = "1.28"
    vpc_config {
      subnet_ids = aws_subnet.private[*].id
      endpoint_public_access = true
    }
    tags = {Name=var.cluster_name}
  
}

resource "aws_eks_node_group" "ng1" {
    cluster_name = aws_eks_cluster.this.name
    node_group_name = var.node_group_1.name
    node_role_arn = aws_iam_role.eks_node_role.arn
    subnet_ids = aws_subnet.private[*].id
    scaling_config {
      desired_size = var.node_group_1.desired_size
      max_size = var.node_group_1.max_size
      min_size = var.node_group_1.min_size
    }

    instance_types = [ var.node_group_1.instance_type ]
  
}

resource "aws_eks_node_group" "ng2" {
    cluster_name = aws_eks_cluster.this.name
    node_group_name = var.node_group_2.name
    node_role_arn = aws_iam_role.eks_node_role.arn
    subnet_ids = aws_subnet.private[*].id
    scaling_config {
      desired_size = var.node_group_2.desired_size
      max_size = var.node_group_2.max_size
      min_size = var.node_group_2.min_size
    }

    instance_types = [ var.node_group_2.instance_type ]
  
}

data "aws_eks_cluster_auth" "cluster" {
    name=aws_eks_cluster.this.name
    depends_on = [ aws_eks_cluster.this ]
  
}

# Kubernetes provider
provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}