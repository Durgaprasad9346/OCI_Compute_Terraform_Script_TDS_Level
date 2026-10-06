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
# Default Defined Tags
########################################

default_defined_tags = {
  "maxlife.project" = "dmz"
}


########################################
# Default Freeform Tags
########################################

default_freeform_tags = {
  CostCenter  = "IT"
  Environment = "dev"
}


########################################
# Compute Instances
########################################

instances = {

  "test-server" = {

    ######################################
    # Availability Domain
    ######################################

    ad = 0


    ######################################
    # Compute Shape
    ######################################

    shape = "VM.Standard3.Flex"

    ocpus         = 1
    memory_in_gbs = 8


    ######################################
    # Network
    ######################################

    subnet_id = "ocid1.subnet.oc1.ap-hyderabad-1.aaaaaaaajhuqe7jh4lnr2byjvcf4yp45bsf7qsn3wduaqpmf5ggl4zkdxd7a"

    assign_public_ip = false

    hostname_label = "test-server-bv-bkp"

    nsg_ids = []


    ######################################
    # Instance Source
    ######################################

    instance_source_type = "bootVolume"

    boot_volume_name = "test-boot"


    ######################################
    # Boot Volume
    ######################################

    preserve_boot_volume = true


    ######################################
    # Secure Boot
    ######################################

    secure_boot_enabled = true


    ######################################
    # Resource-specific Tags
    ######################################

    defined_tags = {}

    freeform_tags = {}


    ######################################
    # Block Volumes
    #
    # Not testing Block Storage yet.
    ######################################

    block_volumes = []

  }

}


########################################
# Boot Volumes
########################################

boot_volumes = {

  "test-boot" = {

    ######################################
    # Availability Domain
    ######################################

    availability_domain = "xIzJ:AP-HYDERABAD-1-AD-1"


    ######################################
    # OCI Display Name
    ######################################

    display_name = "test-server-boot"


    ######################################
    # Existing Boot Volume Backup
    ######################################

    source_backup_id = "ocid1.bootvolumebackup.oc1.ap-hyderabad-1.abuhsljrsyyxwuanfax4udib65rqstb2ansfbvrk4mpu7sll7ce6kduv5ptq"


    ######################################
    # Boot Volume Performance
    ######################################

    vpus_per_gb = 10


    ######################################
    # Resource-specific Tags
    ######################################

    defined_tags = {}

    freeform_tags = {}

  }

}


########################################
# Manual Boot Volume Backups
#
# Not testing now.
########################################

boot_volume_backups = {}


########################################
# Block Volumes
#
# Not testing now.
########################################

block_volumes = {}


########################################
# Manual Block Volume Backups
#
# Not testing now.
########################################

volume_backups = {}


########################################
# Block Volume Attachments
#
# Not testing now.
########################################

volume_attachments = {}
