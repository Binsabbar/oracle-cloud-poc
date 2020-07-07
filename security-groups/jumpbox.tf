locals {
  protocols = {
    icmp = 1
    tcp  = 6
    udp  = 17
  }
}

resource "oci_core_network_security_group" "safe_ips_network_sg" {
  compartment_id = var.compartment.id
  vcn_id         = var.vnc.id
  display_name   = "safeIPs"
  freeform_tags = {
    "project"     = var.project_name
    "type"        = "security-group"
    "managedby"   = "terraform"
    "environment" = var.environment
  }
}

resource "oci_core_network_security_group_security_rule" "safe_ips_ssh_sg_rule" {
  for_each                  = toset(var.safe_ips)
  network_security_group_id = oci_core_network_security_group.safe_ips_network_sg.id
  description               = "SSH From Safe Addresses"
  direction                 = "INGRESS"
  protocol                  = local.protocols.tcp
  source                    = each.key
  source_type               = "CIDR_BLOCK"
  stateless                 = false

  tcp_options {
    destination_port_range {
      max = 22
      min = 22
    }
  }
}
