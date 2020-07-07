variable "safe_ips" {
  type    = list
  default = [""]
}

variable "vnc" { type = any }
variable "compartment" { type = any }
variable "project_name" { type = string }
variable "environment" { type = string }
