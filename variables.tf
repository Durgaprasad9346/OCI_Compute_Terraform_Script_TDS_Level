variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "default_compartment_id" {
  type = string
}

variable "default_defined_tags" {
  type = map(string)
  default = {}
}

variable "default_freeform_tags" {
  type = map(string)
  default = {}
}
