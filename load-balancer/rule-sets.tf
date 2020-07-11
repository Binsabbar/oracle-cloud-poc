resource "oci_load_balancer_rule_set" "rule_set" {
  load_balancer_id = oci_load_balancer_load_balancer.load_balancer.id
  name             = "Main-ruleSet"
  items {
    action = "ALLOW"
    conditions {
      attribute_name  = "SOURCE_IP_ADDRESS"
      attribute_value = "0.0.0.0/32"
      operator        = "EXACT_MATCH"
    }
    description = "Allow All IPs"
  }
}