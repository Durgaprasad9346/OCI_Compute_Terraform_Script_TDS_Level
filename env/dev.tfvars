instances = {

  app01 = {

    shape = "VM.Standard.E5.Flex"

    ocpus = 1

    memory_in_gbs = 8

    subnet_id = "ocid1.subnet..."

    source_id = "ocid1.image..."

    ssh_authorized_keys = [
      "./keys/app01.pub"
    ]
  }

}
