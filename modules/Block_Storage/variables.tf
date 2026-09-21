########################################
# Default Compartment
########################################

variable "default_compartment_id" {

  description = "Default OCI compartment OCID"

  type = string

}


########################################
# Block Volumes
########################################

variable "block_volumes" {

  description = "Block Volume definitions"

  type = map(object({

    ########################################
    # Placement
    ########################################

    compartment_id = optional(string)

    availability_domain = string


    ########################################
    # Volume Configuration
    ########################################

    display_name = optional(string)

    size_in_gbs = number

    vpus_per_gb = optional(number, 10)


    ########################################
    # Encryption
    #
    # Omitted / null:
    # OCI uses Oracle-managed encryption keys.
    #
    # OCID supplied:
    # OCI uses the customer-managed Vault key.
    ########################################

    kms_key_id = optional(string)


    ########################################
    # Volume Source
    #
    # Supported:
    #
    # empty
    # volumeBackup
    ########################################

    source = optional(object({

      type = optional(string, "empty")

      id = optional(string)

    }), {})


    ########################################
    # Existing Backup Policy
    #
    # Existing OCI Volume Backup Policy OCID
    ########################################

    backup_policy_id = optional(string)


    ########################################
    # Destruction Protection
    #
    # Default: false
    ########################################

    prevent_destroy = optional(bool, false)

  }))

  default = {}


  ########################################
  # Source Type Validation
  ########################################

  validation {

    condition = alltrue([

      for name, volume in var.block_volumes :

      contains(
        [
          "empty",
          "volumebackup"
        ],
        lower(volume.source.type)
      )

    ])

    error_message = "Block Volume source.type must be either 'empty' or 'volumeBackup'."

  }


  ########################################
  # Volume Backup Source Validation
  ########################################

  validation {

    condition = alltrue([

      for name, volume in var.block_volumes :

      lower(volume.source.type) == "empty"
      ||
      (
        lower(volume.source.type) == "volumebackup"
        &&
        try(volume.source.id, null) != null
      )

    ])

    error_message = "When source.type is 'volumeBackup', source.id must contain a Block Volume Backup OCID."

  }


  ########################################
  # Volume Size Validation
  ########################################

  validation {

    condition = alltrue([

      for name, volume in var.block_volumes :

      volume.size_in_gbs >= 50
      &&
      volume.size_in_gbs <= 32768

    ])

    error_message = "Block Volume size_in_gbs must be between 50 GB and 32768 GB."

  }


  ########################################
  # VPU Validation
  ########################################

  validation {

    condition = alltrue([

      for name, volume in var.block_volumes :

      contains(
        concat(
          [0, 10, 20],
          range(30, 121)
        ),
        volume.vpus_per_gb
      )

    ])

    error_message = "vpus_per_gb must be 0, 10, 20, or between 30 and 120."

  }

}
