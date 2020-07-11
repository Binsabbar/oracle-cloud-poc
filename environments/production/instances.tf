locals {
  instances_configs = {
    "config-a" = {
      shape    = local.shapes.small
      image_id = local.images_ids.ubuntu_20
      subnet   = module.networking.network.private_subnet
      network_sgs_ids = [
        module.security_groups.security_groups_ids.private_subnet,
      ]
    }
    "config-b" = {
      shape    = local.shapes.standard
      image_id = local.images_ids.ubuntu_20
      subnet   = module.networking.network.private_subnet
      network_sgs_ids = [
        module.security_groups.security_groups_ids.private_subnet,
      ]
    }

    "config-public" = {
      shape    = local.shapes.small
      image_id = local.images_ids.ubuntu_20
      subnet   = module.networking.network.public_subnet
      network_sgs_ids = [
        module.security_groups.security_groups_ids.jumpbox,
      ]
    }
  }

  instances = {
    "jumpbox" = {
      config          = local.instances_configs["config-public"]
      volume_size     = 50
      autherized_keys = local.jumpbox_autherized_keys
    }
    "ms-1" = {
      config          = local.instances_configs["config-a"]
      volume_size     = 50
      autherized_keys = local.private_instances_autherized_keys
    }
    "ms-2" = {
      config          = local.instances_configs["config-b"]
      volume_size     = 50
      autherized_keys = local.private_instances_autherized_keys
    }
  }
}