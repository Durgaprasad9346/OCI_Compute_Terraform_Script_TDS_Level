########################################
# Boot Volume Details
########################################

output "boot_volumes" {

  description = "Details of Boot Volumes created by this module."

  value = {
    for name, volume in oci_core_boot_volume.this :
    name => {
      id                  = volume.id
      display_name        = volume.display_name
      compartment_id      = volume.compartment_id
      availability_domain = volume.availability_domain
      size_in_gbs         = volume.size_in_gbs
      vpus_per_gb         = volume.vpus_per_gb
      state               = volume.state
    }
  }
}


########################################
# Boot Volume IDs
#
# Used by the Compute module to create
# a server from the newly created
# Boot Volume.
########################################

output "boot_volume_ids" {

  description = "Map of logical Boot Volume names to OCI Boot Volume OCIDs."

  value = {
    for name, volume in oci_core_boot_volume.this :
    name => volume.id
  }
}


########################################
# Backup Policy Assignments
########################################

output "backup_policy_assignments" {

  description = "Boot Volume backup policy assignments."

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
# Manual Boot Volume Backups
########################################

output "boot_volume_backups" {

  description = "Details of manual Boot Volume backups created by this module."

  value = {
    for name, backup in oci_core_boot_volume_backup.this :
    name => {
      id             = backup.id
      display_name   = backup.display_name
      boot_volume_id = backup.boot_volume_id
      compartment_id = backup.compartment_id
      type           = backup.type
      state          = backup.state
    }
  }
}


########################################
# Manual Boot Volume Backup IDs
########################################

output "boot_volume_backup_ids" {

  description = "Map of logical backup names to OCI Boot Volume Backup OCIDs."

  value = {
    for name, backup in oci_core_boot_volume_backup.this :
    name => backup.id
  }
}
