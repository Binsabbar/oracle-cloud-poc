locals {
  project_name = "demo-oracle-cloud"
  environment  = "production"
}

module "root_compartments" {
  source = "../../identity"
  project_name = local.project_name
  environment  = local.environment
  tenant_id = var.tenancy_ocid
  compartments = {
    "networking-space" = {
      root = var.tenancy_ocid
    }
  }

  groups = toset(["network-admin", "group-a-admin", "group-b-admin", "group-c-admin"])
}

module "project_compartments" {
  source = "../../identity"
  project_name = local.project_name
  environment  = local.environment
  tenant_id = var.tenancy_ocid

  compartments = {
    "project-a-space" = {
      root = module.root_compartments.compartments["networking-space"].id
    },
    "project-b-space" = {
      root = module.root_compartments.compartments["networking-space"].id
    },
    "project-c-space" = {
      root = module.root_compartments.compartments["networking-space"].id
    },
  }
}