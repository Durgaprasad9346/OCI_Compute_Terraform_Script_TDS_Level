region = "ap-hyderabad-1"

environment = "dev"

default_compartment_id = "ocid1.compartment.oc1..aaaaaaaagzp6vtpqdhc6zoq2fq7qfogi3esw6upczmyz5eu544wdkwuot5wa"

default_defined_tags = {
  CostCenter  = "IT"
  Environment = "dev"
}

default_freeform_tags = {
  ManagedBy = "Terraform"
}

instances = {

  AUTOMATION_VM = {

    ad = 0

    shape = "VM.Standard3.Flex"

    ocpus = 1

    memory_in_gbs = 8

    subnet_id = "ocid1.subnet.oc1.ap-hyderabad-1.aaaaaaaa4tbbqgeqtrl5av7txggtmpi7ehjpzbzfxvpxjdwbnp7fbttzilwa"

    assign_public_ip = false

    private_ip = "10.81.245.131"

    hostname_label = "automation-vm"

    nsg_ids = [
      "ocid1.networksecuritygroup.oc1.ap-hyderabad-1.aaaaaaaatn52awpklwsl7kkhgud3l2bznnfkf43hwjqytv7axtn5zem3moma",
      "ocid1.networksecuritygroup.oc1.ap-hyderabad-1.aaaaaaaasn7zvz3x2ukwuj5fltbv3cwqkpo4n3vaqv4czq6xmvqatiybnxaq",
      "ocid1.networksecuritygroup.oc1.ap-hyderabad-1.aaaaaaaayzcpgi323giywesfchddspwf5p3fwhtfcrinbunrpvjmeizzjv2a"
    ]

    instance_source_type = "image"

    source_id = "ocid1.image.oc1.ap-hyderabad-1.aaaaaaaa6xyf6ag6zinwtpknixxlu6mjdjfbiowjefkkxscjmelfs2mmmg6a"

    boot_vol_size_gbs = 47

    preserve_boot_volume = true

    # Intentionally empty.
    # Existing SSH key on the server is not managed by Terraform.
    ssh_authorized_keys = []

  }

}
