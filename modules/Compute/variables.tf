variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "default_compartment_id" {
  description = "Default compartment OCID"
  type        = string
}

variable "default_defined_tags" {
  description = "Default defined tags"
  type        = map(string)
  default     = {}
}

variable "default_freeform_tags" {
  description = "Default freeform tags"
  type        = map(string)
  default     = {}
}

variable "instances" {
  description = "Compute instance configuration"

  type = map(object({

    # Availability / Placement
    ad = optional(number, 0)

    compartment_id = optional(string)

    fault_domain = optional(string)

    # Compute Shape
    shape = string

    ocpus         = optional(number)
    memory_in_gbs = optional(number)

    # Primary VNIC
    subnet_id = string

    assign_public_ip = optional(bool, false)

    private_ip = optional(string)

    hostname_label = optional(string)

    nsg_ids = optional(list(string), [])

    # SSH
    # For imported instances, metadata management can remain disabled.
    ssh_authorized_keys = optional(list(string), [])

    # Controls whether Terraform manages SSH/user-data metadata.
    # false = adoption/import mode
    # true  = new resource provisioning mode
    manage_metadata = optional(bool, false)

    # User Data
    user_data = optional(string)

    # Instance Source
    instance_source_type = optional(string, "image")

    source_id = optional(string)

    boot_vol_size_gbs = optional(number)

    preserve_boot_volume = optional(bool, true)

    kms_key_id = optional(string)

    # Tags
    defined_tags = optional(map(string), {})

    freeform_tags = optional(map(string), {})

    # Block Volume Attachments
    # Will be used in a later phase.
    block_volumes = optional(list(object({

      volume_id = string

      attachment_type = optional(string, "iscsi")

    })), [])

  }))
}
