# Main VPC for the rebuilt Lab 1 environment.
# Keeping this isolated makes the stack easier to understand and tear down cleanly.
resource "aws_vpc" "lab1_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-vpc"
  })
}

# Internet Gateway for public-facing resources.
# The ALB needs public internet access, so the VPC needs an IGW.
resource "aws_internet_gateway" "lab1_igw" {
  vpc_id = aws_vpc.lab1_vpc.id

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-igw"
  })
}

# Pull available AZs in the chosen region so subnet placement is flexible.
data "aws_availability_zones" "available" {
  state = "available"
}

# Public subnet A for the ALB.
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.lab1_vpc.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-public-a"
  })
}

# Public subnet B for the ALB.
# ALB needs at least two subnets in different AZs.
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.lab1_vpc.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-public-b"
  })
}

# Private subnet for the EC2 app host.
# The app server should not be directly exposed to the internet.
resource "aws_subnet" "private_app_a" {
  vpc_id            = aws_vpc.lab1_vpc.id
  cidr_block        = "10.10.10.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-private-app-a"
  })
}

# First private DB subnet for RDS.
resource "aws_subnet" "private_db_a" {
  vpc_id            = aws_vpc.lab1_vpc.id
  cidr_block        = "10.10.20.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-private-db-a"
  })
}

# Second private DB subnet for RDS.
# RDS subnet groups need subnets in multiple AZs.
resource "aws_subnet" "private_db_b" {
  vpc_id            = aws_vpc.lab1_vpc.id
  cidr_block        = "10.10.21.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-private-db-b"
  })
}

# Public route table so the ALB subnets can reach the internet through the IGW.
# The EC2 app host and RDS database will not use this route table since they are private.
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lab1_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab1_igw.id
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-public-rt"
  })
}

# Associate public subnet A with the public route table.
# This allows the ALB in this subnet to route traffic to the internet via the IGW.
resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate public subnet B with the public route table.
# This allows the ALB in this subnet to route traffic to the internet via the IGW.
resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}