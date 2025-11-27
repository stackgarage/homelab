generate "flux_provider" {
  path      = "flux_providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
# Required providers block only. Terraform version is set in root.hcl
terraform {
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "~> 1.2"
    }
  }
}

provider "flux" {
  kubernetes = {
    config_path = var.config_path
  }
  git = {
    url = "https://github.com/$${var.github_org}/$${var.github_repository}.git"
    http = {
      username = "git" # This can be any string when using a personal access token
      password = var.github_token
    }
  }
}

EOF
}
