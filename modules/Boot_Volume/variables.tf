########################################
# Default Compartment
########################################

variable "default_compartment_id" {
  description = "Default OCI compartment OCID."
  type        = string
}

########################################
# Default Defined Tags
########################################

variable "default_defined_tags" {
  description = "Default OCI defined tags."
  type        = map(string)
  default     = {}
}

########################################
# Default Freeform Tags
########################################

variable "default_freeform_tags" {
  description = "Default OCI freeform tags."
  type        = map(string)
  default     = {}
}

########################################
# Boot Volumes
#
# Scenario:
#
# Create a new Boot Volume from an
# existing scheduled Boot Volume Backup.
#
# The resulting Boot Volume OCID can
# later be consumed by the Compute
# module to create a replacement server.
########################################

variable "boot_volumes" {

  description = "Boot Volumes created from existing Boot Volume Backups."

  type = map(object({

    ########################################
    # Placement
    ########################################

    compartment_id = optional(string)

    availability_domain = string

    ########################################
    # Boot Volume Configuration
    ########################################

    display_name = optional(string)

    size_in_gbs = optional(number)

    vpus_per_gb = optional(number, 10)

    ########################################
    # Encryption
    #
    # null / omitted:
    # OCI-managed encryption
    #
    # OCID:
    # Customer-managed Vault key
    ########################################

    kms_key_id = optional(string)

    ########################################
    # Existing Backup Policy
    #
    # Existing custom OCI Backup Policy
    # based on server priority.
    ########################################

    backup_policy_id = optional(string)

    ########################################
    # Boot Volume Backup Source
    ########################################

    source_backup_id = string

    ########################################
    # Resource-specific Defined Tags
    ########################################

    defined_tags = optional(map(string), {})

    ########################################
    # Resource-specific Freeform Tags
    ########################################

    freeform_tags = optional(map(string), {})

  }))

  default = {}

  ########################################
  # Source Backup OCID Validation
  ########################################

  validation {

    condition = alltrue([
      for name, volume in var.boot_volumes :
      trimspace(volume.source_backup_id) != ""
    ])

    error_message = "source_backup_id must contain a Boot Volume Backup OCID."

  }

  ########################################
  # Boot Volume Size Validation
  ########################################

  validation {

    condition = alltrue([
      for name, volume in var.boot_volumes :
      (
        volume.size_in_gbs == null
        ||
        (
          volume.size_in_gbs >= 50
          &&
          volume.size_in_gbs <= 32768
        )
      )
    ])

    error_message = "Boot Volume size_in_gbs must be between 50 GB and 32768 GB when specified."

  }

  ########################################
  # Boot Volume Performance Validation
  ########################################

  validation {

    condition = alltrue([
      for name, volume in var.boot_volumes :
      contains(
        concat(
          [10, 20],
          range(30, 121)
        ),
        volume.vpus_per_gb
      )
    ])

    error_message = "Boot Volume vpus_per_gb must be 10, 20, or between 30 and 120."

  }

}

########################################
# Manual Boot Volume Backups
#
# Scenario:
#
# Take multiple manual Boot Volume
# backups during patch / maintenance.
########################################

variable "boot_volume_backups" {

  description = "Manual Boot Volume backup definitions."

  type = map(object({

    ########################################
    # Source Boot Volume
    #
    # Exactly one:
    #
    # boot_volume_id
    # OR
    # boot_volume_name
    ########################################

    boot_volume_id = optional(string)

    boot_volume_name = optional(string)

    ########################################
    # OCI Backup Display Name
    #
    # Example:
    #
    # APP01-Patch-Backup-2026-10-06
    ########################################

    display_name = optional(string)

    ########################################
    # Backup Type
    #
    # FULL
    # INCREMENTAL
    ########################################

    type = optional(string, "FULL")

    ########################################
    # Backup Compartment
    ########################################

    compartment_id = optional(string)

    ########################################
    # Encryption
    #
    # null / omitted:
    # OCI-managed encryption
    #
    # OCID:
    # Customer-managed Vault key
    ########################################

    kms_key_id = optional(string)

    ########################################
    # Resource-specific Defined Tags
    ########################################

    defined_tags = optional(map(string), {})

    ########################################
    # Resource-specific Freeform Tags
    ########################################

    freeform_tags = optional(map(string), {})

  }))

  default = {}

  ########################################
  # Backup Source Validation
  #
  # Exactly one of:
  #
  # boot_volume_id
  # boot_volume_name
  ########################################

  validation {

    condition = alltrue([
      for name, backup in var.boot_volume_backups :
      (
        try(backup.boot_volume_id, null) != null
        &&
        try(backup.boot_volume_name, null) == null
      )
      ||
      (
        try(backup.boot_volume_id, null) == null
        &&
        try(backup.boot_volume_name, null) != null
      )
    ])

    error_message = "Each Boot Volume backup must specify exactly one of boot_volume_id or boot_volume_name."

  }

  ########################################
  # Backup Type Validation
  ########################################

  validation {

    condition = alltrue([
      for name, backup in var.boot_volume_backups :
      contains(
        [
          "FULL",
          "INCREMENTAL"
        ],
        upper(backup.type)
      )
    ])

    error_message = "Boot Volume backup type must be FULL or INCREMENTAL."

  }

}
