########################################
# Complete Instance Details
########################################

output "instances" {

  description = "Compute Instance Details"

  value = {

    for k, v in oci_core_instance.this :

    k => {

      id                  = v.id

      display_name        = v.display_name

      compartment_id      = v.compartment_id

      availability_domain = v.availability_domain

      shape               = v.shape

      state               = v.state

      private_ip = data.oci_core_vnic.this[
        k
      ].private_ip_address

      public_ip = try(
        data.oci_core_vnic.this[
          k
        ].public_ip_address,
        null
      )

    }

  }

}

########################################
# Instance IDs
########################################

output "instance_ids" {

  description = "Instance OCIDs"

  value = {

    for k, v in oci_core_instance.this :

    k => v.id

  }

}

########################################
# Private IPs
########################################

output "private_ips" {

  description = "Private IP Addresses"

  value = {

    for k, v in data.oci_core_vnic.this :

    k => v.private_ip_address

  }

}

########################################
# Public IPs
########################################

output "public_ips" {

  description = "Public IP Addresses"

  value = {

    for k, v in data.oci_core_vnic.this :

    k => try(
      v.public_ip_address,
      null
    )

  }

}

########################################
# Block Volume Attachments
########################################

output "block_volume_attachments" {

  description = "Block Volume Attachment Details"

  value = {

    for k, v in oci_core_volume_attachment.this :

    k => {

      volume_id       = v.volume_id

      instance_id     = v.instance_id

      attachment_type = v.attachment_type

    }

  }

}
