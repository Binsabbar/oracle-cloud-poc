variable "compartment" { type = any }
variable "project_name" { type = string }
variable "environment" { type = string }
variable "vnc" { type = any }
variable "availability_domain" { type = map(any)}
variable "instances" {
  type        = map
  description = "map of instances configurations"
}

 