resource "kubernetes_cron_job" "s3backup" {
  metadata {
    name      = "s3backup-${var.mongodb.service_name}"
    namespace = var.namespace
  }
  spec {
    concurrency_policy            = "Forbid"
    failed_jobs_history_limit     = 5
    schedule                      = var.schedule
    starting_deadline_seconds     = 10
    successful_jobs_history_limit = 7
    job_template {
      metadata {}
      spec {
        backoff_limit              = 2
        ttl_seconds_after_finished = 43200
        template {
          metadata {}
          spec {
            service_account_name = kubernetes_service_account.mongo_backup.metadata.0.name
            container {
              image             = "mumbley/ubuntu-etc:0.4-beta"
              name              = "ubuntu-etc"
              image_pull_policy = "IfNotPresent"
              command           = ["/bin/sh", "-c", "/root/backup.sh $MONGO_DB"]
              volume_mount {
                name       = "mongo-auth"
                mount_path = "/etc/mongo-auth"
              }
              env {
                name  = "MONGO_SVR_ADDR"
                value = "${var.deployment_name}-${var.mongodb.service_name}:${var.mongodb.port}"
              }
              env {
                name  = "REPLICA_SET" 
                value = var.mongodb.replica_set
              }
              env {
                name  = "MONGO_DB"
                value = var.mongodb.database
              }
              env {
                name  = "DEPLOYMENT_NAME"
                value = var.deployment_name
              }
              env {
                name  = "S3_BACKUP_BUCKET"
                value = "${var.s3_bucket_config.name}-${var.deployment_name}"
              }
            }
            volume {
              name = "mongo-auth"
              secret {
                secret_name = "${var.deployment_name}-mongodb"
              }
            }
          }
        }
      }
    }
  }
}
