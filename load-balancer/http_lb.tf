locals {
  /*
  [
    { backend_set = group-a, server_ip = "10.0.0.1", port: 90 }, 
    { backend_set = group-a, server_ip = "10.0.0.2", port: 90 }, 
    { backend_set = group-b, server_ip = "10.0.1.1", port: 80 },
  ]
  */
  flattened_server_ips = flatten([
    for backend_set, config in var.http_configurations : [
      for server_ip in config.server_ips : {
        backend_set = backend_set
        server_ip   = server_ip
        port        = config.port
      }
    ]
  ])

  /*
  [
    {backend_set = group-a, virtual_host = example.com}, 
    {backend_set = group-a, virtual_host = *.example.com}
    {backend_set = group-b, virtual_host = abc.com}, 
    {backend_set = group-b, virtual_host = *.abc.com}
  ]
  */
  flattened_virtual_hosts = flatten([
    for backend_set, config in var.http_configurations : [
      for virtual_host in config.virtual_hosts : {
        backend_set  = backend_set
        virtual_host = virtual_host
      }
    ]
  ])

  /*
    {
      "group-a": ["group-a.example.com", "group-a.*.example.com"],
      "group-b": ["group-b.abc.com", "group-b.*.abc.com"],
    }
  */
  oci_load_balancer_hostname_ids = {
    for backend_set, config in var.http_configurations :
    "${backend_set}" => [for virtual_host in config.virtual_hosts : "${backend_set}.${virtual_host}"]
  }
}

resource "oci_load_balancer_backend_set" "http_backend_set" {
  for_each = var.http_configurations

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
}

resource "oci_load_balancer_backend" "http_backend" {
  for_each = { for v in local.flattened_server_ips : "${v.backend_set}.${v.server_ip}" => v }

  load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
  backendset_name  = oci_load_balancer_backend_set.http_backend_set[each.value.backend_set].name
  ip_address       = each.value.server_ip
  port             = each.value.port
}

resource "oci_load_balancer_hostname" "http_hostnames" {
  for_each = { for v in local.flattened_virtual_hosts : "${v.backend_set}.${v.virtual_host}" => v.virtual_host }

  load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
  hostname         = each.value
  name             = each.key
  lifecycle {
    create_before_destroy = true
  }
}

resource "oci_load_balancer_listener" "http_listener" {
  for_each = var.http_configurations

  load_balancer_id         = oci_load_balancer_load_balancer.load_balancer.id
  default_backend_set_name = oci_load_balancer_backend_set.http_backend_set["${each.key}"].name
  hostname_names           = [for resource_name in local.oci_load_balancer_hostname_ids[each.key] : oci_load_balancer_hostname.http_hostnames[resource_name].name]
  name                     = each.key
  port                     = each.value.port
  protocol                 = "HTTP"
}