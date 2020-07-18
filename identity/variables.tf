variable "project_name" { type = string }
variable "environment" { type = string }
variable "enable_delete" {
  type = bool
  default = true
}

variable "compartments" {
  type = map(object({
    root = string
  }))
}
