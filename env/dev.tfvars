########################################
# OCI Region
########################################

region = "ap-hyderabad-1"


########################################
# Environment
########################################

environment = "dev"


########################################
# Default Compartment
########################################

default_compartment_id = "ocid1.tenancy.oc1..aaaaaaaafhdxwnqamamnvcsnmudrsskljf7ifls2yegl5rcgx4hllgthsm5q"


########################################
# Tags
#
# Temporarily disabled.
########################################

# default_defined_tags = {
#   "maxlife.project" = "dmz"
# }

# default_freeform_tags = {
#   CostCenter  = "IT"
#   Environment = "dev"
# }


########################################
# Compute Instances
#
# Not testing Compute now.
########################################

instances = {}


########################################
# Boot Volumes
#
# Not creating/restoring Boot Volumes now.
########################################

boot_volumes = {}


########################################
# Manual Boot Volume Backups
#
# Multiple existing Boot Volumes can be
# backed up in one Terraform apply.
########################################

boot_volume_backups = {

  ########################################
  # Boot Volume 1
  ########################################

  "test-boot-backup-01" = {

    boot_volume_id = "ocid1.bootvolume.oc1.ap-hyderabad-1.abuhsljrjr7jhbhxrjxgmhxh7lhnrcwzcnqyjr6efilbyxurtja5ph44ijfa"

    display_name = "test--compute-boot-backup-01"

    type = "FULL"

  }


  ########################################
  # Boot Volume 2
  ########################################

  "test-boot-backup-02" = {

    boot_volume_id = "ocid1.bootvolume.oc1.ap-hyderabad-1.abuhsljrtv337jvzz5vmtnu46xbhf64pt2qw6lur3ezv62jqmithpzs7kp7a"

    display_name = "test-compute-01-boot-backup-02"

    type = "FULL"

  }


  ########################################
  # Boot Volume 3
  ########################################

  #"test-boot-backup-03" = {

   # boot_volume_id = "YOUR_BOOT_VOLUME_OCID_03"

    #display_name = "test-boot-backup-03"

    #type = "FULL"

  #}

}


########################################
# Block Volumes
#
# Not testing Block Storage now.
########################################

block_volumes = {}


########################################
# Manual Block Volume Backups
########################################

volume_backups = {}


########################################
# Block Volume Attachments
########################################

volume_attachments = {}
