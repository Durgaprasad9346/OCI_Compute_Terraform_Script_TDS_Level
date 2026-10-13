########################################
# Default Compartment
########################################

variable "default_compartment_id" {
  description = "Default OCI compartment OCID"
  type        = string
}


########################################
# Default Defined Tags
#
# Retained for future tag enablement.
########################################

variable "default_defined_tags" {
  description = "Default OCI defined tags"
  type        = map(string)
  default     = {}
}


########################################
# Default Freeform Tags
#
# Retained for future tag enablement.
########################################

variable "default_freeform_tags" {
  description = "Default OCI freeform tags"
  type        = map(string)
  default     = {}
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

    compartment_id      = optional(string)
    availability_domain = string

    ########################################
    # Volume Configuration
    ########################################

    display_name = optional(string)
    size_in_gbs  = number
    vpus_per_gb  = optional(number, 10)

    ########################################
    # Encryption
    #
    # Omitted: OCI-managed encryption
    # Supplied: Customer-managed Vault key
    ########################################

    kms_key_id = optional(string)

    ########################################
    # Volume Source
    #
    # empty
    # volume
    # volumeBackup
    ########################################

    source = optional(object({
      type = optional(string, "empty")
      id   = optional(string)
    }), {})

    ########################################
    # Existing Backup Policy
    ########################################

    backup_policy_id = optional(string)

    ########################################
    # Destruction Protection Input
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
          "volume",
          "volumebackup"
        ],
        lower(volume.source.type)
      )
    ])

    error_message = "Block Volume source.type must be empty, volume, or volumeBackup."
  }

  ########################################
  # Source OCID Validation
  ########################################

  validation {
    condition = alltrue([
      for name, volume in var.block_volumes :
      lower(volume.source.type) == "empty"
      ||
      (
        contains(
          [
            "volume",
            "volumebackup"
          ],
          lower(volume.source.type)
        )
        &&
        try(trimspace(volume.source.id) != "", false)
      )
    ])

    error_message = "When source.type is volume or volumeBackup, source.id must contain the corresponding existing Block Volume or Block Volume Backup OCID."
  }

  ########################################
  # Volume Size Validation
  ########################################

  validation {
    condition = alltrue([
      for name, volume in var.block_volumes :
      volume.size_in_gbs >= 50 &&
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


########################################
# Volume Backups
########################################

variable "volume_backups" {
  description = "Manual Block Volume backup definitions"

  type = map(object({

    ########################################
    # Source Volume
    #
    # Exactly one:
    # volume_id OR volume_name
    ########################################

    volume_id   = optional(string)
    volume_name = optional(string)

    ########################################
    # Backup Configuration
    ########################################

    display_name   = optional(string)
    type           = optional(string, "FULL")
    compartment_id = optional(string)

    ########################################
    # Encryption
    ########################################

    kms_key_id = optional(string)

  }))

  default = {}

  ########################################
  # Backup Source Validation
  ########################################

  validation {
    condition = alltrue([
      for name, backup in var.volume_backups :
      (
        try(trimspace(backup.volume_id) != "", false)
        &&
        try(backup.volume_name, null) == null
      )
      ||
      (
        try(backup.volume_id, null) == null
        &&
        try(trimspace(backup.volume_name) != "", false)
      )
    ])

    error_message = "Each volume backup must specify exactly one of volume_id or volume_name."
  }

  ########################################
  # Backup Type Validation
  ########################################

  validation {
    condition = alltrue([
      for name, backup in var.volume_backups :
      contains(
        [
          "FULL",
          "INCREMENTAL"
        ],
        upper(backup.type)
      )
    ])

    error_message = "Volume backup type must be FULL or INCREMENTAL."
  }
}


########################################
# Volume Attachments
########################################

variable "volume_attachments" {
  description = "Block Volume iSCSI attachment definitions"

  type = map(object({

    ########################################
    # Volume Reference
    #
    # Exactly one:
    # volume_id OR volume_name
    ########################################

    volume_id   = optional(string)
    volume_name = optional(string)

    ########################################
    # Compute Reference
    #
    # Exactly one:
    # instance_id OR instance_name
    ########################################

    instance_id   = optional(string)
    instance_name = optional(string)

    ########################################
    # Attachment Configuration
    ########################################

    display_name                       = optional(string)
    attachment_type                    = optional(string, "iscsi")
    is_read_only                       = optional(bool, false)
    is_shareable                       = optional(bool, false)
    use_chap                           = optional(bool, false)
    is_agent_auto_iscsi_login_enabled  = optional(bool, true)
    encryption_in_transit_type         = optional(string)

  }))

  default = {}

  ########################################
  # Volume Reference Validation
  ########################################

  validation {
    condition = alltrue([
      for name, attachment in var.volume_attachments :
      (
        try(trimspace(attachment.volume_id) != "", false)
        &&
        try(attachment.volume_name, null) == null
      )
      ||
      (
        try(attachment.volume_id, null) == null
        &&
        try(trimspace(attachment.volume_name) != "", false)
      )
    ])

    error_message = "Each volume attachment must specify exactly one of volume_id or volume_name."
  }

  ########################################
  # Compute Reference Validation
  ########################################

  validation {
    condition = alltrue([
      for name, attachment in var.volume_attachments :
      (
        try(trimspace(attachment.instance_id) != "", false)
        &&
        try(attachment.instance_name, null) == null
      )
      ||
      (
        try(attachment.instance_id, null) == null
        &&
        try(trimspace(attachment.instance_name) != "", false)
      )
    ])

    error_message = "Each volume attachment must specify exactly one of instance_id or instance_name."
  }

  ########################################
  # Attachment Type Validation
  ########################################

  validation {
    condition = alltrue([
      for name, attachment in var.volume_attachments :
      lower(attachment.attachment_type) == "iscsi"
    ])

    error_message = "This Block Storage module currently supports iSCSI attachments only."
  }
}


########################################
# Compute Instance References
########################################

variable "compute_instance_ids" {
  description = "Map of logical Compute instance names to OCI instance OCIDs"
  type        = map(string)
  default     = {}
}
