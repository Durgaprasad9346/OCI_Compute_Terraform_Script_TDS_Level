########################################
# Boot Volume
#
# Scenario:
#
# Create a new Boot Volume from an
# existing Boot Volume Backup.
########################################

resource "oci_core_boot_volume" "this" {

  for_each = var.boot_volumes

  ########################################
  # Compartment
  ########################################

  compartment_id = coalesce(
    each.value.compartment_id,
    var.default_compartment_id
  )

  ########################################
  # Availability Domain
  ########################################

  availability_domain = each.value.availability_domain

  ########################################
  # Display Name
  ########################################

  display_name = coalesce(
    each.value.display_name,
    each.key
  )

  ########################################
  # Size
  #
  # Optional:
  # If omitted, source size is retained.
  ########################################

  size_in_gbs = each.value.size_in_gbs

  ########################################
  # Performance
  ########################################

  vpus_per_gb = each.value.vpus_per_gb

  ########################################
  # Encryption
  ########################################

  kms_key_id = each.value.kms_key_id

  ########################################
  # Source
  #
  # Existing Boot Volume Backup
  ########################################

  source_details {

    type = "bootVolumeBackup"

    id = each.value.source_backup_id

  }

  ########################################
  # Defined Tags
  ########################################

  defined_tags = merge(
    var.default_defined_tags,
    each.value.defined_tags
  )

  ########################################
  # Freeform Tags
  ########################################

  freeform_tags = merge(
    var.default_freeform_tags,
    each.value.freeform_tags
  )
}


########################################
# Boot Volume Backup Policy Assignment
#
# Assign an existing custom backup policy
# to the newly created Boot Volume.
########################################

resource "oci_core_volume_backup_policy_assignment" "this" {

  for_each = {
    for name, volume in var.boot_volumes :
    name => volume
    if try(volume.backup_policy_id, null) != null
  }

  ########################################
  # Boot Volume OCID
  ########################################

  asset_id = oci_core_boot_volume.this[
    each.key
  ].id

  ########################################
  # Existing Backup Policy OCID
  ########################################

  policy_id = each.value.backup_policy_id
}


########################################
# Manual Boot Volume Backups
#
# Scenario:
#
# Take multiple manual backups during
# patch / maintenance activities.
########################################

resource "oci_core_boot_volume_backup" "this" {

  for_each = var.boot_volume_backups

  ########################################
  # Source Boot Volume
  #
  # Can come from:
  #
  # 1. Direct boot_volume_id
  # 2. boot_volume_name resolved by locals
  ########################################

  boot_volume_id = local.manual_backup_source_boot_volume_ids[
    each.key
  ]

  ########################################
  # Backup Compartment
  ########################################

  compartment_id = coalesce(
    each.value.compartment_id,
    var.default_compartment_id
  )

  ########################################
  # Backup Display Name
  ########################################

  display_name = coalesce(
    each.value.display_name,
    "${each.key}-backup"
  )

  ########################################
  # Backup Type
  #
  # FULL
  # INCREMENTAL
  ########################################

  type = upper(
    each.value.type
  )

  ########################################
  # Encryption
  ########################################

  kms_key_id = each.value.kms_key_id

  ########################################
  # Defined Tags
  ########################################

  defined_tags = merge(
    var.default_defined_tags,
    each.value.defined_tags
  )

  ########################################
  # Freeform Tags
  ########################################

  freeform_tags = merge(
    var.default_freeform_tags,
    each.value.freeform_tags
  )
}
