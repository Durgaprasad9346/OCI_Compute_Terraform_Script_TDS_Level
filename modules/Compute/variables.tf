########################################
# Environment
########################################

variable "environment" {

  description = "Deployment environment"

  type = string

}


########################################
# Default Compartment
########################################

variable "default_compartment_id" {

  description = "Default compartment OCID"

  type = string

}


########################################
# Default Defined Tags
########################################

variable "default_defined_tags" {

  description = "Default defined tags"

  type = map(string)

  default = {}

}


########################################
# Default Freeform Tags
########################################

variable "default_freeform_tags" {

  description = "Default freeform tags"

  type = map(string)

  default = {}

}


########################################
# Compute Instances
########################################

variable "instances" {

  description = "Compute instance configuration"

  type = map(object({

    ########################################
    # Availability / Placement
    ########################################

    ad = optional(number, 0)

    compartment_id = optional(string)

    fault_domain = optional(string)


    ########################################
    # Compute Shape
    ########################################

    shape = string

    ocpus         = optional(number)

    memory_in_gbs = optional(number)


    ########################################
    # Primary VNIC
    ########################################

    subnet_id = string

    assign_public_ip = optional(bool, false)

    private_ip = optional(string)

    hostname_label = optional(string)

    nsg_ids = optional(list(string), [])


    ########################################
    # SSH
    #
    # Retained for variable compatibility,
    # but NOT used by main.tf.
    ########################################

    ssh_authorized_keys = optional(list(string), [])


    ########################################
    # User Data
    ########################################

    user_data = optional(string)


    ########################################
    # Instance Source
    #
    # image
    # bootVolume
    ########################################

    instance_source_type = optional(string, "image")

    source_id = optional(string)


    ########################################
    # Boot Volume Reference
    #
    # Used when:
    #
    # instance_source_type = "bootVolume"
    #
    # Example:
    #
    # boot_volume_name = "APP01_RECOVERY"
    #
    # Root main.tf uses this logical
    # name to retrieve the Boot Volume
    # OCID from the Boot_Volume module.
    ########################################

    boot_volume_name = optional(string)


    ########################################
    # Boot Volume Configuration
    #
    # Used when OCI creates the boot
    # volume automatically from an image.
    ########################################

    boot_vol_size_gbs = optional(number)

    preserve_boot_volume = optional(bool, true)

    kms_key_id = optional(string)


    ########################################
    # Secure Boot
    ########################################

    secure_boot_enabled = optional(bool, true)


    ########################################
    # Tags
    ########################################

    defined_tags = optional(map(string), {})

    freeform_tags = optional(map(string), {})


    ########################################
    # Block Volume Attachments
    ########################################

    block_volumes = optional(list(object({

      volume_id = string

      attachment_type = optional(string, "iscsi")

    })), [])

  }))

}
