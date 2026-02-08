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


# fix the following code to create a private route table and associate it with the private subnets in tokyo region
# # create route table for Tokyo VPC
# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id

#   tags = { Name = "shinjuku-private-rt01" }
# }

# # create route table association for Tokyo private subnets
# resource "aws_route_table_association" "private_a" {
#   subnet_id      = aws_subnet.private_a.id
#   route_table_id = aws_route_table.private.id
# }

# resource "aws_route_table_association" "private_b" {
#   subnet_id      = aws_subnet.private_b.id
#   route_table_id = aws_route_table.private.id
# }

# fix this code above
#create private route table for tokyo region
resource "aws_route_table" "tokyo_private_route_table" {
  provider = aws.tokyo
  vpc_id   = aws_vpc.tokyo_vpc.id
    tags = {
        Name = "tokyo_private_route_table"
    }
}

# create route to nat gateway for private route table
resource "aws_route" "tokyo_private_nat_route" {
  provider = aws.tokyo
  route_table_id         = aws_route_table.tokyo_private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.tokyo_nat_gw.id
}
# associate private subnets with private route table
resource "aws_route_table_association" "tokyo_private_subnet_1_association" {
  provider = aws.tokyo
  subnet_id      = aws_subnet.tokyo_private_subnet_1.id
  route_table_id = aws_route_table.tokyo_private_route_table.id
}


resource "aws_route_table_association" "tokyo_private_subnet_2_association" {
  provider = aws.tokyo
  subnet_id      = aws_subnet.tokyo_private_subnet_2.id
  route_table_id = aws_route_table.tokyo_private_route_table.id
}


