########################################
# Block Storage Locals
########################################

locals {

  ########################################
  # Created Block Volume IDs
  #
  # Converts:
  #
  # volume01
  # volume02
  #
  # into:
  #
  # volume01 -> ocid1.volume...
  # volume02 -> ocid1.volume...
  ########################################

  created_volume_ids = {

    for name, volume in oci_core_volume.this :

    name => volume.id

  }


  ########################################
  # Backup Volume ID Resolution
  #
  # Supports two scenarios:
  #
  # 1. Existing OCI volume
  #    volume_id = "ocid1.volume..."
  #
  # 2. Volume created by this module
  #    volume_name = "volume01"
  ########################################

  backup_volume_ids = {

    for name, backup in var.volume_backups :

    name => (

      try(backup.volume_id, null) != null

      ? backup.volume_id

      : local.created_volume_ids[
          backup.volume_name
        ]

    )

  }


  ########################################
  # Attachment Volume ID Resolution
  #
  # Supports two scenarios:
  #
  # 1. Existing OCI volume
  #    volume_id = "ocid1.volume..."
  #
  # 2. Volume created by this module
  #    volume_name = "volume01"
  ########################################

  attachment_volume_ids = {

    for name, attachment in var.volume_attachments :

    name => (

      try(attachment.volume_id, null) != null

      ? attachment.volume_id

      : local.created_volume_ids[
          attachment.volume_name
        ]

    )

  }


  ########################################
  # Attachment Compute Instance ID
  # Resolution
  #
  # Supports two scenarios:
  #
  # 1. Existing OCI Compute instance
  #    instance_id = "ocid1.instance..."
  #
  # 2. Compute instance created by
  #    Compute module
  #    instance_name = "APP01"
  ########################################

  attachment_instance_ids = {

    for name, attachment in var.volume_attachments :

    name => (

      try(attachment.instance_id, null) != null

      ? attachment.instance_id

      : var.compute_instance_ids[
          attachment.instance_name
        ]

    )

  }

}
