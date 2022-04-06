variable "deployment_name" {
  type = string
}

variable "accountid" {
  type        = string
  description = "AWS account ID"
}

variable "s3_bucket_config" {
  type = object({
    name            = string
    acl             = string
    lifecycle_id    = string
    enabled         = bool
    expiration_days = number
    tags            = map(string)
  })
}

variable "oidc_provider_url" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "namespace" {
  type = string
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
}
