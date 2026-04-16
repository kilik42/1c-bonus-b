# Shared local naming/tags for the São Paulo region.
# This file defines the VPC and subnet resources for the São Paulo secondary compute region.
# i am using locals here to centralize naming and tagging conventions for easier maintenance and consistency across resources.

locals {
  project_name = var.project_name

  common_tags = {
    Project    = local.project_name
    Lab        = "lab3a"
    ManagedBy  = "terraform"
    RegionRole = "saopaulo-secondary"
  }
}

# Pull available AZs in São Paulo so subnet placement stays flexible.
data "aws_availability_zones" "available" {
  state = "available"
}

# Main VPC for the São Paulo secondary compute region.
# This region hosts the stateless application tier, not the primary data authority.
resource "aws_vpc" "saopaulo_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-vpc"
  })
}

# Internet Gateway for public-facing ingress resources.
# The ALB will sit in public subnets, so this VPC needs outbound internet routing.
resource "aws_internet_gateway" "saopaulo_igw" {
  vpc_id = aws_vpc.saopaulo_vpc.id

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-igw"
  })
}

# Public subnet A for the São Paulo ALB.
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.saopaulo_vpc.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-public-a"
  })
}

# Public subnet B for the São Paulo ALB.
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.saopaulo_vpc.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-public-b"
  })
}

# Private application subnet A for São Paulo compute.
resource "aws_subnet" "private_app_a" {
  vpc_id            = aws_vpc.saopaulo_vpc.id
  cidr_block        = var.private_app_subnet_a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-private-app-a"
  })
}

# Private application subnet B for São Paulo compute.
resource "aws_subnet" "private_app_b" {
  vpc_id            = aws_vpc.saopaulo_vpc.id
  cidr_block        = var.private_app_subnet_b_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-private-app-b"
  })
}

# Public route table for São Paulo ingress subnets.
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.saopaulo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.saopaulo_igw.id
  }

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-public-rt"
  })
}

# Associate public subnet A with the public route table.
resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate public subnet B with the public route table.
resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}