region = "ap-hyderabad-1"

environment = "dev"

default_compartment_id = "ocid1.tenancy.oc1..aaaaaaaafhdxwnqamamnvcsnmudrsskljf7ifls2yegl5rcgx4hllgthsm5q"

########################################
# Default Defined Tags
#######################################

default_defined_tags = {}

########################################
# Default Freeform Tags
########################################

default_freeform_tags = {
  ManagedBy   = "Terraform"
  CostCenter  = "IT"
  Environment = "dev"
}

########################################
# COMPUTE TEST
########################################

instances = {

  TEST_COMPUTE = {

    ########################################
    # Availability Domain
    ########################################

    ad = 0

    ########################################
    # Compute Shape
    ########################################

    shape = "VM.Standard3.Flex"

    ocpus         = 1
    memory_in_gbs = 8

    ########################################
    # Network
    ########################################

    subnet_id = "ocid1.subnet.oc1.ap-hyderabad-1.aaaaaaaajhuqe7jh4lnr2byjvcf4yp45bsf7qsn3wduaqpmf5ggl4zkdxd7a"

    assign_public_ip = false

    hostname_label = "test-compute"

    nsg_ids = []

    ########################################
    # Instance Source
    ########################################

    instance_source_type = "image"

    source_id = "ocid1.image.oc1.ap-hyderabad-1.aaaaaaaa5atcr2tugcttq7pyapjudk6wi7ojvejrjxxz4pqzmxeoljk4hxha"

    ########################################
    # Boot Volume
    ########################################

    boot_vol_size_gbs = 50

    preserve_boot_volume = true

    ########################################
    # Encryption
    ########################################

    kms_key_id = null

    ########################################
    # Secure Boot
    #
    # C1 = Custom Image Test
    ########################################

    secure_boot_enabled = true

    ########################################
    # SSH
    ########################################

    ssh_authorized_keys = []

    ########################################
    # User Data
    ########################################

    user_data = null

    ########################################
    # Instance-level Tags
    ########################################

    defined_tags = {}

    freeform_tags = {}

    ########################################
    # Block Volumes
    #
    # C1 is Compute-only.
    ########################################

    block_volumes = []

  }

}
