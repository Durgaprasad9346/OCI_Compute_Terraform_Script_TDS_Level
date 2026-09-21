########################################
# Block Volume Details
########################################

output "volumes" {

  description = "Details of Block Volumes created by the module."

  value = {

    for name, volume in oci_core_volume.this :

    name => {

      id                  = volume.id
      display_name        = volume.display_name
      compartment_id      = volume.compartment_id
      availability_domain = volume.availability_domain
      size_in_gbs         = volume.size_in_gbs
      vpus_per_gb         = volume.vpus_per_gb
      state               = volume.state
      time_created        = volume.time_created

    }

  }
}


########################################
# Block Volume OCIDs
########################################

output "volume_ids" {

  description = "Map of Block Volume logical names to OCI Volume OCIDs."

  value = {

    for name, volume in oci_core_volume.this :

    name => volume.id

  }
}


########################################
# Backup Policy Assignments
########################################

output "backup_policy_assignments" {

  description = "Details of Block Volume backup policy assignments."

  value = {

    for name, assignment in oci_core_volume_backup_policy_assignment.this :

    name => {

      id        = assignment.id
      asset_id  = assignment.asset_id
      policy_id = assignment.policy_id

    }

  }
}


########################################
# Volume Backup Details
########################################

output "volume_backups" {

  description = "Details of Block Volume backups created by the module."

  value = {

    for name, backup in oci_core_volume_backup.this :

    name => {

      id                 = backup.id
      display_name       = backup.display_name
      volume_id          = backup.volume_id
      type               = backup.type
      state              = backup.state
      size_in_gbs        = backup.size_in_gbs
      unique_size_in_gbs = backup.unique_size_in_gbs
      time_created       = backup.time_created
      expiration_time    = backup.expiration_time

    }

  }
}


########################################
# Volume Backup OCIDs
########################################

output "volume_backup_ids" {

  description = "Map of backup logical names to OCI Volume Backup OCIDs."

  value = {

    for name, backup in oci_core_volume_backup.this :

    name => backup.id

  }
}


########################################
# Volume Attachment Details
########################################

output "volume_attachments" {

  description = "Details of Block Volume attachments."

  value = {

    for name, attachment in oci_core_volume_attachment.this :

    name => {

      id              = attachment.id
      volume_id       = attachment.volume_id
      instance_id     = attachment.instance_id
      attachment_type = attachment.attachment_type
      state           = attachment.state

    }

  }
}
