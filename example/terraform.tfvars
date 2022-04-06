region          = "eu-west-1"
deployment_name = "foo"
s3_bucket = {
  name            = "dxp-backups"
  region          = "eu-west-1"
  acl             = "private"
  lifecycle_id    = "backup"
  enabled         = true
  expiration_days = 30
  tags = {
    "deployment" = "foo"
  }
}

namespace         = "foo"
oidc_provider_url = "https://oidc.eks.eu-west-1.amazonaws.com/id/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
oidc_provider_arn = "arn:aws:iam::322847702264:oidc-provider/oidc.eks.eu-west-1.amazonaws.com/id/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
backup            = true
schedule          = "1 0 * * *"

