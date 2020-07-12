variable "project_name" { type = string }
variable "environment" { type = string }
variable "compartments" {
  type = map(object({
    root = string
  }))
}
