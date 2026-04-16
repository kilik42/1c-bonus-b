variable "primary_peering_attachment_id" {
  description = "Peering attachment ID created from the primary region side"
  type        = string
}


# Accept the cross-region TGW peering attachment from the primary region.
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "from_primary" {
  transit_gateway_attachment_id = var.primary_peering_attachment_id

  tags = merge(local.common_tags, {
    Name = "${local.project_name}-from-primary"
  })
}


# Route traffic destined for the primary VPC through the accepted TGW peering attachment.
# This allows São Paulo application resources to reach the primary/data-authority side privately.
resource "aws_ec2_transit_gateway_route" "to_primary_vpc" {
  destination_cidr_block         = var.primary_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.from_primary.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.lab3_tgw.association_default_route_table_id
}