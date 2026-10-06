########################################
# Boot Volume Module
########################################

module "boot_volume" {

  source = "./modules/Boot_Volume"

  ########################################
  # Default Configuration
  ########################################

  default_compartment_id = var.default_compartment_id

  default_defined_tags = local.common_defined_tags

  default_freeform_tags = local.common_freeform_tags

  ########################################
  # Boot Volumes
  #
  # Example:
  #
  # Create a new Boot Volume from
  # an existing Boot Volume Backup.
  ########################################

  boot_volumes = var.boot_volumes

  ########################################
  # Manual Boot Volume Backups
  ########################################

  boot_volume_backups = var.boot_volume_backups
}


########################################
# Compute Module
########################################

module "compute" {

  source = "./modules/Compute"

  ########################################
  # Environment
  ########################################

  environment = var.environment

  ########################################
  # Default Compartment
  ########################################

  default_compartment_id = var.default_compartment_id

  ########################################
  # Default Tags
  ########################################

  default_defined_tags = local.common_defined_tags

  default_freeform_tags = local.common_freeform_tags

  ########################################
  # Compute Instances
  #
  # Normal Image-based Server:
  #
  #   source_id comes directly from
  #   var.instances
  #
  # Boot Volume-based Server:
  #
  #   boot_volume_name is used here to
  #   find the Boot Volume created by
  #   the Boot_Volume module.
  ########################################

  instances = {

    for name, instance in var.instances :

    name => merge(

      instance,

      ######################################
      # Check whether this server should
      # boot from an existing/new
      # Boot Volume.
      ######################################

      lower(
        try(
          instance.instance_source_type,
          "image"
        )
      ) == "bootvolume"

      ? {

          ####################################
          # Get Boot Volume OCID from the
          # Boot_Volume module.
          ####################################

          source_id = module.boot_volume.boot_volume_ids[
            instance.boot_volume_name
          ]

        }

      : {}

    )
  }
}


########################################
# Block Storage Module
########################################

module "block_storage" {

  source = "./modules/Block_Storage"

  ########################################
  # Default Compartment
  ########################################

  default_compartment_id = var.default_compartment_id

  ########################################
  # Default Tags
  ########################################

  default_defined_tags = local.common_defined_tags

  default_freeform_tags = local.common_freeform_tags

  ########################################
  # Block Volumes
  ########################################

  block_volumes = var.block_volumes

  ########################################
  # Block Volume Backups
  ########################################

  volume_backups = var.volume_backups

  ########################################
  # Block Volume Attachments
  ########################################

  volume_attachments = var.volume_attachments

  ########################################
  # Compute Instance IDs
  #
  # The Compute module creates the
  # instances first.
  #
  # Block Storage uses these IDs when
  # attaching volumes to servers.
  ########################################

  compute_instance_ids = module.compute.instance_ids
}
