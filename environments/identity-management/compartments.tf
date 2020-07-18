locals {
  project_name = "demo-oracle-cloud"
  environment  = "production"
  users = {
    user1 = "user1"
    user2 = "user2"
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
    }
  }

  memberships = {
    "network-admin" = toset([local.users.user1])
    "group-a-admin" = toset([local.users.user2])
    "group-b-admin" = toset([local.users.user2])
    "group-c-admin" = toset([local.users.user1])
  }
}

module "project_compartments" {
  source       = "../../identity"
  project_name = local.project_name
  environment  = local.environment
  tenant_id    = var.tenancy_ocid

  compartments = {
    "project-a-space" = { root = module.root_compartments.compartments["networking-space"].id },
    "project-b-space" = { root = module.root_compartments.compartments["networking-space"].id },
    "project-c-space" = { root = module.root_compartments.compartments["networking-space"].id },
  }
}