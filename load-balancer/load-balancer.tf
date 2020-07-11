resource "oci_load_balancer_load_balancer" "load_balancer" {
  compartment_id             = var.compartment_id
  display_name               = "main"
  shape                      = var.shape
  subnet_ids                 = set([var.subnet_id])
  is_private                 = var.is_private
  network_security_group_ids = set(var.security_group_ids)
}
