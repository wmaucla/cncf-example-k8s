terraform {
  required_version = "~>1.7.0"

  required_providers {
    helm = "~>2.13"
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~>1.14"
    }
    kubernetes = "~>2.29"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}