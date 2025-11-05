include "kubeconfig" {
  path = "${get_repo_root()}/terraform/catalog/units/k8s-providers.hcl"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/tinycloud-labs/tf-modules.git//csi-driver-nfs?ref=0.3.8"

}

inputs = {
  config_path    = values.config_path
  config_context = values.config_context
}
