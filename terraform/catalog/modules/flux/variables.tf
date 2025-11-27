variable "github_token" {
  description = "GitHub token"
  sensitive   = true
  type        = string
}

variable "github_org" {
  description = "GitHub organization"
  type        = string
  default     = "tinycloud-labs"
}

variable "github_repository" {
  description = "GitHub repository"
  type        = string
}


variable "config_context" {
  description = "The name of the kubeconfig context to use"
  type        = string
}

variable "config_path" {
  description = "Path to cluster kube config file"
  type        = string
}

variable "path" {
  description = "Path in repository to bind Flux to"
  type        = string
}

variable "kubernetes_namespace" {
  description = "Namespace for the Flux system"
  type        = string
  default     = "flux-system"
}
