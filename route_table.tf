# resource "aws_route_table" "public" {
#   vpc_id = data.aws_vpc.tetsuzai.id
#   # vpc_id = aws_vpc.tetsuzai.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.main.id
#   }

#   depends_on = [aws_internet_gateway.main]

#   tags = {
#     Name = "tetsuzai-public-route-table"
#   }
# }
# resource "aws_internet_gateway" "main" {
#   vpc_id = data.aws_vpc.tetsuzai.id
#   # vpc_id = aws_vpc.tetsuzai.id

#   tags = {
#     Name = "tetsuzai-internet-gateway"
#   }
# }

# resource "aws_route_table_association" "public_a" {
#   subnet_id      = data.aws_subnet.public_a.id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table_association" "public_b" {
#   subnet_id      = data.aws_subnet.public_b.id
#   route_table_id = aws_route_table.public.id
# }


# resource "aws_subnet" "public_a" {
#   vpc_id                  = data.aws_vpc.tetsuzai.id
#   # vpc_id                  = aws_vpc.tetsuzai.id
#   cidr_block              = "10.0.10.0/24"
#   availability_zone       = "us-west-2a"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "tetsuzai-public-subnet-us-west-2a"
#     Tier = "public"
#   }
# }
# resource "aws_subnet" "public_b" {
#   vpc_id                  = data.aws_vpc.tetsuzai.id
#   # vpc_id                  = aws_vpc.tetsuzai.id
#   cidr_block              = "10.0.11.0/24"
#   availability_zone       = "us-west-2b"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "tetsuzai-public-subnet-us-west-2b"
#     Tier = "public"
#   }
# }

# resource "aws_subnet" "private_a" {
#   vpc_id                  = data.aws_vpc.tetsuzai.id
#   # vpc_id                  = aws_vpc.tetsuzai.id
#   cidr_block              = "10.0.128.0/20"
#   availability_zone       = "us-west-2a"
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "tetsuzai-private-subnet-us-west-2a"
#     Tier = "private"
#   }
# }

# resource "aws_subnet" "private_b" {
#   vpc_id                  = data.aws_vpc.tetsuzai.id
#   # vpc_id                  = aws_vpc.tetsuzai.id
#   cidr_block              = "10.0.144.0/20"
#   availability_zone       = "us-west-2b"
#   map_public_ip_on_launch = false

#   tags = {
#     Name = "tetsuzai-private-subnet-us-west-2b"
#     Tier = "private"
#   }
# }
###############################################
# EXISTING NETWORK (READ-ONLY)
###############################################

# Existing VPC
# data "aws_vpc" "tetsuzai" {
#   id = "vpc-01ed1e5d17730684f"
# }

# # Existing public subnets
# data "aws_subnet" "public_a" {
#   id = "subnet-08954564465c7833c"
# }

# data "aws_subnet" "public_b" {
#   id = "subnet-0bc7fd6d701e7a52c"
# }

# # Existing private subnets
# data "aws_subnet" "private_a" {
#   id = "subnet-0e56c22cd6f5ae54e"
# }

# data "aws_subnet" "private_b" {
#   id = "subnet-0123a5c597beefed4"
# }

# Existing Internet Gateway
# data "aws_internet_gateway" "main" {
#   filter {
#     name   = "internet-gateway-id"
#     values = ["igw-0a846390f4636a0b7"]
#   }
# }

# Existing NAT Gateway
# data "aws_nat_gateway" "existing" {
#   filter {
#     name   = "nat-gateway-id"
#     values = ["nat-061e6dd7305e8cec0"]
#   }
# }

# Existing private route table
# data "aws_route_table" "private" {
#   id = "rtb-0a61071beec420b8b"
# }
