variable "region" {
  description = "OCI region"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition = contains(
      ["dev", "non-prod", "prod", "shared_it"],
      lower(var.environment)
    )

    error_message = "Environment must be one of: dev, non-prod, prod, or shared_it."
  }
}

variable "default_compartment_id" {
  description = "Default OCI compartment OCID"
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
  type        = any
  default     = {}
}
