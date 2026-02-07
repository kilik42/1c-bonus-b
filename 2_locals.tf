# 1c_bonus_b/locals.tf
#local values for existing Chewbacca infrastructure

data "aws_vpc" "tetsuzai" {
   id = "vpc-01ed1e5d17730684f"
}
data "aws_subnet" "public_a" {
  id = "subnet-0b042ad335f852ea7"
}

resource "aws_subnet" "public_b" {
  vpc_id                  = data.aws_vpc.tetsuzai.id
  cidr_block = "10.0.4.0/24"

  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-02"
  }
}

# data "aws_subnet" "public_b" {
#   id = "subnet-0bc7fd6d701e7a52c"
# }
data "aws_subnet" "private_a" {
  id = "subnet-0bc7fd6d701e7a52c"
}

data "aws_subnet" "private_b" {
  id = "subnet-07b9ec4e222188e12"
}

locals {
  vpc_id = data.aws_vpc.tetsuzai.id
  # vpc_id = aws_vpc.tetsuzai.id

  # public_subnets  = ["subnet-0b042ad35f85ea27", "subnet-03473bd995f5f8931"]
  public_subnets = [
    data.aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
  ec2_instance_id = aws_instance.tetsuzai_app.id

 ec2_sg_id = aws_security_group.ec2_sg.id


}

resource "null_resource" "validate_subnets" {
  count = length(local.public_subnets) == 0 ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'ERROR: No public subnets found. Check your tags.' && exit 1"
  }
}


