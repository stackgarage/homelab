generate "k8s_providers" {
  path      = "k8s_providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "helm" {
  kubernetes = {
    config_path = var.config_path
    config_context = var.config_context
  }
}

provider "kubernetes" {
  config_path = var.config_path
  config_context = var.config_context
}
EOF
}
