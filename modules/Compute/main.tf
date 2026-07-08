########################################
# Availability Domains
########################################

data "oci_identity_availability_domains" "this" {
  compartment_id = var.default_compartment_id
}

########################################
# Compute Instances
########################################

resource "oci_core_instance" "this" {

  for_each = var.instances

  availability_domain = data.oci_identity_availability_domains.this.availability_domains[each.value.ad].name

  compartment_id = coalesce(
    each.value.compartment_id,
    var.default_compartment_id
  )

  display_name = each.key

  shape = each.value.shape

  fault_domain = each.value.fault_domain

  ########################################
  # Primary VNIC
  ########################################

  create_vnic_details {

    subnet_id = each.value.subnet_id

    assign_public_ip = each.value.assign_public_ip

    private_ip = each.value.private_ip

    hostname_label = each.value.hostname_label

    nsg_ids = each.value.nsg_ids

  }

  ########################################
  # Flex Shape Support
  ########################################

  dynamic "shape_config" {

    for_each = (
      each.value.ocpus != null &&
      each.value.memory_in_gbs != null
    ) ? [1] : []

    content {

      ocpus = each.value.ocpus

      memory_in_gbs = each.value.memory_in_gbs

    }
  }

  ########################################
  # Metadata
  ########################################

  metadata = {

    ssh_authorized_keys = join(
      "\n",
      [
        for key in each.value.ssh_authorized_keys :
        chomp(file(key))
      ]
    )

    user_data = each.value.user_data

  }

  ########################################
  # Source Details
  ########################################

  source_details {

    source_type = (
      each.value.instance_source_type == "boot_volume"
    ) ? "bootVolume" : "image"

    source_id = each.value.source_id

    boot_volume_size_in_gbs = each.value.boot_vol_size_gbs

    kms_key_id = each.value.kms_key_id

  }

  ########################################
  # Boot Volume
  ########################################

  preserve_boot_volume = each.value.preserve_boot_volume

  ########################################
  # Tags
  ########################################

  defined_tags = merge(
    var.default_defined_tags,
    each.value.defined_tags
  )

  freeform_tags = merge(
    var.default_freeform_tags,
    each.value.freeform_tags
  )
}

########################################
# Block Volume Attachments
########################################

resource "oci_core_volume_attachment" "this" {

  for_each = {

    for vol in local.block_volume_attachments :

    "${vol.instance_name}-${vol.volume_id}" => vol

  }

  attachment_type = each.value.attachment_type

  instance_id = oci_core_instance.this[
    each.value.instance_name
  ].id

  volume_id = each.value.volume_id

}

########################################
# Primary VNIC Information
########################################

data "oci_core_vnic_attachments" "this" {

  for_each = oci_core_instance.this

  compartment_id = each.value.compartment_id

  instance_id = each.value.id

  depends_on = [
    oci_core_instance.this
  ]

}

data "oci_core_vnic" "this" {

  for_each = oci_core_instance.this

  vnic_id = data.oci_core_vnic_attachments.this[
    each.key
  ].vnic_attachments[0].vnic_id

}
