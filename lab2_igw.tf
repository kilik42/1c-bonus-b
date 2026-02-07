
#Create (or import) the Internet Gateway
# resource "aws_internet_gateway" "igw" {
#   vpc_id = data.aws_vpc.tetsuzai.id
# }

data "aws_internet_gateway" "existing" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.tetsuzai.id]
  }
}


# Create public route table and associate with public subnets
resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.tetsuzai.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.existing.id
  }
}

# Associate public route table with public subnets
resource "aws_route_table_association" "public_a" {
  subnet_id      = data.aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}


resource "aws_eip" "nat" {
  

  tags = {
    Name = "tetsuzai-nat-eip"
  }
}


# Create a NAT Gateway (you already have an EIP) Associate public route table with public subnets
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = data.aws_subnet.public_a.id
}

#Create a private route table

resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.tetsuzai.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

#Associate your private subnets with the private route table

resource "aws_route_table_association" "private_a" {
  subnet_id      = data.aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = data.aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}


