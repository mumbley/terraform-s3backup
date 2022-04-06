
variable "oidc_provider_url" {
  type        = string
  description = "OpenID Connect provider URL from the EKS cluster"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OpenID Connect provider ARN"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "deployment_name" {
  type        = string
  description = "Unique name for the deployment. This should match the deployment name of the environment to be backed up"
}

variable "s3_bucket" {
  type = object({
    name            = string
    region          = string
    acl             = string
    lifecycle_id    = string
    enabled         = bool
    expiration_days = number
    tags            = map(string)
  })
  description = "S3 bucket configuration requirements"
}

variable "namespace" {
  type        = string
  description = "Namespace containing the database. All items will be deployed in this namespace"
}

variable "backup" {
  type        = bool
  description = "Flag to set whether to install module or not. See README for a full explaination"
  default     = false
}

variable "schedule" {
  type        = string
  description = "cron schedule - defaults to 1 minute past midnight 24/7"
  default     = "1 0 * * *"
}

variable "mongodb" {
  type = object({
    service_name = string
    replica_set  = string
    port         = string
    database     = string
  })
  default = {
    service_name = "mongodb-headless"
    replica_set  = "rs0"
    port         = "27017"
    database     = "beekeeper-new"
  }
}
