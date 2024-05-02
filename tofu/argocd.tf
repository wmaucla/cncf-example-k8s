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
  namespace = "argo"

  depends_on = [kubernetes_namespace.argo]
}
