########################################
# Block Volume
########################################

resource "oci_core_volume" "this" {
  for_each = var.block_volumes

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
  # Volume Size
  ########################################

  size_in_gbs = each.value.size_in_gbs

  ########################################
  # Volume Performance
  ########################################

  vpus_per_gb = each.value.vpus_per_gb

  ########################################
  # Encryption
  ########################################

  kms_key_id = each.value.kms_key_id

  ########################################
  # Volume Source
  #
  # empty:
  #   No source_details block.
  #
  # volume:
  #   Clone an existing Block Volume.
  #
  # volumeBackup:
  #   Create from an existing backup.
  ########################################

  dynamic "source_details" {
    for_each = contains(
      [
        "volume",
        "volumebackup"
      ],
      lower(each.value.source.type)
    ) ? [1] : []

    content {
      type = (
        lower(each.value.source.type) == "volumebackup"
      ) ? "volumeBackup" : "volume"

      id = each.value.source.id
    }
  }

  ########################################
  # Tags
  #
  # Temporarily disabled.
  # Enable when OCI tag configuration
  # is ready.
  ########################################

  # defined_tags  = var.default_defined_tags
  # freeform_tags = var.default_freeform_tags
}


########################################
# Existing Backup Policy Assignment
########################################

resource "oci_core_volume_backup_policy_assignment" "this" {
  for_each = {
    for name, volume in var.block_volumes :
    name => volume
    if try(volume.backup_policy_id, null) != null
  }

  ########################################
  # Volume to which policy is assigned
  ########################################

  asset_id = oci_core_volume.this[each.key].id

  ########################################
  # Existing Backup Policy OCID
  ########################################

  policy_id = each.value.backup_policy_id
}


########################################
# Manual Block Volume Backup
########################################

resource "oci_core_volume_backup" "this" {
  for_each = var.volume_backups

  ########################################
  # Source Volume
  ########################################

  volume_id = local.backup_volume_ids[each.key]

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
  ########################################

  type = upper(each.value.type)

  ########################################
  # Backup Encryption
  ########################################

  kms_key_id = each.value.kms_key_id

}


########################################
# iSCSI Volume Attachment
########################################

resource "oci_core_volume_attachment" "this" {
  for_each = var.volume_attachments

  ########################################
  # Volume
  ########################################

  volume_id = local.attachment_volume_ids[each.key]

  ########################################
  # Compute Instance
  ########################################

  instance_id = local.attachment_instance_ids[each.key]

  ########################################
  # Attachment Type
  ########################################

  attachment_type = lower(
    each.value.attachment_type
  )

  ########################################
  # Attachment Display Name
  ########################################

  display_name = each.value.display_name

  ########################################
  # Read Only
  ########################################

  is_read_only = each.value.is_read_only

  ########################################
  # Shareable
  ########################################

  is_shareable = each.value.is_shareable

  ########################################
  # CHAP
  ########################################

  use_chap = each.value.use_chap

  ########################################
  # Oracle Cloud Agent iSCSI Login
  ########################################

  is_agent_auto_iscsi_login_enabled = (
    each.value.is_agent_auto_iscsi_login_enabled
  )

  ########################################
  # Encryption in Transit
  ########################################

  encryption_in_transit_type = (
    each.value.encryption_in_transit_type
  )
}
