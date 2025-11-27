generate "proxmox_provider" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "proxmox" {
  endpoint = "https://10.10.50.20:8006/"
  username = "$${var.pve_user}@pam"
  password = var.pve_pwd
  # because of Proxmox's self-signed cert
  insecure = true
}

# Required providers block only. Terraform version is set in root.hcl
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.83.2"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.1"
    }
  }
}
EOF
}
