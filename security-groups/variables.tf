variable "project_name" { type = string }
variable "environment" { type = string }

variable "vnc" {
  type = object({
    id         = string
    cidr_block = string
  })
}

variable "compartment" {
  type = object({
    id = string
  })
}

variable "safe_ips" {
  type    = list(string)
  default = [""]
}