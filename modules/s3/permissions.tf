resource "kubernetes_role" "mongo_backup" {
  metadata {
    name      = "dxp-${var.deployment_name}-mongo-backup"
    namespace = var.namespace
  }

  rule {
    api_groups = [
      "",
    ]
    resources = [
      "configmaps",
      "pods",
      "secrets",
      "namespaces",
    ]
    verbs = [
      "get",
    ]
  }
}

resource "kubernetes_service_account" "mongo_backup" {
  metadata {
    name      = "${var.deployment_name}-mongo-backup"
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.s3backup.arn
    }
  }
}

resource "kubernetes_role_binding" "mongo_backup" {
  metadata {
    name      = "${var.deployment_name}-mongo-backup"
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.mongo_backup.metadata.0.name
  }


  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_role.mongo_backup.metadata.0.name
    namespace = var.namespace
  }

}