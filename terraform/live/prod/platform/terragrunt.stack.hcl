locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl"))
}

unit "loadbalancer" {
  source = "${get_repo_root()}/terraform/catalog/units/loadbalancer"
  path   = "loadbalancer"
  values = {
    metallb_namespace = "metallb-system"
    create_namespace  = true
    config_path       = local.common.locals.kubeconfig_path
    config_context    = local.common.locals.kubeconfig_context
  }
}

unit "csi-driver" {
  source = "${get_repo_root()}/terraform/catalog/units/csi-driver-nfs"
  path   = "csi-driver"
  values = {
    config_path    = local.common.locals.kubeconfig_path
    config_context = local.common.locals.kubeconfig_context
  }
}

unit "nfs-storageclass" {
  source = "${get_repo_root()}/terraform/catalog/units/nfs-storageclass"
  path   = "nfs-storageclass"
  values = {
    class_name     = "nfs-client"
    server         = "10.10.50.38"
    share          = "/volume1/k3s-main"
    config_path    = local.common.locals.kubeconfig_path
    config_context = local.common.locals.kubeconfig_context
  }
}

unit "metallb-cr" {
  source = "${get_repo_root()}/terraform/catalog/units/metallb-cr"
  path   = "metallb-cr"
  values = {
    metallb_namespace      = "metallb-system"
    ipv4_address_pool_name = "default-pool"
    ipv4_address_pools     = ["10.10.50.96-10.10.50.97"]
    config_path            = local.common.locals.kubeconfig_path
    config_context         = local.common.locals.kubeconfig_context
  }
}

unit "nginx-ingress" {
  source = "${get_repo_root()}/terraform/catalog/units/nginx-ingress"
  path   = "nginx-ingress"
  values = {
    kube_namespace = "nginx-ingress"
    config_path    = local.common.locals.kubeconfig_path
    config_context = local.common.locals.kubeconfig_context
  }
}

unit "flux" {
  source = "${get_repo_root()}/terraform/catalog/units/flux"
  path   = "flux"
  values = {
    github_org        = "tinycloud-labs"
    github_repository = "flux"
    # github_token      = ""
    config_path    = local.common.locals.kubeconfig_path
    config_context = local.common.locals.kubeconfig_context
    path           = "clusters/prod"
  }
}
