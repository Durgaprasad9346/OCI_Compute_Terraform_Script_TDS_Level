locals {

  common_defined_tags = merge(
    var.default_defined_tags,
    {
      Environment = var.environment
    }
  )

  common_freeform_tags = merge(
    var.default_freeform_tags,
    {
      ManagedBy = "Terraform"
    }
  )

}
