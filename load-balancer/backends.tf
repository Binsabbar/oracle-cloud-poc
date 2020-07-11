resource "oci_load_balancer_backend" "backend" {
  load_balancer_id = ci_load_balancer_load_balancer.load_balancer.id
  backendset_name  = oci_load_balancer_backend_set.backend_set.name
  ip_address       = var.backend.ip
  port             = var.backend.port
}