resource "aws_eip" "nat" {
  tags = {
    Name = "tetsuzai-nat-eip"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "tetsuzai-nat-gateway"
  }
}

resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.tetsuzai.id

  tags = {
    Name = "tetsuzai-private-route-table"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}
