locals {
  tokyo_vpc_cidr     = data.terraform_remote_state.tokyo.outputs.tokyo_vpc_cidr
  tokyo_tgw_id       = data.terraform_remote_state.tokyo.outputs.tokyo_tgw_id
  tokyo_rds_endpoint = data.terraform_remote_state.tokyo.outputs.tokyo_rds_endpoint
}
