include "kubeconfig" {
  path = "${get_repo_root()}/terraform/catalog/units/k8s-providers.hcl"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/tinycloud-labs/tf-modules.git//metallb-cr?ref=0.3.8"

}

inputs = {
  ipv4_address_pool_name = values.ipv4_address_pool_name
  ipv4_address_pools     = values.ipv4_address_pools
  kube_namespace         = values.metallb_namespace
  config_path            = values.config_path
  config_context         = values.config_context
}
# NOTE:
# The dependency 'config_path' is evaluated relative to the directory
# where Terragrunt renders the stack (i.e., inside the `.terragrunt-stack/` folder),
# which is set by the stack file `unit.NAME.path` attribute
# not the original source tree in the catalog/modules/units.
# So, relative paths like "../csi-driver-nfs" may not resolve correctly
# depending on how the stack names and structures its units.
dependency "loadbalancer" {
    config_path = "../loadbalancer/"
    mock_outputs = {
        loadbalancer-mock-output = "loadbalancer-mock-output"
    }
}
