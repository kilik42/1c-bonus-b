# Request cross-region peering from the primary-side TGW to the Sao Paulo TGW.
# This creates the backbone link between the logical primary/data-authority side and the secondary compute region.
resource "aws_ec2_transit_gateway_peering_attachment" "to_saopaulo" {
  peer_account_id         = data.aws_caller_identity.current.account_id
  peer_region             = "sa-east-1"
  peer_transit_gateway_id = var.saopaulo_tgw_id
  transit_gateway_id      = aws_ec2_transit_gateway.lab3_tgw.id

  tags = {
    Name = "${var.project_name}-to-saopaulo"
  }
}

data "aws_caller_identity" "current" {}


# Route traffic destined for the São Paulo VPC through the TGW peering attachment.
# This allows the primary side to know how to reach the secondary region over the private backbone.
resource "aws_ec2_transit_gateway_route" "to_saopaulo_vpc" {
  destination_cidr_block         = var.saopaulo_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.to_saopaulo.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.lab3_tgw.association_default_route_table_id
}