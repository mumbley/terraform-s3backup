terraform {
  backend "kubernetes" {
    namespace        = "kube-system"
    secret_suffix    = "dxp-k8s-mongodb-backup"
    load_config_file = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}
provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

module "s3_backup_bucket" {
  count             = var.backup == true ? 1 : 0
  source            = "../modules/s3"
  accountid         = data.aws_caller_identity.current.account_id
  deployment_name   = var.deployment_name
  s3_bucket_config  = var.s3_bucket
  oidc_provider_url = var.oidc_provider_url
  oidc_provider_arn = var.oidc_provider_arn
  namespace         = var.namespace
  schedule          = var.schedule

  mongodb = var.mongodb
}

