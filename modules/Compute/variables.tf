variable "environment" {
  type = string
}

variable "default_compartment_id" {
  type = string
}

variable "default_defined_tags" {
  type = map(string)
}

variable "default_freeform_tags" {
  type = map(string)
}

variable "instances" {

  type = map(object({

    ad = optional(number, 0)

    compartment_id = optional(string)

    fault_domain = optional(string)

    shape = string

    ocpus = optional(number)

    memory_in_gbs = optional(number)

    subnet_id = string

    assign_public_ip = optional(bool, false)

    private_ip = optional(string)

    hostname_label = optional(string)

    nsg_ids = optional(list(string), [])

    ssh_authorized_keys = list(string)

    user_data = optional(string)

    instance_source_type = optional(string, "image")

    source_id = string

    boot_vol_size_gbs = optional(number)

    preserve_boot_volume = optional(bool, true)

    kms_key_id = optional(string)

    defined_tags = optional(map(string), {})

    freeform_tags = optional(map(string), {})

    block_volumes = optional(list(object({

      volume_id = string

      attachment_type = optional(string, "iscsi")

    })), [])

  }))
}
