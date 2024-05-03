# ArgoCD used for CD

resource "kubernetes_namespace" "argo" {
  metadata {
    labels = {
      name = "argo"
    }
    name = "argo"
  }
}

resource "helm_release" "argo" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  version   = "6.7.18"
  namespace = kubernetes_namespace.argo.metadata[0].name

  depends_on = [kubernetes_namespace.argo]
}


data "local_file" "github_ssh_private_key" {
  # Normally some secret manager
  filename = "${path.module}/ssh-private-key.txt"
}


resource "kubernetes_secret" "repo_secret" {
  metadata {
    name      = "repo-422312180"
    namespace = kubernetes_namespace.argo.metadata[0].name

    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    name          = "python-api"
    project       = "default"
    sshPrivateKey = data.local_file.github_ssh_private_key.content
    type          = "git"
    url           = "git@github.com:wmaucla/python-api.git"
  }

  depends_on = [
    kubernetes_namespace.argo,
    data.local_file.github_ssh_private_key,
  ]
}