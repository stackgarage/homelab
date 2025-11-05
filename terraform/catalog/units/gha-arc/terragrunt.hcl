include "kubeconfig" {
  path = "${get_repo_root()}/terraform/catalog/units/k8s-providers.hcl"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/tinycloud-labs/tf-modules.git//gha-arc?ref=0.3.8"
}

inputs = {
  config_path                = values.config_path
  config_context             = values.config_context
  shared_labels              = values.shared_labels
  github_app_id              = get_env("TF_VAR_github_app_id")
  github_app_installation_id = get_env("TF_VAR_github_app_installation_id")
  github_app_private_key     = get_env("TF_VAR_github_app_private_key")
}

# NOTE:
# The dependency 'config_path' is evaluated relative to the directory
# where Terragrunt renders the stack (i.e., inside the `.terragrunt-stack/` folder),
# which is set by the stack file `unit.NAME.path` attribute
# not the original source tree in the catalog/modules/units.
# So, relative paths like "../cert-manager-something" may not resolve correctly
# depending on how the stack names and structures its units.
dependency "cert-manager" {
  config_path = "../cert-manager/"
  mock_outputs = {
    cert-manager_output = "mock-cert-manager-output"
  }
}
