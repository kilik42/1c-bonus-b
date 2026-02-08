# build here the route table for tokyo region
resource "aws_route_table" "tokyo_public_route_table" {
  provider = aws.tokyo
  vpc_id   = aws_vpc.tokyo_vpc.id
    tags = {
        Name = "tokyo_public_route_table"
    }
}   

# create route to internet for public route table
resource "aws_route" "tokyo_public_internet_route" {
  provider = aws.tokyo
  route_table_id         = aws_route_table.tokyo_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.tokyo_igw.id      
}

# associate public subnets with public route table
resource "aws_route_table_association" "tokyo_public_subnet_1_association" {
  provider = aws.tokyo
  subnet_id      = aws_subnet.tokyo_public_subnet_1.id
  route_table_id = aws_route_table.tokyo_public_route_table.id
}

resource "aws_route_table_association" "tokyo_public_subnet_2_association" {
  provider = aws.tokyo
  subnet_id      = aws_subnet.tokyo_public_subnet_2.id
  route_table_id = aws_route_table.tokyo_public_route_table.id
}

