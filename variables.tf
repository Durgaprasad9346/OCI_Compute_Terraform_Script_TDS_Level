########################################
# Region
########################################

variable "region" {

  description = "OCI region"

  type = string

}


########################################
# Environment
########################################

variable "environment" {

  description = "Deployment environment"

  type = string

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
# Default Compartment
########################################

variable "default_compartment_id" {

  description = "Default OCI compartment OCID"

  type = string

}


########################################
# Default Defined Tags
########################################

variable "default_defined_tags" {

  description = "Default OCI defined tags"

  type = map(string)

  default = {}

}


########################################
# Default Freeform Tags
########################################

variable "default_freeform_tags" {

  description = "Default OCI freeform tags"

  type = map(string)

  default = {}

}


########################################
# Compute Instances
########################################

variable "instances" {

  description = "Compute instance definitions"

  type = any

  default = {}

}


########################################
# Boot Volumes
#
# Used for:
#
# Create a new Boot Volume from an
# existing Boot Volume Backup.
########################################

variable "boot_volumes" {

  description = "Boot Volume definitions"

  type = any

  default = {}

}


########################################
# Manual Boot Volume Backups
#
# Used for:
#
# Taking multiple manual Boot Volume
# backups during patch / maintenance.
########################################

variable "boot_volume_backups" {

  description = "Manual Boot Volume backup definitions"

  type = any

  default = {}

}


########################################
# Block Volumes
#
# Used for:
#
# 1. Create new Block Volume
# 2. Create Block Volume from backup
########################################

variable "block_volumes" {

  description = "Block Volume definitions"

  type = any

  default = {}

}


########################################
# Block Volume Backups
#
# Used for:
#
# Taking multiple manual backups of
# existing Block Volumes.
########################################

variable "volume_backups" {

  description = "Manual Block Volume backup definitions"

  type = any

  default = {}

}


########################################
# Block Volume Attachments
#
# Used for:
#
# Attaching Block Volumes to Compute
# instances.
########################################

variable "volume_attachments" {

  description = "Block Volume attachment definitions"

  type = any

  default = {}

}
