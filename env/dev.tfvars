region = "ap-hyderabad-1"

environment = "dev"

default_compartment_id = "ocid1.compartment.oc1.xxxxx"

default_defined_tags = {
  CostCenter = "IT"
}

default_freeform_tags = {
  ManagedBy = "Terraform"
}

instances = {

  app01 = {

    ad = 0

    shape = "VM.Standard.E5.Flex"

    ocpus = 1

    memory_in_gbs = 8

    subnet_id = "ocid1.subnet.oc1.xxxxx"

    assign_public_ip = false

    hostname_label = "app01"

    source_id = "ocid1.image.oc1.xxxxx"

    boot_vol_size_gbs = 100

    preserve_boot_volume = true

    ssh_authorized_keys = [
      "./keys/id_rsa.pub"
    ]

  }

}
