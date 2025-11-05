include "kubeconfig" {
  path = "${get_repo_root()}/terraform/catalog/units/k8s-providers.hcl"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/tinycloud-labs/tf-modules.git//metallb?ref=0.3.8"

}

inputs = {
  metallb_namespace = values.metallb_namespace
  create_namespace  = values.create_namespace
  config_path       = values.config_path
  config_context    = values.config_context
}
