variable "network_compartment_id" { type = string }
variable "project_name" { type = string }
variable "environment" { type = string }
variable "dns_label" { type = string }
variable "allowed_ingress_ports" {
  type    = list
  default = [80, 443]
}
variable "public_net_security_list_ids" {
  type    = list
  default = []
}
variable "private_net_security_list_ids" {
  type    = list
  default = []
}