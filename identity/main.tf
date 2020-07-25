locals {
  /*
  [
    {member = user1, group = group1},
    {member = user2, group = group1},
    {member = user1, group = group2}
  ]
  */
  flattened_memberships = flatten([
    for group, members in var.memberships : [
      for member in members : {
        member = member
        group  = group
      }
    ]
  ])

  groups = [for group in keys(var.memberships) : oci_identity_group.groups[group]]
}

resource "oci_identity_compartment" "compartments" {
  for_each       = var.compartments
  name           = each.key
  description    = "compartment that holds PoCs resource using Terraform for prod"
  compartment_id = each.value.root_compartment
  freeform_tags = {
    "type"        = "identity"
    "managedby"   = "terraform"
    "environment" = var.environment
    "project"     = var.project_name
  }
  enable_delete = var.enable_delete
}

resource "oci_identity_group" "groups" {
  for_each = var.memberships

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

resource "oci_identity_user" "users" {
  for_each = toset(flatten(values(var.memberships)))

  compartment_id = var.tenant_id
  description    = each.key
  name           = each.key

  freeform_tags = {
    "type"        = "identity users"
    "managedby"   = "terraform"
    "environment" = var.environment
    "project"     = var.project_name
  }
}

resource "oci_identity_user_group_membership" "user_group_membership" {
  for_each = { for membership in local.flattened_memberships : "${membership.group}-${membership.member}" => membership }

  group_id = oci_identity_group.groups[each.value.group].id
  user_id  = oci_identity_user.users[each.value.member].id
}

resource "oci_identity_policy" "policies" {
  for_each = { for compartment, config in var.compartments : compartment => config if length(config.policies) > 0 }

  compartment_id = oci_identity_compartment.compartments[each.key].id
  description    = "Managed By Terraform"
  name           = "${each.key}-policy"
  statements     = each.value.policies

  depends_on = [local.groups]
}

resource "oci_identity_policy" "tenancy_policies" {
  for_each = var.tenancy_policies != null ? { "${var.tenancy_policies.name}" = var.tenancy_policies.policies } : {}

  compartment_id = var.tenant_id
  description    = "Managed By Terraform"
  name           = each.key
  statements     = each.value

  depends_on = [local.groups]
}