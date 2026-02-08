# build here for vpc in tokyo region
resource "aws_vpc" "tokyo_vpc" {
  provider = aws.tokyo
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "tokyo_vpc"
    }
}
