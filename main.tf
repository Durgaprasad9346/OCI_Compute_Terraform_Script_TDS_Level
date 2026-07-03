module "compute" {

  source = "./modules/compute"

  environment = var.environment

  default_compartment_id = var.default_compartment_id

  default_defined_tags = local.common_defined_tags

  default_freeform_tags = local.common_freeform_tags

}
