data "terraform_remote_state" "tokyo" {
  backend = "local"
  config = {
    path = "../tokyo/terraform.tfstate"
  }
}

