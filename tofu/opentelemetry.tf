# OpenTelemetry for collecting telemetry 

resource "kubernetes_namespace" "opentelemetry" {
  metadata {
    labels = {
      name = "opentelemetry"
    }
    name = "opentelemetry"
  }
}

resource "helm_release" "opentelemetry_collector" {
  name       = "opentelemetry-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  namespace  = kubernetes_namespace.opentelemetry.metadata[0].name

  set {
    name  = "image.repository"
    value = "otel/opentelemetry-collector-k8s"
  }

  set {
    name  = "mode"
    value = "deployment"
  }
}