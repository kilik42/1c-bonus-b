# Pull subnets from the existing primary VPC so we can attach it to the TGW. transit gateway attachments require at least one subnet per AZ, so we will pull all subnets and then slice the list to get the first two for the attachment.
# We need at least one subnet per AZ for the attachment.
data "aws_subnets" "primary_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.primary_vpc_id]
  }
}

# Transit Gateway for LAB3A multi-region connectivity.
# This acts as the network backbone between the primary region and São Paulo secondary region.
resource "aws_ec2_transit_gateway" "lab3_tgw" {
  description = "LAB3A Transit Gateway for primary/secondary region connectivity"

  tags = {
    Name    = "${var.project_name}-tgw"
    Project = "lab3"
    Lab     = "lab3a"
  }
}

# Attach the primary VPC to the Transit Gateway.
# This makes the primary/data-authority region reachable over the TGW backbone.
resource "aws_ec2_transit_gateway_vpc_attachment" "primary_attachment" {
  subnet_ids         = slice(data.aws_subnets.primary_vpc_subnets.ids, 0, 2) # Get the first two subnets for the attachment (one per AZ)
  transit_gateway_id = aws_ec2_transit_gateway.lab3_tgw.id # Reference the TGW created above
  vpc_id             = var.primary_vpc_id # Reference the primary VPC ID from variables

  tags = {
    Name = "${var.project_name}-primary-attachment" # Name the attachment for clarity in the AWS console
  }
}