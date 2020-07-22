locals {
  project_name = "demo-oracle-cloud"
  environment  = "production"
  users = {
    user1 = "user1"
    user2 = "user2"
  }
  groups = {
    network_admin = "network-admin"
    group_a_admin = "group-a-admin"
    group_b_admin = "group-b-admin"
    group_c_admin = "group-c-admin"
  }
}

module "root_compartments" {
  source       = "../../identity"
  project_name = local.project_name
  environment  = local.environment
  tenant_id    = var.tenancy_ocid
  compartments = {
    "networking-space" = {
      root = var.tenancy_ocid
      policies = [
        "Allow group ${local.groups.network_admin} to manage virtual-network-family in compartment networking-space",
        "Allow group ${local.groups.network_admin} to manage instance-family in compartment networking-space",
        "Allow group ${local.groups.group_a_admin},${local.groups.group_b_admin} to use virtual-network-family in compartment networking-space",
      ]
    }
  }

  memberships = {
    "${local.groups.network_admin}" = toset([local.users.user1])
    "${local.groups.group_a_admin}" = toset([local.users.user2])
    "${local.groups.group_b_admin}" = toset([local.users.user2])
    "${local.groups.group_c_admin}" = toset([local.users.user1])
  }
}

module "project_compartments" {
  source       = "../../identity"
  project_name = local.project_name
  environment  = local.environment
  tenant_id    = var.tenancy_ocid

  compartments = {
    "project-a-space" = {
      root = module.root_compartments.compartments["networking-space"].id
      policies = [
        "Allow group ${local.groups.group_a_admin} to manage all-resources in compartment project-a-space"
      ]
    },
    "project-b-space" = {
      root = module.root_compartments.compartments["networking-space"].id
      policies = [
        "Allow group ${local.groups.group_b_admin} to manage all-resources in compartment project-a-space"
      ]
    },
    "project-c-space" = {
      root = module.root_compartments.compartments["networking-space"].id
      policies = [
        "Allow group ${local.groups.group_c_admin} to manage all-resources in compartment project-a-space"
      ]
    },
  }
}