resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.tetsuzai.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "tetsuzai-public-route-table"
  }
}
resource "aws_internet_gateway" "main" {
  vpc_id = data.aws_vpc.tetsuzai.id

  tags = {
    Name = "tetsuzai-internet-gateway"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}


resource "aws_subnet" "public_a" {
  vpc_id                  = data.aws_vpc.tetsuzai.id
  cidr_block              = "10.0.10.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "tetsuzai-public-subnet-us-west-2a"
    Tier = "public"
  }
}
resource "aws_subnet" "public_b" {
  vpc_id                  = data.aws_vpc.tetsuzai.id
  cidr_block              = "10.0.11.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "tetsuzai-public-subnet-us-west-2b"
    Tier = "public"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id                  = data.aws_vpc.tetsuzai.id
  cidr_block              = "10.0.128.0/20"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "tetsuzai-private-subnet-us-west-2a"
    Tier = "private"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id                  = data.aws_vpc.tetsuzai.id
  cidr_block              = "10.0.144.0/20"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "tetsuzai-private-subnet-us-west-2b"
    Tier = "private"
  }
}
