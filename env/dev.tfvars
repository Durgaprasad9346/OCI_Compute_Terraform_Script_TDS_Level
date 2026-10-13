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
# Tags - Temporarily Disabled
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
########################################

instances = {}

########################################
# Boot Volumes
########################################

boot_volumes = {}

########################################
# Manual Boot Volume Backups
########################################

boot_volume_backups = {}

########################################
# Block Volumes
#
# Create a new Block Volume and assign
# an existing custom backup policy.
########################################

block_volumes = {
  "test-block-volume" = {
    availability_domain = "xIzJ:AP-HYDERABAD-1-AD-1"
    display_name        = "test-block-volume"
    size_in_gbs         = 100
    vpus_per_gb         = 10

    source = {
      type = "volume"
      id: "ocid1.volume.oc1.ap-hyderabad-1.abuhsljrgfaktulbh3b4oo5tsfph7zgjow7sbx5mpt6tuo6dtib5eyodpuwq"
    }

    backup_policy_id = "ocid1.volumebackuppolicy.oc1.ap-hyderabad-1.amaaaaaabzzfkaiat7mqsvgt2lzt3fwvjwa557yutk6jtvtjtsot7flxwpta"
  }
}

########################################
# Manual Block Volume Backups
########################################

volume_backups = {}

########################################
# Block Volume Attachments
########################################

volume_attachments = {}
