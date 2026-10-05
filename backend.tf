terraform {
  backend "oci" {
    bucket    = "terraform-state"
    namespace = "YOUR_NAMESPACE"
    key       = "oci-terraform/dev/terraform.tfstate"
    region    = "ap-hyderabad-1"

    auth = "APIKey"
    config_file_profile = "DEFAULT"
  }
}
