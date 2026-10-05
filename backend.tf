terraform {
  backend "oci" {
    bucket    = "terraform-state"
    namespace = "axyblpdcnryl"
    key       = "oci-terraform/dev/terraform.tfstate"
    region    = "ap-hyderabad-1"

    auth = "APIKey"
    config_file_profile = "DEFAULT"
  }
}
