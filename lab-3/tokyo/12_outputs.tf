output "tokyo_vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "tokyo_tgw_id" {
  value = aws_ec2_transit_gateway.tokyo_tgw.id
}

output "tokyo_rds_endpoint" {
  value = aws_db_instance.medical_db.endpoint
}

output "tokyo_sp_peering_attachment_id" {
  value = aws_ec2_transit_gateway_peering_attachment.tokyo_to_sp.id
}
