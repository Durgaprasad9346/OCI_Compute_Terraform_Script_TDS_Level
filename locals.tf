########################################
# Common Terraform Locals
########################################

locals {

  ########################################
  # Common Defined Tags
  #
  # Keep empty for now.
  #
  # OCI defined tags must use:
  # Namespace.TagKey
  #
  # Example:
  # Operations.CostCenter = "IT"
  ########################################

  common_defined_tags = var.default_defined_tags

  ########################################
  # Common Freeform Tags
  ########################################

  common_freeform_tags = merge(
    var.default_freeform_tags,
    {
      ManagedBy = "Terraform"
    }
  )

}
