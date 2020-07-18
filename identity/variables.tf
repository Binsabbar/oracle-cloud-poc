variable "project_name" { type = string }
variable "environment" { type = string }
variable "tenant_id" { type = string }

variable "compartments" {
  type = map(object({
    root = string
  }))
}

variable "enable_delete" {
  type    = bool
  default = true
}

variable "groups" {
  type = set(string)
  default = []
}
