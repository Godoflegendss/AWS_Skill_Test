

# AWS VPC Creation 
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {Name="${var.cluster_name}-vpc"}
}

# AWS Internet Gateway for internet access for the subnet

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {Name="${var.cluster_name}-igw"}
  
}

# Private and Public Subnets 

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = var.aws_av_region[count.index]
    map_public_ip_on_launch = true
    tags = {Name="${var.cluster_name}-public-${count.index+1}"}
}

resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    availability_zone = var.aws_av_region[count.index]
    cidr_block = var.private_subnet_cidrs[count.index]
    tags = {Name="${var.cluster_name}-private-${count.index+1}"}
}

# Public IP for NAT gateway

resource "aws_eip" "nat" {
    count=length(aws_subnet.public)
    domain = "vpc"
  
}

# NAT gateway creation

resource "aws_nat_gateway" "nat" {
    count = length(aws_subnet.public)
    allocation_id = aws_eip.nat[count.index].id
    subnet_id = aws_subnet.public[count.index].id
    tags = {Name="${var.cluster_name}-nat-${count.index+1}"}
  
}

# Route table creation for routing requests accross subnets

resource "aws_route_table" "public" {
    vpc_id=aws_vpc.main.id
    route{
        cidr_block="0.0.0.0/0"
        gateway_id=aws_internet_gateway.igw.id
    }
    tags=  {Name="${var.cluster_name}-public-rt"}


}
resource "aws_route_table_association" "public_association" {
    count=length(aws_subnet.public)
    subnet_id=aws_subnet.public[count.index].id
    route_table_id=aws_route_table.public.id
  
}


resource "aws_route_table" "private" {
    count=length(aws_subnet.private)
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat[count.index].id
    }
   tags = {Name="${var.cluster_name}-private-rt"}
}

resource "aws_route_table_association" "private_association" {
    count=length(aws_subnet.private)
    subnet_id=aws_subnet.private[count.index].id
    route_table_id=aws_route_table.private[count.index].id
  
}
