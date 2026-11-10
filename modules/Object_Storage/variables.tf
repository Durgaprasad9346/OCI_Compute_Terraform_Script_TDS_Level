
variable "default_compartment_id" {
  description = "Default OCI compartment OCID."
  type        = string
}

variable "default_defined_tags" {
  description = "Common defined tags applied to Object Storage resources."
  type        = map(string)
  default     = {}
}

variable "default_freeform_tags" {
  description = "Common freeform tags applied to Object Storage resources."
  type        = map(string)
  default     = {}
}

variable "buckets" {
  description = "Map of Object Storage bucket configurations."

  type = map(object({

    # Bucket configuration
    name           = optional(string)
    compartment_id = optional(string)
    versioning     = optional(string, "Enabled")
    storage_tier   = optional(string, "Standard")
    kms_key_id     = optional(string)
    metadata       = optional(map(string), {})

    # Bucket-specific tags
    defined_tags  = optional(map(string), {})
    freeform_tags = optional(map(string), {})

    # Lifecycle policies
    lifecycle_rules = optional(list(object({
      name        = string
      action      = string
      time_amount = number
      time_unit   = string
      target      = optional(string, "objects")
      is_enabled  = optional(bool, true)

      object_name_filter = optional(object({
        inclusion_prefixes = optional(list(string), [])
        inclusion_patterns = optional(list(string), [])
        exclusion_patterns = optional(list(string), [])
      }))
    })), [])

    # Retention rules
    retention_rules = optional(list(object({
      display_name = string

      time_amount = number
      time_unit   = string

      time_rule_locked = optional(string)
    })), [])

    # Logging configuration
    logging = optional(object({
      enabled               = optional(bool, true)
      create_log_group      = optional(bool, true)
      log_group_name        = optional(string)
      existing_log_group_id = optional(string)
      log_name              = optional(string)
      log_category          = optional(string, "write")
      retention_duration    = optional(number, 90)
    }), {})

    # Cross-region replication
    replication = optional(object({
      enabled                 = optional(bool, false)
      policy_name             = optional(string)
      destination_region_name = optional(string)
      destination_bucket_name = optional(string)
    }), {})

  }))

  default = {}

  # -----------------------------------------------------
  # Versioning validation
  # -----------------------------------------------------

  validation {
    condition = alltrue([
      for bucket in values(var.buckets) :
      contains(["Enabled", "Disabled"], bucket.versioning)
    ])

    error_message = "Versioning must be Enabled or Disabled."
  }

  # -----------------------------------------------------
  # Storage tier validation
  # -----------------------------------------------------

  validation {
    condition = alltrue([
      for bucket in values(var.buckets) :
      contains(["Standard", "Archive"], bucket.storage_tier)
    ])

    error_message = "Storage tier must be Standard or Archive."
  }

  # -----------------------------------------------------
  # Logging validation
  # -----------------------------------------------------

  validation {
    condition = alltrue([
      for bucket in values(var.buckets) :
      !bucket.logging.enabled ? true : (
        bucket.logging.create_log_group
        ? try(trimspace(bucket.logging.existing_log_group_id) == "", true)
        : try(trimspace(bucket.logging.existing_log_group_id) != "", false)
      )
    ])

    error_message = "For enabled logging, choose a new log group or provide an existing log group OCID."
  }

  # -----------------------------------------------------
  # Logging category validation
  # -----------------------------------------------------

  validation {
    condition = alltrue([
      for bucket in values(var.buckets) :
      contains(["read", "write"], bucket.logging.log_category)
    ])

    error_message = "Logging category must be read or write."
  }

  # -----------------------------------------------------
  # Logging retention validation
  # -----------------------------------------------------

  validation {
    condition = alltrue([
      for bucket in values(var.buckets) :
      contains(
        [30, 60, 90, 120, 150, 180],
        bucket.logging.retention_duration
      )
    ])

    error_message = "Log retention must be 30, 60, 90, 120, 150, or 180 days."
  }

  # -----------------------------------------------------
  # Lifecycle validation
  # -----------------------------------------------------

  validation {
    condition = alltrue(flatten([
      for bucket in values(var.buckets) : [
        for rule in bucket.lifecycle_rules :
        contains(
          ["ARCHIVE", "INFREQUENT_ACCESS", "DELETE", "ABORT"],
          rule.action
        ) &&
        contains(
          ["objects", "previous-object-versions", "multipart-uploads"],
          rule.target
        ) &&
        (
          rule.action == "ABORT"
          ? rule.target == "multipart-uploads"
          : rule.target != "multipart-uploads"
        )
      ]
    ]))

    error_message = "Invalid lifecycle action or target. ABORT is only valid for multipart-uploads."
  }

  # -----------------------------------------------------
  # Replication validation
  # -----------------------------------------------------

  validation {
    condition = alltrue([
      for bucket in values(var.buckets) :
      !bucket.replication.enabled ? true : (
        try(trimspace(bucket.replication.policy_name) != "", false) &&
        try(trimspace(bucket.replication.destination_region_name) != "", false) &&
        try(trimspace(bucket.replication.destination_bucket_name) != "", false)
      )
    ])

    error_message = "Enabled replication requires a policy name, destination region, and destination bucket name."
  }
}
