resource "oci_core_vcn" "vnc" {
  cidr_block     = "192.168.0.0/16"
  compartment_id = var.network_compartment_id
  display_name   = "${var.project_name}Vnc"
  dns_label      = "${var.dns_label}vnc"
  freeform_tags = {
    "project"     = var.project_name
    "type"        = "network"
    "managedby"   = "terraform"
    "environment" = var.environment
  }
}

resource "oci_core_default_dhcp_options" "dhcp_options" {
  manage_default_resource_id = oci_core_vcn.vnc.default_dhcp_options_id
  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.network_compartment_id
  vcn_id         = oci_core_vcn.vnc.id
  enabled        = true
  display_name   = "defaultInternetGateway"
  freeform_tags = {
    "project"     = var.project_name
    "type"        = "internet_gateway"
    "managedby"   = "terraform"
    "environment" = var.environment
  }
}

resource "oci_core_default_route_table" "route_table" {
  manage_default_resource_id = oci_core_vcn.vnc.default_route_table_id
  display_name               = "defaultRouteTable"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }

  freeform_tags = {
    "project"     = var.project_name
    "type"        = "route_table"
    "managedby"   = "terraform"
    "environment" = var.environment
  }
}

