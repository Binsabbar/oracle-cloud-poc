
resource "oci_load_balancer_listener" "listener" {
  load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id

  default_backend_set_name = oci_load_balancer_backend_set.backend_set.name
  hostname_names           = oci_load_balancer_hostname.test_hostname.name[*].name
  path_route_set_name      = oci_load_balancer_path_route_set.path_route_set.name

  name           = "Main Listener"
  port           = "80"
  protocol       = "HTTP"
  rule_set_names = [oci_load_balancer_rule_set.rule_set.name]


  // TODO: Needed when backend Set is SSL enabled
  # ssl_configuration {
  #     certificate_name = oci_load_balancer_certificate.test_certificate.name
  #     verify_depth = var.listener_ssl_configuration_verify_depth
  #     verify_peer_certificate = var.listener_ssl_configuration_verify_peer_certificate
  # }
}