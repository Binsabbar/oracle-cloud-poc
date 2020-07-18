resource "oci_identity_compartment" "compartments" {
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
  enable_delete = var.enable_delete
}
