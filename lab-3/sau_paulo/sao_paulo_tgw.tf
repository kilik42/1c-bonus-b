resource "aws_ec2_transit_gateway" "sp_tgw" {
  description = "Sao Paulo TGW spoke"
  tags = { Name = "liberdade-tgw01" }
}

# Attach Sao Paulo VPC to its TGW
resource "aws_ec2_transit_gateway_vpc_attachment" "sp_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.sp_tgw.id
  vpc_id             = aws_vpc.main.id

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = { Name = "liberdade-tgw-attach01" }
}

# Create peering attachment to Tokyo TGW
resource "aws_route" "sp_private_to_tokyo" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = local.tokyo_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.sp_tgw.id
}

# Accept peering attachment from Tokyo TGW
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "sp_accept" {
  transit_gateway_attachment_id = data.terraform_remote_state.tokyo.outputs.tokyo_sp_peering_attachment_id
  tags = { Name = "liberdade-accept-peer01" }
}
