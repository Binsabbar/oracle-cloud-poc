output "security_groups_ids" {
  value = {
    jumpbox        = oci_core_network_security_group.safe_ips_network_sg.id
    private_subnet = oci_core_network_security_group.private_subnet_network_sg.id
  }
}
