#This is where the secondary region joins the private backbone.

#create a São Paulo Transit Gateway
# attach the São Paulo VPC to it

# Transit Gateway for the São Paulo secondary region.
# This gives the satellite compute region its own regional TGW so it can participate in cross-region peering.

# created the tokyo TGW in the primary region, so we can peer the São Paulo TGW to it later. The primary region TGW acts as the network backbone for the multi-region connectivity in this lab. tokyo TGW is created in the primary region because transit gateway peering attachments must be created in the same region as the requester TGW, and the requester TGW must be in the primary region for this lab's architecture.
resource "aws_ec2_transit_gateway" "lab3_tgw" {
  description = "LAB3A Transit Gateway for São Paulo secondary region"

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-tgw"
  })
}

# Attach the São Paulo VPC to the regional TGW.
# The application subnets will use this attachment to reach the primary/data-authority side later.
resource "aws_ec2_transit_gateway_vpc_attachment" "saopaulo_attachment" {
  subnet_ids = [
    aws_subnet.private_app_a.id,
    aws_subnet.private_app_b.id
  ]

  transit_gateway_id = aws_ec2_transit_gateway.lab3_tgw.id
  vpc_id             = aws_vpc.saopaulo_vpc.id

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-vpc-attachment"
  })
}