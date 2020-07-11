resource "oci_load_balancer_backend_set" "backend_set" {
  load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
  name             = "main-backend-set"
  policy           = "LEAST_CONNECTIONS"
  health_checker {
    protocol          = "HTTP"
    interval_ms       = "60000"
    retries           = 3
    return_code       = 200
    timeout_in_millis = 3000
    url_path          = "/health"
  }

  # TODO: Needed for HTTPS connection
  # ssl_configuration {
  #     certificate_name = oci_load_balancer_certificate.test_certificate.certificate_name
  #     verify_depth = 3
  #     verify_peer_certificate = true
  # }
}