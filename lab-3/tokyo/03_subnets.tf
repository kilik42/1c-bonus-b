# build here for tokyo region
resource "aws_subnet" "tokyo_public_subnet_1" {
  provider = aws.tokyo
  vpc_id   = aws_vpc.tokyo_vpc.id
  cidr_block = "10.0.1.0/24"
    availability_zone = "ap-northeast-1a"
    tags = {
    Name = "tokyo_public_subnet_1"
    }
}

# second public subnet in tokyo region
resource "aws_subnet" "tokyo_public_subnet_2" {
  provider = aws.tokyo
  vpc_id   = aws_vpc.tokyo_vpc.id
  cidr_block = "10.0.2.0/24"
    availability_zone = "ap-northeast-1c"
    tags = {
    Name = "tokyo_public_subnet_2"
    }
}

# create two private subnets in tokyo region
resource "aws_subnet" "tokyo_private_subnet_1" {
  provider = aws.tokyo
  vpc_id   = aws_vpc.tokyo_vpc.id
  cidr_block = "10.0.3.0/24"
    availability_zone = "ap-northeast-1a"
    tags = {
    Name = "tokyo_private_subnet_1"
    }       

}

resource "aws_subnet" "tokyo_private_subnet_2" {
  provider = aws.tokyo
  vpc_id   = aws_vpc.tokyo_vpc.id
  cidr_block = "10.0.4.0/24"
    availability_zone = "ap-northeast-1c"
    tags = {
    Name = "tokyo_private_subnet_2"
    }
}


