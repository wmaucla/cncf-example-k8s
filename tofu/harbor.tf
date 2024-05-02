# Harbor used for images

resource "kubernetes_namespace" "harbor" {
  metadata {
    labels = {
      name = "harbor"
    }
    name = "harbor"
  }
}

resource "helm_release" "harbor" {
  name       = "harbor"
  repository = "https://helm.goharbor.io"
  chart      = "harbor"
  namespace  = kubernetes_namespace.harbor.metadata[0].name

  depends_on = [kubernetes_namespace.harbor]
}
