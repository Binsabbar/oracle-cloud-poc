//oci_load_balancer_backend_set.http_backend_set.[group_a]

resource "oci_load_balancer_backend_set" "http_backend_set" {
  for_each         = var.http_configurations
  
  load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
  name             = each.key
  policy           = "LEAST_CONNECTIONS"

  health_checker {
    protocol          = "HTTP"
    port              = each.value.port
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


locals { 
  
  virutal_hosts = flatten([
    for backend_set, config in var.http_configurations: [
      for virtual_host in config.virtual_hosts: {
        backend_set = backend_set
        virtual_host = virtual_host
      }
    ]
  ])


  hostname_names_resource_ids = {
    for backend_set, config in var.http_configurations: 
      backend_set => for virtual_host in config.virutal_hosts: "${backend_set}-${virtual_host}"
  }

}

//oci_load_balancer_hostname.http_hostnames.[group_a_virtual_host]
resource "oci_load_balancer_hostname" "http_hostnames" {
  fore_each = 

  load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
  hostname         = each.key
  name             = each.key
  lifecycle {
    create_before_destroy = true
  }
}

resource "oci_load_balancer_listener" "http_listener" {
  fore_each = var.http_configurations

  load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
  default_backend_set_name = oci_load_balancer_backend_set.http_backend_set["${each.key}"].name
  hostname_names           = oci_load_balancer_hostname.http_hostnames[""].name
  name           = each.key
  port           = each.value.port
  protocol       = "HTTP"
}