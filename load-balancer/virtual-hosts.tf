resource "oci_load_balancer_hostname" "hostnames" {
  fore_each        = var.virtual_hosts
  
  load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
  hostname         = each.key
  name             = each.key
  lifecycle {
    create_before_destroy = true
  }
}