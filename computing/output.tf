output "instances_ips" {
  value = {
    public_ip   = { for k, instance in oci_core_instance.instances : k => instance.public_ip }
    private_ips = { for k, instance in oci_core_instance.instances : k => instance.private_ip }
  }
}
