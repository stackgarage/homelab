locals {
  node_specs = {
    small  = { memory = 4096, cores = 2, disk_size = 50 }
    medium = { memory = 8192, cores = 2, disk_size = 50 }
    large  = { memory = 16384, cores = 4, disk_size = 50 }
  }
  expanded = flatten([
    for c in var.cluster : [
      for i in range(c.count) : {
        name = c.name
        size = c.size
        idx  = i
        mac  = try(c.macs[i], null) # safely look up MAC if provided
      }
    ]
  ])
}

module "cluster" {
  for_each = { for c in local.expanded : "${c.name}-${c.idx}" => c }

  source              = "git::https://github.com/tinycloud-labs/tf-modules.git//proxmox/vm?ref=0.3.7"
  hostname            = "${each.value.name}-${each.value.idx}"
  memory              = local.node_specs[each.value.size].memory
  cores               = local.node_specs[each.value.size].cores
  disk_size           = local.node_specs[each.value.size].disk_size
  proxmox_node_name   = var.proxmox_node_name
  disk_name           = var.disk_name
  ssh_public_key_path = var.id_rsa_pub
  timezone            = var.timezone
  cloud_image_info    = var.cloud_image_info
  sockets             = 1
  description         = var.description
  mac_address         = each.value.mac
}
