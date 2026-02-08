#   Tokyo TGW hub
#  - Create TGW -- this is so that we can have a central point for routing traffic between VPCs and to the internet
#  - Create TGW attachment to VPC -- this is so that the TGW can route traffic to and from the VPC
#  - Create TGW peering attachment to Sao Paulo TGW -- this is so that the TGW can route traffic to and from the Sao Paulo TGW
#  - Create route in Tokyo private route table to send traffic to Sao Paulo via TGW -- this is so that traffic destined for the Sao Paulo VPC will be routed through the TGW
resource "aws_ec2_transit_gateway" "tokyo_tgw" {
  description = "Tokyo TGW hub"
  tags = { Name = "shinjuku-tgw01" }
}


# Create TGW attachment to VPC
# this allows the TGW to route traffic to and from the VPC
# Note: you can attach multiple VPCs to the same TGW, but for simplicity we'll just attach one VPC in this lab
resource "aws_ec2_transit_gateway_vpc_attachment" "tokyo_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.tokyo_tgw.id
  vpc_id             = aws_vpc.tokyo_vpc.id

  subnet_ids = [
    aws_subnet.tokyo_public_subnet_1.id
  ]

  tags = { Name = "shinjuku-tgw-attach01" }
}

# Create TGW peering attachment to Sao Paulo TGW
# this allows the TGW to route traffic to and from the Sao Paulo TGW
variable "saopaulo_tgw_id" { type = string }
variable "saopaulo_account_id" { type = string } # if needed; usually same acct

# Create TGW peering attachment to Sao Paulo TGW
resource "aws_ec2_transit_gateway_peering_attachment" "tokyo_to_sp" {
  transit_gateway_id      = aws_ec2_transit_gateway.tokyo_tgw.id
  peer_transit_gateway_id = var.saopaulo_tgw_id
  peer_region             = "sa-east-1"

  tags = { Name = "shinjuku-to-liberdade-tgw-peer01" }
}

# Create route in Tokyo private route table to send traffic to Sao Paulo via TGW
#Add Tokyo routes back to São Paulo CIDR (private route tables
variable "saopaulo_vpc_cidr" { type = string }

resource "aws_route" "tokyo_private_to_sp" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = var.saopaulo_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.tokyo_tgw.id
}

#Update Tokyo RDS Security Group to allow São Paulo CIDR
resource "aws_security_group_rule" "rds_in_from_sp" {
  type              = "ingress"
  security_group_id = aws_security_group.rds_sg.id
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [var.saopaulo_vpc_cidr]
}


#Tokyo outputs (required)
# output "tokyo_vpc_cidr" { value = aws_vpc.main.cidr_block }
# output "tokyo_tgw_id"   { value = aws_ec2_transit_gateway.tokyo_tgw.id }
# output "tokyo_rds_endpoint" { value = aws_db_instance.medical_db.endpoint }
