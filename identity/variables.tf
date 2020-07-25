variable "project_name" { type = string }
variable "environment" { type = string }
variable "tenant_id" { type = string }

variable "compartments" {
  type = map(object({
    root_compartment = string
    policies         = set(string)
  }))
}

variable "enable_delete" {
  type    = bool
  default = true
}

variable "memberships" {
  type    = map(set(string))
  default = {}
}

variable "tenancy_policies" {
  type = object({
    name     = string
    policies = set(string)
  })
  default = null
}