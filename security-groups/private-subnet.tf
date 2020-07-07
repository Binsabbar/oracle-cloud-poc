resource "oci_core_network_security_group" "private_subnet_network_sg" {
  compartment_id = var.compartment.id
  vcn_id         = var.vnc.id
  display_name   = "privateSubnetAccess"
  freeform_tags = {
    "project"     = var.project_name
    "type"        = "subnet"
    "managedby"   = "terraform"
    "environment" = var.environment
  }
}

resource "oci_core_network_security_group_security_rule" "allow_public_subnet_sg_rule" {
  network_security_group_id = oci_core_network_security_group.private_subnet_network_sg.id
  description               = "Allow All"
  direction                 = "INGRESS"
  protocol                  = local.protocols.tcp
  source                    = var.vnc.cidr_block
  source_type               = "CIDR_BLOCK"
  stateless                 = false
}
