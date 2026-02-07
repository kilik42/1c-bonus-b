# resource "aws_eip" "nat" {
#   tags = {
#     Name = "tetsuzai-nat-eip"
#   }
# }

# resource "aws_nat_gateway" "this" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = data.aws_subnet.public_a.id

#   tags = {
#     Name = "tetsuzai-nat-gateway"
#   }
# }

# resource "aws_route_table" "private" {
#   vpc_id = data.aws_vpc.tetsuzai.id
#     # vpc_id = aws_vpc.tetsuzai.id

#   tags = {
#     Name = "tetsuzai-private-route-table"
#   }
# }

# resource "aws_route_table_association" "private_a" {
#   subnet_id      = data.aws_subnet.private_a.id
#   route_table_id = aws_route_table.private.id
# }

# resource "aws_route_table_association" "private_b" {
#   subnet_id      = data.aws_subnet.private_b.id
#   route_table_id = aws_route_table.private.id
# }
data "aws_nat_gateway" "existing" {
  filter {
    name   = "nat-gateway-id"
    values = ["nat-061e6dd7305e8cec0"]
  }
}

data "aws_route_table" "private" {
  route_table_id = "rtb-0a61071beec420b8b"
}


data "aws_internet_gateway" "main" {
  filter {
    name   = "internet-gateway-id"
    values = ["igw-0a846390f4636a0b7"]
  }
}