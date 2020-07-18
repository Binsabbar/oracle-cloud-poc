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


resource "oci_identity_group" "groups" {
  for_each = var.groups

  compartment_id = var.tenant_id
  description    = each.key
  name           = each.key

  freeform_tags = {
    "type"        = "identity groups"
    "managedby"   = "terraform"
    "environment" = var.environment
    "project"     = var.project_name
  }
}
