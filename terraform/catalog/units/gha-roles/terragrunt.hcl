include "k8s-providers" {
  path = "${get_repo_root()}/terraform/catalog/units/k8s-providers.hcl"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/tinycloud-labs/tf-modules.git//gha-roles?ref=0.3.8"
}

# NOTE:
# The dependency 'config_path' is evaluated relative to the directory
# where Terragrunt renders the stack (i.e., inside the `.terragrunt-stack/` folder),
# which is set by the stack file `unit.NAME.path` attribute
# not the original source tree in the catalog/modules/units.
# So, relative paths like "../csi-driver-nfs" may not resolve correctly
# depending on how the stack names and structures its units.
dependency "gha-runner" {
  config_path = "../gha-runner/"
  # mock outputs for 'plan' or 'validate' when the dependency hasn't been applied yet
  mock_outputs = {
    runner_name    = "mock-runner"
    kube_namespace = "mock-namespace"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  # Inject parent outputs into child inputs
  runner_service_account_namespace = dependency.gha-runner.outputs.kube_namespace
  runner_service_account_name      = dependency.gha-runner.outputs.runner_name
  role_name                        = dependency.gha-runner.outputs.runner_name

  # any other local values
  target_namespaces = values.target_namespaces
  config_path       = values.config_path
  config_context    = values.config_context
}
