include "kubeconfig" {
  path = "${get_repo_root()}/terraform/catalog/units/k8s-providers.hcl"
}

include "flux" {
  path = "${get_repo_root()}/terraform/catalog/units/flux-provider.hcl"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "${get_repo_root()}/terraform/catalog/modules/flux"
}

# Requires var.github_token for Flux bootstrapping
inputs = {
  github_org        = values.github_org
  github_repository = values.github_repository
  config_path       = values.config_path
  config_context    = values.config_context
  path              = values.path
}
