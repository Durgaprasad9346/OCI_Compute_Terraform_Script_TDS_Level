########################################
# OCI Region
########################################

region = "ap-hyderabad-1"


########################################
# Environment
########################################

environment = "dev"


########################################
# Cross-Region Replication
########################################

enable_cross_region_replication = false


########################################
# Default Compartment
########################################

default_compartment_id = "ocid1.tenancy.oc1..aaaaaaaafhdxwnqamamnvcsnmudrsskljf7ifls2yegl5rcgx4hllgthsm5q"


########################################
# Defined Tags
#
# Use the allowed value configured in
# your OCI maxlife namespace.
########################################

default_defined_tags = {
  "maxlife.Project" = "DAKS"
}


########################################
# Freeform Tags
########################################

default_freeform_tags = {
  ManagedBy   = "Terraform"
  Environment = "dev"
}


########################################
# Compute Instance
#
# Custom image + Secure Boot
########################################

instances = {

  "test-server" = {

    ad = 0

    shape = "VM.Standard3.Flex"

    ocpus         = 1
    memory_in_gbs = 8

    subnet_id = "ocid1.subnet.oc1.ap-hyderabad-1.aaaaaaaajhuqe7jh4lnr2byjvcf4yp45bsf7qsn3wduaqpmf5ggl4zkdxd7a"

    assign_public_ip = false

    hostname_label = "test-server"

    nsg_ids = []

    ######################################
    # Custom Image
    ######################################

    instance_source_type = "image"

    source_id = "ocid1.image.oc1.ap-hyderabad-1.aaaaaaaa5atcr2tugcttq7pyapjudk6wi7ojvejrjxxz4pqzmxeoljk4hxha"

    boot_vol_size_gbs = 50

    preserve_boot_volume = true

    ######################################
    # Secure Boot
    ######################################

    secure_boot_enabled = true

    ######################################
    # Resource Tags
    ######################################

    defined_tags = {}

    freeform_tags = {}

    ######################################
    # Attachments handled by Block Storage
    ######################################

    block_volumes = []

  }

}


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
# Create two new empty volumes.
# Do not clone an existing volume.
########################################

block_volumes = {

  "test-block-volume-01" = {

    availability_domain = "xIzJ:AP-HYDERABAD-1-AD-1"

    display_name = "test-block-volume-01"

    size_in_gbs = 100

    vpus_per_gb = 10

    source = {
      type = "empty"
    }

    backup_policy_id = "ocid1.volumebackuppolicy.oc1.ap-hyderabad-1.amaaaaaabzzfkaiat7mqsvgt2lzt3fwvjwa557yutk6jtvtjtsot7flxwpta"

  }

  "test-block-volume-02" = {

    availability_domain = "xIzJ:AP-HYDERABAD-1-AD-1"

    display_name = "test-block-volume-02"

    size_in_gbs = 100

    vpus_per_gb = 10

    source = {
      type = "empty"
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

volume_attachments = {

  "test-server-data-01" = {

    volume_name   = "test-block-volume-01"
    instance_name = "test-server"

    attachment_type = "iscsi"

  }

  "test-server-data-02" = {

    volume_name   = "test-block-volume-02"
    instance_name = "test-server"

    attachment_type = "iscsi"

  }

}
