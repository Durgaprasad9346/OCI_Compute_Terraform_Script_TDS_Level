########################################
# Region
########################################

variable "region" {
  description = "OCI region"
  type        = string
}


########################################
# Environment
########################################

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition = contains(
      [
        "dev",
        "non-prod",
        "prod",
        "shared_it"
      ],
      lower(var.environment)
    )

    error_message = "Environment must be one of: dev, non-prod, prod, or shared_it."
  }
}


########################################
# Cross-Region Replication
########################################

variable "enable_cross_region_replication" {
  description = "Enable cross-region replication for managed Boot Volumes and Block Volumes"
  type        = bool
  default     = false
}


########################################
# Default Compartment
########################################

variable "default_compartment_id" {
  description = "Default OCI compartment OCID"
  type        = string
}


########################################
# Default Defined Tags
########################################

variable "default_defined_tags" {
  description = "Default defined tags"
  type        = map(string)
  default     = {}
}


########################################
# Default Freeform Tags
########################################

variable "default_freeform_tags" {
  description = "Default freeform tags"
  type        = map(string)
  default     = {}
}


########################################
# Compute Instances
########################################

variable "instances" {
  description = "Compute instance definitions"
  type        = any
  default     = {}
}


########################################
# Boot Volumes
########################################

variable "boot_volumes" {
  description = "Boot Volume definitions"
  type        = any
  default     = {}
}


########################################
# Manual Boot Volume Backups
########################################

variable "boot_volume_backups" {
  description = "Manual Boot Volume backup definitions"
  type        = any
  default     = {}
}


########################################
# Block Volumes
########################################

variable "block_volumes" {
  description = "Block Volume definitions"
  type        = any
  default     = {}
}


########################################
# Block Volume Backups
########################################

variable "volume_backups" {
  description = "Manual Block Volume backup definitions"
  type        = any
  default     = {}
}


########################################
# Block Volume Attachments
########################################

variable "volume_attachments" {
  description = "Block Volume attachment definitions"
  type        = any
  default     = {}
}
