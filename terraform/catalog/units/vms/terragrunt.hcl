#
# Provisions a barebones VM group. No Ansible playbooks hooks.
#
include "proxmox" {
  path = "${get_repo_root()}/terraform/catalog/units/proxmox-provider.hcl"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  proxmox_node_name = values.proxmox_node_name
  disk_name         = values.disk_name
  cloud_image_info  = values.cloud_image_info
  description       = values.description
  cluster           = values.cluster
}

terraform {
  source = "${get_repo_root()}/terraform/catalog/modules/proxmox/cluster"
}
