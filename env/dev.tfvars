region = "ap-hyderabad-1"

environment = "dev"

default_compartment_id = ""

default_defined_tags = {
  CostCenter  = "IT"
  Environment = "dev"
}

default_freeform_tags = {
  ManagedBy = "Terraform"
}

########################################
# COMPUTE TEST
########################################

instances = {

  TEST_COMPUTE = {

    # Availability Domain
    ad = 0

    # Compute Shape
    shape = "VM.Standard3.Flex"

    ocpus         = 1
    memory_in_gbs = 8

    # Network
    subnet_id = ""

    assign_public_ip = false

    hostname_label = "test-compute"

    nsg_ids = []

    # Instance Source
    instance_source_type = "image"

    source_id = ""

    # Boot Volume
    boot_vol_size_gbs = 50

    preserve_boot_volume = true

    # SSH
    ssh_authorized_keys = []

  }

}
