resource "kubernetes_namespace" "flux" {
  metadata {
    name = var.kubernetes_namespace
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "flux_bootstrap_git" "this" {
  path      = var.path
  namespace = kubernetes_namespace.flux.metadata[0].name

  # Prevent deleting Flux app-releases
  delete_git_manifests = false
  depends_on           = [kubernetes_namespace.flux]
}
