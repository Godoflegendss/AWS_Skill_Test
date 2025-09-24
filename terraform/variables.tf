variable "aws_region" {
    type = string
    default = "ap-south-1"  
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
  
}

variable "aws_av_region" {
    type = list(string)
    default = [ "ap-south-1a","ap-south-1b" ]
  
}

variable "public_subnet_cidrs" {
    type = list(string)
    default = [ "10.0.1.0/24","10.0.2.0/24" ]

}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.100.0/24", "10.0.101.0/24"]
}

variable "cluster_name" {
    default = "demo-eks-cluster" 
}

variable "node_group_1" {
    type = object({
      name = string
      instance_type=string
      desired_size=number
      min_size=number
      max_size=number

    })
    default = {
      name = "worker-ng-1"
      instance_type = "t3.medium"
      desired_size = 2
      min_size = 1
      max_size = 3
    }
  
}
variable "node_group_2" {
  type = object({
    name          = string
    instance_type = string
    desired_size  = number
    min_size      = number
    max_size      = number
  })
  default = {
    name          = "worker-ng-2"
    instance_type = "t3.large"
    desired_size  = 2
    min_size      = 1
    max_size      = 4
  }
}



variable "db_username" {
    default = "Login"

  
}

variable "db_password" {
    default="Hello@123"
  
}