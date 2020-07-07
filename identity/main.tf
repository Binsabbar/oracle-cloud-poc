resource "oci_identity_compartment" "compartment" {
  for_each       = var.compartments
  name           = each.key
  description    = "compartment that holds PoCs resource using Terraform for prod"
  compartment_id = each.value.root
  freeform_tags = {
    "type"        = "identity"
    "managedby"   = "terraform"
    "environment" = var.environment
    "project"     = var.project_name
  }
}
