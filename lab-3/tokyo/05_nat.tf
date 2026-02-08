# build here the nat
resource "aws_nat_gateway" "tokyo_nat_gateway" {
  provider = aws.tokyo
  allocation_id = aws_eip.tokyo_nat_eip.id
  subnet_id     = aws_subnet.tokyo_public_subnet_1.id
    tags = {
        Name = "tokyo_nat_gateway"
    }
}

# you must have nat gateway to create route to internet in private subnet, so we need to create eip for nat gateway
resource "aws_eip" "tokyo_nat_eip" {
  provider = aws.tokyo
#   vpc      = true
    tags = {
        Name = "tokyo_nat_eip"
    }
}

