########################################
# Common Terraform Locals
########################################

locals {

  ########################################
  # Common Defined Tags
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
