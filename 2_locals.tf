# 1c_bonus_b/locals.tf
#local values for existing Chewbacca infrastructure

data "aws_vpc" "tetsuzai" {
  filter {
    name   = "tag:Name"
    values = ["tetsuzai-vpc"]
  }
}

# data "aws_subnet_ids" "public" {
#   vpc_id = local.vpc_id
#   tags = {
#     Tier = "public"
#   }
# }
locals {
  vpc_id          = "vpc-0b8869d887c22c27e"
  # public_subnets  = ["subnet-0b042ad35f85ea27", "subnet-03473bd995f5f8931"]
  public_subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
  ec2_instance_id = "i-0891580f67c9ee103"
  ec2_sg_id       = "sg-0390ed8e3fd37f1f2"

}

resource "null_resource" "validate_subnets" {
  count = length(local.public_subnets) == 0 ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'ERROR: No public subnets found. Check your tags.' && exit 1"
  }
}