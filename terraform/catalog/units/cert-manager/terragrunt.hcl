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

# NOTE:
# The dependency 'config_path' is evaluated relative to the directory
# where Terragrunt renders the stack (i.e., inside the `.terragrunt-stack/` folder),
# which is set by the stack file `unit.NAME.path` attribute
# not the original source tree in the catalog/modules/units.
# So, relative paths like "../cert-manager-something" may not resolve correctly
# depending on how the stack names and structures its units.
dependency "cluster" {
  config_path = "../cluster/"
  mock_outputs = {
    cluster-outputs = "mock-cluster-outputs"
  }
}
