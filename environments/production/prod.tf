locals {
  project_name = "demo-oracle-cloud"
  environment  = "production"
  compartment  = "poc-space"
}

data "oci_identity_availability_domain" "ad_1" {
  compartment_id = module.compartment.compartments[local.compartment].id
  ad_number      = 1
}

module "compartment" {
  source = "../../identity"

  project_name = local.project_name
  environment  = local.environment
  compartments = {
    "${local.compartment}" = {
      root = var.tenancy_ocid
    }
  }
}

module "networking" {
  source = "../../networking"

  project_name           = local.project_name
  environment            = local.environment
  network_compartment_id = module.compartment.compartments[local.compartment].id
  dns_label              = "production"
}

module "security_groups" {
  source = "../../security-groups"

  project_name = local.project_name
  environment  = local.environment
  compartment  = module.compartment.compartments[local.compartment]
  vnc          = module.networking.network.vnc
  safe_ips     = var.safe_ips
}

module "computing" {
  source = "../../computing"

  project_name        = local.project_name
  environment         = local.environment
  compartment         = module.compartment.compartments[local.compartment]
  vnc                 = module.networking.network.vnc
  availability_domain = data.oci_identity_availability_domain.ad_1
  instances           = local.instances
}

module "load_balancer_main" {
  source = "../../load-balancer"

  project_name        = local.project_name
  environment         = local.environment
  subnet_ids          = [module.networking.network.public_subnet.id]
  compartment         = module.compartment.compartments[local.compartment]
  name                = "production load balancer"
  http_configurations = local.http_configs
}