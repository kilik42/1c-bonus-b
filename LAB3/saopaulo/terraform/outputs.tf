
# Output the Transit Gateway ID so we can reference it in the primary region for peering.
output "tgw_id" {
  description = "Transit Gateway ID for the São Paulo region"
  value       = aws_ec2_transit_gateway.lab3_tgw.id
}


# The TGW attachment ID for the São Paulo VPC is needed in the primary region to create the peering attachment, so we output it here.
output "saopaulo_attachment_id" {
  description = "São Paulo-region VPC attachment ID"
  value       = aws_ec2_transit_gateway_vpc_attachment.saopaulo_attachment.id
}