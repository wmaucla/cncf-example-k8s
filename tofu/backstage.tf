resource "kubernetes_namespace" "backstage_namespace" {
  metadata {
    name = "backstage"
  }
}

resource "kubernetes_secret" "postgres_secrets" {
  metadata {
    name      = "postgres-secrets"
    namespace = "backstage"
  }
  type = "Opaque"

  data = {
    POSTGRES_USER     = "YmFja3N0YWdl"
    POSTGRES_PASSWORD = "aHVudGVyMg=="
  }
}

resource "kubernetes_persistent_volume_claim" "postgres_storage_claim" {
  metadata {
    name      = "backstage-postgres-storage-claim"
    namespace = "backstage"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "2Gi"
      }
    }
    storage_class_name = "backstage-postgres"
    volume_name        = kubernetes_persistent_volume.postgres_storage.metadata.0.name
  }
}

resource "kubernetes_persistent_volume" "postgres_storage" {
  metadata {
    name = "backstage-postgres-storage"
    labels = {
      type = "local"
    }
  }

  spec {
    capacity = {
      storage = "2Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_source {
      host_path {
        path = "/mnt/data"
        type = "DirectoryOrCreate"
      }
    }
    storage_class_name = "backstage-postgres"
    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = ["minikube"]
          }
        }
      }
    }
  }
}


resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = "postgres"
    namespace = "backstage"
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }

      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:13.2-alpine"

          env_from {
            secret_ref {
              name = "postgres-secrets"
            }
          }

          port {
            container_port = 5432
          }

          volume_mount {
            mount_path = "/var/lib/postgresql/data"
            name       = "postgresdb"
            sub_path   = "data"
          }
        }

        node_name = "minikube"

        volume {
          name = "postgresdb"
          persistent_volume_claim {
            claim_name = "backstage-postgres-storage-claim"
          }
        }
      }
    }
  }

  depends_on = [kubernetes_persistent_volume.postgres_storage,
  kubernetes_persistent_volume_claim.postgres_storage_claim]
}

resource "kubernetes_service" "postgres" {
  metadata {
    name      = "postgres"
    namespace = "backstage"
  }
  spec {
    selector = {
      app = "postgres"
    }
    port {
      port = 5432
    }
  }
}
