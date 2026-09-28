terraform {
  backend "s3" {

    # OCI Object Storage bucket
    bucket = ""

    # Unique state file path
    key = "oci-terraform/dev/terraform.tfstate"

    # OCI region
    region = "ap-hyderabad-1"

    # OCI Object Storage S3 Compatibility endpoint
    endpoint = "https://<OBJECT_STORAGE_NAMESPACE>.compat.objectstorage.ap-hyderabad-1.oraclecloud.com"

    # Required for OCI S3-compatible backend
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true

    # Required for OCI Object Storage
    force_path_style = true
  }
}
