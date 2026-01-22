# 1c_bonus_b/locals.tf
#local values for existing Chewbacca infrastructure
locals {
  vpc_id          = "vpc-0b8869d887c22c27e"
  public_subnets  = ["subnet-0b042ad35f85ea27", "subnet-03473bd995f5f8931"]
  ec2_instance_id = "i-0891580f67c9ee103"
  ec2_sg_id       = "sg-0390e8ed3fd3f7f12"
}
