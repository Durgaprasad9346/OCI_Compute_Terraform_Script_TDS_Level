########################################
# Instance Details
########################################

output "instances" {

  description = "Compute Instance Details"

  value = {

    for k, v in oci_core_instance.this :

    k => {

      id                 = v.id
      display_name       = v.display_name
      availability_domain = v.availability_domain
      compartment_id     = v.compartment_id
      shape              = v.shape

      private_ip         = v.private_ip
      public_ip          = v.public_ip

      state              = v.state

    }

  }
}

########################################
# Instance OCIDs
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

    for k, v in oci_core_instance.this :

    k => v.private_ip

  }
}

########################################
# Public IPs
########################################

output "public_ips" {

  description = "Public IP Addresses"

  value = {

    for k, v in oci_core_instance.this :

    k => v.public_ip

  }
}

########################################
# Attached Block Volumes
########################################

output "block_volume_attachments" {

  description = "Block Volume Attachments"

  value = {

    for k, v in oci_core_volume_attachment.this :

    k => {

      volume_id       = v.volume_id
      instance_id     = v.instance_id
      attachment_type = v.attachment_type

    }

  }
}
