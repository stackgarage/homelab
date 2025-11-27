#
# Provisions K3s cluster. Calls the K3s Ansible playbooks as an after deployment hook.
#
include "proxmox" {
  path = "${get_repo_root()}/terraform/catalog/units/proxmox-provider.hcl"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

# --- Stack vars and inputs ----
inputs = {
  proxmox_node_name = values.proxmox_node_name
  disk_name         = values.disk_name
  cloud_image_info  = values.cloud_image_info
  description       = values.description
  cluster           = values.cluster
  env               = values.env
}

locals {
  env = values.env
}

# --- Execution block ----
terraform {
  source = "${get_repo_root()}/terraform/catalog/modules/proxmox/cluster"

  after_hook "ansible_install_collections" {
    commands    = ["apply"]
    working_dir = "${get_repo_root()}/ansible"
    execute = [
      "ansible-galaxy",
      "collection",
      "install",
      "-r",
      "requirements.yml"
    ]
    run_on_error = false
  }

  after_hook "ansible_run_playbook" {
    commands    = ["apply"]
    working_dir = "${get_repo_root()}/ansible"
    execute = [
      "ansible-playbook",
      "-i", "inventory/${local.env}/k3s.yml",
      "k3s_site.playbook.yml"
    ]
    run_on_error = false
  }
}
