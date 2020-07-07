
resource "oci_core_subnet" "public_subnet" {
  compartment_id             = var.network_compartment_id
  cidr_block                 = "192.168.1.0/24"
  prohibit_public_ip_on_vnic = false
  vcn_id                     = oci_core_vcn.vnc.id
  dhcp_options_id            = oci_core_default_dhcp_options.dhcp_options.id
  route_table_id             = oci_core_default_route_table.route_table.id
  dns_label                  = "public"
  display_name               = "publicSubnet"
  security_list_ids          = concat([oci_core_default_security_list.security_list.id], var.public_net_security_list_ids)
  freeform_tags = {
    "project"     = var.project_name
    "type"        = "subnet"
    "managedby"   = "terraform"
    "environment" = var.environment
  }
}

resource "oci_core_subnet" "private_subnet" {
  compartment_id             = var.network_compartment_id
  cidr_block                 = "192.168.100.0/24"
  prohibit_public_ip_on_vnic = true
  vcn_id                     = oci_core_vcn.vnc.id
  dhcp_options_id            = oci_core_default_dhcp_options.dhcp_options.id
  route_table_id             = oci_core_default_route_table.route_table.id
  security_list_ids          = concat([oci_core_default_security_list.security_list.id], var.private_net_security_list_ids)
  # TODO: Add internet gateway
  dns_label    = "private"
  display_name = "privateSubnet"
  freeform_tags = {
    "project"     = var.project_name
    "type"        = "subnet"
    "managedby"   = "terraform"
    "environment" = var.environment
  }
}
