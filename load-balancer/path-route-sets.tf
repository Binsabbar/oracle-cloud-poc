# resource "oci_load_balancer_path_route_set" "path_route_set" {
#   load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
#   name             = "Default-RuleSet"
#   path_routes {
#     backend_set_name = oci_load_balancer_backend_set.backend_set.name
#     path             = "/"
#     path_match_type {
#       match_type = "PREFIX_MATCH"
#     }
#   }
# }