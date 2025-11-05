include "k8s-providers" {
  path = "${get_repo_root()}/terraform/catalog/units/k8s-providers.hcl"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  kube_namespace = values.kube_namespace
  config_path    = values.config_path
  config_context = values.config_context
}

terraform {
  source = "git::https://github.com/tinycloud-labs/tf-modules.git//cert-manager?ref=0.3.8"
}
