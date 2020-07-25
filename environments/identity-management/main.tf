locals {
  project_name = "demo-oracle-cloud"
  environment  = "production"
  users = {
    user1 = "user1"
    user2 = "user2"
  }
  groups = {
    network_admin = "network_admin"
    a_admin       = "a-admin"
    a_users       = "a-users"
    b_admin       = "b-admin"
    b_users       = "b-users"
    c_admin       = "c-admin"
    c_users       = "c-users"
  }
}

module "root_compartments" {
  source       = "../../identity"
  project_name = local.project_name
  environment  = local.environment
  tenant_id    = var.tenancy_ocid
  compartments = {
    "networking-space" = {
      root_compartment = var.tenancy_ocid
      policies = [
        "Allow group ${local.groups.network_admin} to manage virtual-network-family in compartment networking-space",
        "Allow group ${local.groups.network_admin} to manage instance-family in compartment networking-space",
        "Allow group ${local.groups.a_admin},${local.groups.b_admin},${local.groups.c_admin} to use virtual-network-family in compartment networking-space",
        "Allow group ${local.groups.a_users},${local.groups.b_users},${local.groups.c_users} to inspect virtual-network-family in compartment networking-space",
      ]
    }
  }

  memberships = {
    "${local.groups.network_admin}" = toset([local.users.user1])
    "${local.groups.a_admin}"       = toset([local.users.user2])
    "${local.groups.b_admin}"       = toset([local.users.user2])
    "${local.groups.c_admin}"       = toset([local.users.user1])
    "${local.groups.a_users}"       = toset([])
    "${local.groups.b_users}"       = toset([])
    "${local.groups.c_users}"       = toset([])
  }

    tenancy_policies = {
    name = "admins"
    policies = [
      "Allow group ${local.groups.a_admin},${local.groups.b_admin},${local.groups.c_admin} to inspect users in tenancy",
      "Allow group ${local.groups.a_admin},${local.groups.b_admin},${local.groups.c_admin} to inspect groups in tenancy",
      
      "Allow group ${local.groups.a_admin} to use users in tenancy where target.group.name='a_users'",
      "Allow group ${local.groups.a_admin} to use groups in tenancy where target.group.name='a_users'",

      "Allow group ${local.groups.b_admin} to use users in tenancy where target.group.name='b_users'",
      "Allow group ${local.groups.b_admin} to use groups in tenancy where target.group.name='b_users'",

      "Allow group ${local.groups.c_admin} to use users in tenancy where target.group.name='c_users'",
      "Allow group ${local.groups.c_admin} to use groups in tenancy where target.group.name='c_users'",
    ]
  }
}

module "project_compartments" {
  source       = "../../identity"
  project_name = local.project_name
  environment  = local.environment
  tenant_id    = var.tenancy_ocid

  compartments = {
    "project-a-space" = {
      root_compartment = module.root_compartments.compartments["networking-space"].id
      policies = [
        "Allow group ${local.groups.a_admin} to manage all-resources in compartment project-a-space",
        "Allow group ${local.groups.a_users} to use instance-family in compartment project-a-space",
        "Allow group ${local.groups.a_users} to use volume-family in compartment project-a-space"
      ]
    },
    "project-b-space" = {
      root_compartment = module.root_compartments.compartments["networking-space"].id
      policies = [
        "Allow group ${local.groups.b_admin} to manage all-resources in compartment project-b-space",
        "Allow group ${local.groups.b_users} to use instance-family in compartment project-a-space",
        "Allow group ${local.groups.b_users} to use volume-family in compartment project-a-space"
      ]
    },
    "project-c-space" = {
      root_compartment = module.root_compartments.compartments["networking-space"].id
      policies = [
        "Allow group ${local.groups.c_admin} to manage all-resources in compartment project-c-space",
        "Allow group ${local.groups.c_users} to use instance-family in compartment project-a-space",
        "Allow group ${local.groups.c_users} to use volume-family in compartment project-a-space"
      ]
    },
  }
}