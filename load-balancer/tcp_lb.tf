resource "oci_load_balancer_backend_set" "tcp_backend_set" {
  for_each         = var.tcp_configurations

  load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
  name             = each.key
  policy           = "LEAST_CONNECTIONS"

  health_checker {
    protocol          = "TCP"
    interval_ms       = "60000"
    retries           = 3
    return_code       = 200
    timeout_in_millis = 3000
    url_path          = "/health"
  }

  dynamic "backend" {
    for_each = each.value.server_ips

    content {
      ip_address = backend.value
      port       = each.value.port
    }
  }
}

resource "oci_load_balancer_hostname" "tcp_hostnames" {
  fore_each = var.virtual_hosts

  load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
  hostname         = each.key
  name             = each.key
  lifecycle {
    create_before_destroy = true
  }
}

resource "oci_load_balancer_listener" "tcp_listener" {
  fore_each = var.https_configurations

  load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
  default_backend_set_name = oci_load_balancer_backend_set.backend_set.name
  hostname_names           = oci_load_balancer_hostname.http_hostnames[""].name
  name           = each.key
  port           = each.value.port
  protocol       = "HTTPS"
}