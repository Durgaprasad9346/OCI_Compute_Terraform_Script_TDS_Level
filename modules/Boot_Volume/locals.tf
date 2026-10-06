########################################
# Boot Volume Locals
########################################

locals {

  ########################################
  # Created Boot Volume IDs
  #
  # Converts Terraform logical names
  # into actual OCI Boot Volume OCIDs.
  ########################################

  created_boot_volume_ids = {

    for name, volume in oci_core_boot_volume.this :

    name => volume.id

  }


  ########################################
  # Manual Backup Source Boot Volume IDs
  #
  # Supports:
  #
  # 1. Direct boot_volume_id
  # 2. Terraform logical boot_volume_name
  ########################################

  manual_backup_source_boot_volume_ids = {

    for name, backup in var.boot_volume_backups :

    name => (

      try(backup.boot_volume_id, null) != null

      ? backup.boot_volume_id

      : local.created_boot_volume_ids[
          backup.boot_volume_name
        ]

    )

  }

}
