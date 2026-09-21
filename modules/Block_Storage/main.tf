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
  #
  # Null / omitted:
  # OCI Oracle-managed encryption
  #
  # OCID supplied:
  # Customer-managed Vault key
  ########################################

  kms_key_id = each.value.kms_key_id


  ########################################
  # Volume Source
  #
  # Empty:
  # No source_details block is created.
  #
  # Volume Backup:
  # Restore the new volume from the
  # supplied Block Volume Backup OCID.
  ########################################

  dynamic "source_details" {

    for_each = lower(each.value.source.type) == "volumebackup"
      ? [1]
      : []

    content {

      type = "volumeBackup"

      id = each.value.source.id

    }

  }

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

  asset_id = oci_core_volume.this[
    each.key
  ].id


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

  volume_id = local.backup_volume_ids[
    each.key
  ]


  ########################################
  # Backup Compartment
  #
  # Uses the supplied backup compartment
  # when provided.
  #
  # Otherwise uses the module default.
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

  type = upper(
    each.value.type
  )


  ########################################
  # Backup Encryption
  #
  # Null / omitted:
  # OCI Oracle-managed encryption
  #
  # OCID supplied:
  # Customer-managed Vault key
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

  volume_id = local.attachment_volume_ids[
    each.key
  ]


  ########################################
  # Compute Instance
  ########################################

  instance_id = local.attachment_instance_ids[
    each.key
  ]


  ########################################
  # Attachment Type
  #
  # Our module currently supports iSCSI.
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
